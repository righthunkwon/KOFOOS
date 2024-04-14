package com.kofoos.api.recommendation.controller;

import com.kofoos.api.common.dto.ProductDto;
import com.kofoos.api.recommendation.dto.RecommendationRequestDto;
import com.kofoos.api.recommendation.dto.RecommendationResponseDto;
import com.kofoos.api.recommendation.dto.RecommendationWithNoAllergyResponseDto;
import com.kofoos.api.recommendation.service.RecommendationService;
import lombok.RequiredArgsConstructor;
import org.springframework.web.bind.annotation.*;

import java.util.List;


@RestController
@RequestMapping("/recommend")
@RequiredArgsConstructor
public class RecommendationController {

    private final RecommendationService rs;

    /**
    * [상품 페이지] 유사한 상품 추천 (알러지 필터링 X)
    **/
    @GetMapping("/product/{product_id}")
    public List<RecommendationResponseDto> getRelatedProductsByCategory(@PathVariable("product_id") int productId){
        return rs.getRelatedProductsByCategory(productId);
    }


    /**
    * [메인 페이지] 히스토리 기반
    * 사용자 히스토리에서 특정 기간 동안 가장 많이 나왔던 카테고리 (대분류, 중분류) 내에서 인기순 추천 (알러지 필터링 적용)
    * 히스토리가 없는 경우, 현재 1위 랭킹에 해당하는 카테고리 내에서 인기순 추천 (알러지 필터링 적용)
    **/
    @PostMapping("/history")
    public List<RecommendationResponseDto> getRelatedProductsByHistory(@RequestBody RecommendationRequestDto requestDto){
        String deviceId = requestDto.getDeviceId();
        return rs.getRelatedProductsByHistory(deviceId);
    }


    /**
     * [메인 페이지] 인기순 + 조회순 추천 (알러지 필터링 적용 X)
     **/
    @GetMapping("/hot")
    public List<RecommendationResponseDto> getHotProducts(){
        return rs.getHotProducts();
    }


    /**
     * 에디터 추천
     * */
    @GetMapping("/editor/{recommendation_article_id}")
    public List<RecommendationWithNoAllergyResponseDto> getEditorRecommendation(@PathVariable("recommendation_article_id") int rArticleId){
        return rs.getEditorRecommendation(rArticleId);
    }

}
