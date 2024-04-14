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
public class RecommendationResponseDto {

    private String itemNo;
    private String imgUrl;
    private List<String> allergyInfo;

    public static RecommendationResponseDto of(Product entity){
        return RecommendationResponseDto.builder()
                .itemNo(entity.getItemNo())
                .imgUrl((entity.getImage()==null)? null : entity.getImage().getImgUrl())
                .allergyInfo((entity.getProductMaterials()==null)?
                        new ArrayList<>() :
                        entity.getProductMaterials().stream()
                                .map(ProductMaterial::getDislikedMaterial)
                                .map(DislikedMaterial::getName)
                                .toList()
                ).build();
    }

}
