package com.kofoos.api.User.dto;

import lombok.Builder;
import lombok.Data;
import lombok.EqualsAndHashCode;

import java.time.LocalDateTime;

@Data
@Builder
@EqualsAndHashCode(of = {"productUrl", "productItemNo"})
public class ProductDto implements Comparable<ProductDto>{
    private String productUrl; // 이미지 URL
    private String productItemNo; // 제품 Item No
    private LocalDateTime date;

    @Override
    public int compareTo(ProductDto o) {
        return o.date.compareTo(this.date);
    }


    // 생성자, 게터, 세터 등은 Lombok @Data와 @Builder가 자동으로 처리
}

