package com.kofoos.api.common.dto;

import com.kofoos.api.entity.Category;
import com.kofoos.api.entity.EditorProductsList;
import com.kofoos.api.entity.EditorRecommendationArticle;
import com.kofoos.api.entity.Product;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
@Builder
public class EditorProductsListDto {

    private ProductDto productDto;
    private EditorRecommendationArticleDto editorRecommendationArticleDto;

    public static EditorProductsListDto of(EditorProductsList editorProductsList) {
        return EditorProductsListDto.builder()
                .productDto(ProductDto.of(editorProductsList.getProduct()))
                .editorRecommendationArticleDto(EditorRecommendationArticleDto
                        .of(editorProductsList.getEditorRecommendationArticle()))
                .build();
    }

}
