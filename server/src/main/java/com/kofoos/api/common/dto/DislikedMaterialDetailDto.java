package com.kofoos.api.common.dto;

import com.kofoos.api.entity.DislikedMaterial;
import com.kofoos.api.entity.DislikedMaterialDetail;
import jakarta.persistence.Column;
import jakarta.persistence.FetchType;
import jakarta.persistence.JoinColumn;
import jakarta.persistence.ManyToOne;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class DislikedMaterialDetailDto {

    private String detailName;
    private DislikedMaterialDto dislikedMaterialDto;


    public static DislikedMaterialDetailDto of(DislikedMaterialDetail dislikedMaterialdetail) {

        return DislikedMaterialDetailDto.builder()
                .detailName(dislikedMaterialdetail.getDetailName())
                .dislikedMaterialDto(DislikedMaterialDto.of(dislikedMaterialdetail.getDislikedMaterial()))
                .build();
    }
}
