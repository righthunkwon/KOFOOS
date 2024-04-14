package com.kofoos.api.history.dto;

import com.kofoos.api.entity.History;
import com.kofoos.api.product.dto.CategorySearchDto;
import com.kofoos.api.product.dto.ProductDetailDto;
import lombok.*;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Getter
@Setter
@Builder
@ToString
public class HistoryProductDto {

    private String barcode;
    private String name;
    private LocalDateTime createdAt;
    private String imgUrl;
    private String deviceId;
    private String itemNo;
    private int productId;
    private int userId;


    public static HistoryProductDto of(History history){
        return HistoryProductDto.builder()
                .barcode(history.getProduct().getBarcode())
                .name(history.getProduct().getName())
                .userId(history.getUser().getId())
                .productId(history.getProduct().getId())
//                .imgUrl(history.getProduct().getImage().getImgUrl())
                .deviceId(history.getUser().getDeviceId())
                .itemNo(history.getProduct().getItemNo())
                .createdAt(history.getViewTime())
                .build();
    }


}
