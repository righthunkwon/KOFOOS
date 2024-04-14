package com.kofoos.api.history.dto;

import com.kofoos.api.entity.History;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class HistoryRegistDto {

    private String deviceId;
    private int productId;

    public static HistoryRegistDto of(History history){

        return HistoryRegistDto.builder()
                .deviceId(history.getUser().getDeviceId())
                .productId(history.getProduct().getId())
                .build();
    }



}
