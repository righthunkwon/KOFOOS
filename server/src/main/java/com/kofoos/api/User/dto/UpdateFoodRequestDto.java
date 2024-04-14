package com.kofoos.api.User.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.List;

@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class UpdateFoodRequestDto {

    private String deviceId;
    private List<Integer> dislikedFoods;
}
