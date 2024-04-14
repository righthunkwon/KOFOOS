package com.kofoos.api.User.dto;

import com.kofoos.api.common.dto.DislikedMaterialDto;
import com.kofoos.api.common.dto.HistoryDto;
import lombok.Builder;
import lombok.Data;

import java.util.List;

@Data
public class MyPageDto {
    private String language;
    private List<Integer> dislikedMaterials;
    private List<ProductDto> products;

    @Builder
    public MyPageDto(String language, List<Integer> dislikedMaterials, List<ProductDto> products) {
        this.language = language;
        this.dislikedMaterials = dislikedMaterials;
        this.products = products;
    }
}
