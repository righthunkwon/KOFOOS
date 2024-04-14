package com.kofoos.api.image.controller;

import com.kofoos.api.image.ImageException;
import com.kofoos.api.image.service.ImageService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;

@RestController
@RequestMapping("/image")
@RequiredArgsConstructor
public class ImageController {

    private final ImageService imgService;

    @PostMapping
    public String uploadImg(@RequestParam MultipartFile multipartFile) throws IOException {
        imgService.uploadImg(multipartFile);
        return "업로드 성공";
    }


    @ExceptionHandler(value = ImageException.class)
    public String imageExceptionHandler(ImageException ix){
        return ix.getMessage();
    }



}
