package com.kofoos.api.common.dto;

import com.kofoos.api.entity.EditorProductsList;
import com.kofoos.api.entity.EditorRecommendationArticle;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Data
@Builder
public class EditorRecommendationArticleDto {

    private String subject;
    private String content;
    private Date registrationTime;
    private String image;
    private List<EditorProductsListDto> editorProductsListDtos;


    public static EditorRecommendationArticleDto of(EditorRecommendationArticle editorRecommendationArticle) {

        List<EditorProductsListDto> editorProductsListDtos = new ArrayList<>();

        for(EditorProductsList editorProductsList : editorRecommendationArticle.getEditorProductsList()){
            editorProductsListDtos.add(EditorProductsListDto.of(editorProductsList));
        }

        return EditorRecommendationArticleDto.builder()
                .subject(editorRecommendationArticle.getSubject())
                .content(editorRecommendationArticle.getContent())
                .registrationTime(editorRecommendationArticle.getRegistrationTime())
                .image(editorRecommendationArticle.getImage())
                .editorProductsListDtos(editorProductsListDtos)
                .build();
    }
}
