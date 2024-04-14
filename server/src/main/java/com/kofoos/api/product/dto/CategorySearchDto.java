package com.kofoos.api.product.dto;

import com.kofoos.api.entity.Category;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class CategorySearchDto {

    private String cat1;
    private String cat2;
    private String cat3;
    private String cat4;


    public static CategorySearchDto of(Category category){
        return CategorySearchDto.builder()
                .cat1(category.getCat1())
                .cat2(category.getCat2())
                .cat3(category.getCat3())
                .cat4(category.getCat4())
                .build();
    }
}
