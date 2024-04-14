package com.kofoos.api.recommendation.dto;

import com.kofoos.api.entity.DislikedMaterial;
import com.kofoos.api.entity.Product;
import com.kofoos.api.entity.ProductMaterial;
import lombok.Builder;
import lombok.Getter;

import java.util.ArrayList;
import java.util.List;

@Getter
@Builder
public class RecommendationWithNoAllergyResponseDto {

    private String itemNo;
    private String imgUrl;

    public static RecommendationWithNoAllergyResponseDto of(Product entity){
        return RecommendationWithNoAllergyResponseDto.builder()
                .itemNo(entity.getItemNo())
                .imgUrl((entity.getImage()==null)? null : entity.getImage().getImgUrl())
                .build();
    }

}
