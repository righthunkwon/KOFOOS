package com.kofoos.api.common.dto;

import com.kofoos.api.entity.DislikedMaterial;
import com.kofoos.api.entity.User;
import com.kofoos.api.entity.UserDislikesMaterial;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class UserDislikesMaterialDto {


    private int id;
    private UserDto userDto;
    private DislikedMaterialDto dislikedMaterialDto;


    public static UserDislikesMaterialDto of(UserDislikesMaterial userDislikesMaterial) {
        return UserDislikesMaterialDto.builder()
                .userDto(UserDto.of(userDislikesMaterial.getUser()))
                .dislikedMaterialDto(DislikedMaterialDto.of(userDislikesMaterial.getDislikedMaterial()))
                .build();
    }
}