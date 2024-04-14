package com.kofoos.api.image.service;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.model.CannedAccessControlList;
import com.amazonaws.services.s3.model.ObjectMetadata;
import com.amazonaws.services.s3.model.PutObjectRequest;
import com.amazonaws.services.s3.model.PutObjectResult;
import com.kofoos.api.entity.Image;
import com.kofoos.api.entity.Product;
import com.kofoos.api.image.ImageException;
import com.kofoos.api.repository.ImageRepository;
import com.kofoos.api.repository.ProductRepository;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.PropertySource;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.UUID;

@Service
@RequiredArgsConstructor
@PropertySource("classpath:aws_s3.properties")
public class ImageServiceImpl implements ImageService {

    private final ProductRepository pr;
    private final ImageRepository ir;
    private final AmazonS3 amazonS3;
    @Value("${aws_s3_secret_bucketName}")
    private String bucketName;

    @Transactional
    @Override
    public void uploadImg(MultipartFile multipartFile) throws ImageException {
        // S3 업로드
        // 1. original 이름 => item_no 찾기
        //    DB에 이미 저장된 이미지가 있는 경우 return
        // 2. UUID로 이미지 이름 생성
        // 3. S3버킷에 저장
        String originalName = multipartFile.getOriginalFilename();
        String itemNo = originalName.substring(0, originalName.indexOf("_"));
        Product searchedProduct = pr.findProductByItemNo(itemNo).orElseThrow(()->
                    new ImageException("DB에 존재하지 않는 아이템입니다."));
        if(searchedProduct.getImage()!=null){
            throw new ImageException("해당 제품의 이미지는 이미 업로드 되었습니다.");
        }

        String ext = originalName.substring(originalName.lastIndexOf("."));
        String newName = UUID.randomUUID().toString().concat(String.format("_%s", originalName));

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentType(String.format("image/%s",ext));
        try{
            PutObjectResult putObjectResult = amazonS3.putObject(new PutObjectRequest(
                    bucketName, newName, multipartFile.getInputStream(), metadata
            ).withCannedAcl(CannedAccessControlList.PublicRead));
        } catch(IOException e) {
            throw new ImageException("S3 이미지 업로드 에러");
        }


        // DB에 업로드
        // 1. url 제품 테이블에 저장
        String imgUrl = amazonS3.getUrl(bucketName , newName).toString();
        Image image = Image.builder().imgUrl(imgUrl).build();
        image.setProduct(searchedProduct);

        searchedProduct.setImage(image);
        ir.save(image);
    }


    @Override
    public int saveImage(MultipartFile multipartFile,String itemNo) throws IOException {
        String originalName = multipartFile.getOriginalFilename();



        String ext = originalName.substring(originalName.lastIndexOf("."));
        String newName = UUID.randomUUID().toString().concat(String.format("_%s", originalName));

        ObjectMetadata metadata = new ObjectMetadata();
        metadata.setContentType(String.format("image/%s",ext));
        try{
            PutObjectResult putObjectResult = amazonS3.putObject(new PutObjectRequest(
                    bucketName, newName, multipartFile.getInputStream(), metadata
            ).withCannedAcl(CannedAccessControlList.PublicRead));
        } catch(IOException e) {
            throw new ImageException("S3 이미지 업로드 에러");
        }

        // DB에 업로드
        // 1. url 제품 테이블에 저장
        String imgUrl = amazonS3.getUrl(bucketName , newName).toString();
        Image image = Image.builder().imgUrl(imgUrl).build();


        Image im = ir.save(image);
        System.out.println("이미지 id: "+im.getId());


        return im.getId();
    }
}
