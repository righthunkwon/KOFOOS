package com.kofoos.api.common.dto;

import com.kofoos.api.entity.Category;
import com.kofoos.api.entity.Product;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
@Builder
public class CategoryDto {


    private String cat1;
    private String cat2;
    private String cat3;
    private String cat4;
    private List<ProductDto> productDtos;

    public static CategoryDto of(Category category){

        List<ProductDto> productDtos = new ArrayList<>();

        for(Product product:category.getProducts()){
            productDtos.add(ProductDto.of((product)));
        }

        return CategoryDto.builder()
                .cat1(category.getCat1())
                .cat2(category.getCat2())
                .cat3(category.getCat3())
                .cat4(category.getCat4())
                .build();
    }


}
