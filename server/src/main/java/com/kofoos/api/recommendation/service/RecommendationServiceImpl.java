package com.kofoos.api.recommendation.service;

import com.kofoos.api.entity.Category;
import com.kofoos.api.entity.History;
import com.kofoos.api.entity.Product;

import com.kofoos.api.entity.User;
import com.kofoos.api.recommendation.RecommendationException;
import com.kofoos.api.recommendation.dto.RecommendationResponseDto;
import com.kofoos.api.recommendation.dto.RecommendationWithNoAllergyResponseDto;
import com.kofoos.api.repository.CategoryRepository;
import com.kofoos.api.repository.HistoryRepository;
import com.kofoos.api.repository.ProductRepository;
import com.kofoos.api.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;
import java.util.stream.Collectors;
import java.util.stream.Stream;

@Slf4j
@Service
@RequiredArgsConstructor
public class RecommendationServiceImpl implements RecommendationService {

    private final ProductRepository pr;
    private final HistoryRepository hr;
    private final CategoryRepository cr;


    @Transactional(readOnly = true)
    @Override
    public List<RecommendationResponseDto> getRelatedProductsByCategory(int productId) {
        // 1. 아이템의 카테고리를 찾는다.
        Product searchedProduct = pr.findById(productId).orElseThrow(()->new RecommendationException("item이 존재하지 않습니다."));
        Category category = searchedProduct.getCategory();

        // 2. 해당 대분류-중분류 카테고리에 해당하는 아이템을 인기순으로 최대 10개까지 보낸다
        List<RecommendationResponseDto> recommendationDtos
                = pr.findRelatedProductsOrderByLike(category.getCat1(), category.getCat2(), PageRequest.of(0, 10))
                .stream()
                    .map((entity)-> RecommendationResponseDto.of(entity))
                .toList();
        return recommendationDtos;
    }

    @Transactional(readOnly = true)
    @Override
    public List<RecommendationResponseDto> getHotProducts() {
        // 제품을 인기순 + 조회순으로 정렬하여 최대 10개까지 보낸다.
        List<RecommendationResponseDto> recommendationDtos
                = pr.findHotProductsOrderByLikeAndHit(PageRequest.of(0, 10)).stream()
                    . map((entity)-> RecommendationResponseDto.of(entity))
                .toList();
        return recommendationDtos;
    }

    @Transactional(readOnly = true)
    @Override
    public List<RecommendationResponseDto> getRelatedProductsByHistory(String deviceId) {

        Map<String, Long> counters =  hr.findTop10ByDeviceIdOrderByViewTimeDesc(deviceId).stream()
                .map(History::getProduct)
                .map(Product::getCategory)
                .map(cat -> (String.format("%s_%s", cat.getCat1(), cat.getCat2())))
                .collect(Collectors.groupingBy(String::toLowerCase, Collectors.counting()));

        // 알러지 필터링 적용하여 해당 카테고리 내의 제품을 좋아요 순으로 10개 추천한다.
        List<RecommendationResponseDto> recommendationDtos = null;

        try{
            Map.Entry<String, Long> entry =counters.entrySet().stream()
                    .max(Map.Entry.comparingByValue())
                    .orElseThrow(() -> new RecommendationException("No History"));

            String[] categorySplited = entry.getKey().split("_");
            recommendationDtos = pr.findRelatedProductsOrderByLikeWithAllergyFiltering(categorySplited[0], categorySplited[1], deviceId, PageRequest.of(0, 10))
                    .stream()
                    .map((entity)-> RecommendationResponseDto.of(entity))
                    .toList();
        } catch (RecommendationException rx){
            log.info("err msg: {}, recommend products by hot category", rx.getMessage());
            List<String> hotCategory = cr.ranking();
            recommendationDtos = pr.findRelatedProductsOrderByLikeWithAllergyFiltering(hotCategory.get(0), hotCategory.get(1), deviceId, PageRequest.of(0, 10))
                    .stream()
                    .map((entity)-> RecommendationResponseDto.of(entity))
                    .toList();
        }

        return recommendationDtos;
    }

    @Transactional(readOnly = true)
    @Override
    public List<RecommendationWithNoAllergyResponseDto> getEditorRecommendation(int rArticleId) {

        List<RecommendationWithNoAllergyResponseDto> recommendationDtos
                = pr.findProductsByArticleId(rArticleId, PageRequest.of(0, 5))
                .stream()
                .map((entity)-> RecommendationWithNoAllergyResponseDto.of(entity))
                .toList();
        return recommendationDtos;
    }
}
