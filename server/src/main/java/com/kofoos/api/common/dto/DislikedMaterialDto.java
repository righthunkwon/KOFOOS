package com.kofoos.api.common.dto;

import com.kofoos.api.entity.DislikedMaterial;
import com.kofoos.api.entity.DislikedMaterialDetail;
import com.kofoos.api.entity.ProductMaterial;
import com.kofoos.api.entity.UserDislikesMaterial;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
@Builder
public class DislikedMaterialDto {


    private int id;
    private String name;
    private List<ProductMaterialDto> productMaterialDtos;
    private List<UserDislikesMaterialDto> userDislikesMaterialDtos;
    private List<DislikedMaterialDetailDto> dislikedMaterialdetailDtos;


    public static DislikedMaterialDto of(DislikedMaterial dislikedMaterial){

        List<ProductMaterialDto> productMaterialDtos = new ArrayList<>();
        List<DislikedMaterialDetailDto> dislikedMaterialdetailDtos = new ArrayList<>();
        List<UserDislikesMaterialDto> userDislikesMaterialDtos = new ArrayList<>();

        for(ProductMaterial productMaterial : dislikedMaterial.getProductMaterials()){
            productMaterialDtos.add(ProductMaterialDto.of(productMaterial));
        }

        for(DislikedMaterialDetail dislikedMaterialDetail : dislikedMaterial.getDislikedMaterialDetailList()){
            dislikedMaterialdetailDtos.add(DislikedMaterialDetailDto.of(dislikedMaterialDetail));
        }

        for(UserDislikesMaterial userDislikesMaterial : dislikedMaterial.getUserDislikesMaterials()){
            userDislikesMaterialDtos.add(UserDislikesMaterialDto.of(userDislikesMaterial));
        }

        return DislikedMaterialDto.builder()
                .name(dislikedMaterial.getName())
                .productMaterialDtos(productMaterialDtos)
                .dislikedMaterialdetailDtos(dislikedMaterialdetailDtos)
                .userDislikesMaterialDtos(userDislikesMaterialDtos)
                .build();

    }

}
