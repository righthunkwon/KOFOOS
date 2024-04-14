package com.kofoos.api.recommendation.service;

import com.kofoos.api.recommendation.dto.RecommendationResponseDto;
import com.kofoos.api.recommendation.dto.RecommendationWithNoAllergyResponseDto;

import java.util.List;


public interface RecommendationService {
    List<RecommendationResponseDto> getRelatedProductsByCategory(int productId);
    List<RecommendationResponseDto> getHotProducts();
    List<RecommendationResponseDto> getRelatedProductsByHistory(String deviceId);
    List<RecommendationWithNoAllergyResponseDto> getEditorRecommendation(int rArticleId);
}
