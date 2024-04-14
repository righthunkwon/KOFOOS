package com.kofoos.api.product.service;

import com.kofoos.api.entity.Product;
import com.kofoos.api.product.dto.ProductBoxDto;
import com.kofoos.api.product.dto.ProductDetailDto;
import com.kofoos.api.repository.ProductRepository;
import jakarta.persistence.EntityNotFoundException;
import jakarta.transaction.Transactional;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
@Transactional
public class ProductService {

    private final ProductRepository productRepository;

    @Transactional
    public ProductDetailDto findProductByBarcode(String barcode){
        System.out.println("barcode = " + barcode);
        Optional<Product> optional = productRepository.findProductByBarcode(barcode);
        if(optional.isEmpty()){
            ProductDetailDto product = ProductDetailDto.builder()
                    .name("-")
                    .build();
            return product;
        }
        Product product = optional.get();
        product.addHit();
        return ProductDetailDto.of(product);
    }
    @Transactional
    public ProductDetailDto findProductByItemNo(String itemNo){
        Optional<Product> optional = productRepository.findProductByItemNo(itemNo);
        if(optional.isEmpty()){
            throw new EntityNotFoundException();
        }
        Product product = optional.get();
        product.addHit();
        return ProductDetailDto.of(product);
    }
    @Transactional
    public Optional<Product> findProductByItemNoOrNone(String itemNo){
        Optional<Product> optional = productRepository.findProductByItemNo(itemNo);

        return optional;
    }



    public List<ProductBoxDto> findProductsOrder(int id, String order){

        if(order.equals("좋아요")){
            List<Product> products = productRepository.findProductsOrderByLike(id);
            return products.stream().map(ProductBoxDto::of).collect(Collectors.toList());
        }
        else{
            List<Product> products = productRepository.findProductsOrderByHit(id);
            return products.stream().map(ProductBoxDto::of).collect(Collectors.toList());
        }
    }




//    @PostConstruct
//    public void updateGptTag() throws IOException {
//            ClassPathResource resource = new ClassPathResource("snack.csv");
//            List<ProductGpt> gpt = Files.readAllLines(resource.getFile().toPath(), StandardCharsets.UTF_8)
//                    .stream()
//                    .map(line -> {
//                        String[] split = line.split(",");
//                        return ProductGpt.builder()
//                                .itemNo(split[0])
//                                .tagString(split[2])
//                                .description(split[3])
//                                .build();
//                    }).collect(Collectors.toList());
//            for(ProductGpt productGpt : gpt){
//                System.out.println("productGpt.getItemNo() = " + productGpt.getItemNo());
//                productRepository.updateGptTag(productGpt.getItemNo(),productGpt.getTagString(),productGpt.getDescription());
////                System.out.println("productGpt.getItemNo().length()+ productGpt.getTagString().length()+productGpt.getDescription().length() = " + productGpt.getItemNo().length()+ productGpt.getTagString().length()+productGpt.getDescription().length());
////                System.out.println("productGpt.getTagString().length() = " + productGpt.getDescription().length());
//            }
//        }



}
