package com.kofoos.api;

import com.amazonaws.services.s3.model.AmazonS3Exception;
import com.kofoos.api.image.ImageException;
import com.kofoos.api.image.service.ImageService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.apache.commons.io.IOUtils;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.security.servlet.SecurityAutoConfiguration;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.scheduling.annotation.EnableScheduling;


import java.io.*;


@Slf4j
@EnableScheduling
@SpringBootApplication(exclude = SecurityAutoConfiguration.class)
@RequiredArgsConstructor
public class ApiApplication {

	public static void main(String[] args) {

		SpringApplication.run(ApiApplication.class, args);
	}

//	private final ImageService imgService;
//
//	@PostConstruct
//	private void imgUpload(){
//		// 1. 폴더의 이미지들을 불러오기
//		String MAIN_DIR_PATH  = "D:\\dataset\\상품 이미지\\images\\train";
//		File mainDir = new File(MAIN_DIR_PATH);
//		File[] mainDirs = mainDir.listFiles();
//
////		Arrays.stream(mainDirs).forEach((dir) -> System.out.println(dir));
//
//		int mlen = mainDirs.length;
//		int cnt = 0;
//		for(int i=0; i< mlen; ++i){
//			File[] subdirs = mainDirs[i].listFiles(); // 과자1, 과자2 ,...
//			int slen = subdirs.length;
//			for(int j=0; j < slen; ++j){
//				File f = subdirs[j]; // 해태포키(폴더임)
//				String productName = f.getName();
//				String itemNo = productName.split("_")[0];
//				File[] imgList = f.listFiles((File file, String fileName)->(fileName.contains("_s_1.jpg")));
//				try{
//					MultipartFile img = getMultipartFile(imgList[0]);
//					imgService.uploadImg(img);
//					++cnt;
//					log.info("[success] file name: {}\n", img.getOriginalFilename());
//				} catch (IOException | ImageException | AmazonS3Exception ex){
//					log.info("[service error]file name: {}, err msg: {}\n", ex.getMessage());
//				} catch (ArrayIndexOutOfBoundsException nx){
//					log.info("[img open error]no img {}\n", nx.getMessage());
//				}
//			}
//		}
//		log.info("cnt: {}\n", cnt);
//	}
//
//	private MultipartFile getMultipartFile(File imgFile) throws IOException {
//		try {
//			FileInputStream input = new FileInputStream(imgFile);
//			MultipartFile multipartFile = new MockMultipartFile("file", imgFile.getName(), "image/jpeg", IOUtils.toByteArray(input));
//			return multipartFile;
//		} catch (IOException ex) {
//			ex.printStackTrace();
//			return null;
//		}
//	}
}
