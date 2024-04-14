package com.kofoos.api.common.dto;

import com.kofoos.api.entity.History;
import com.kofoos.api.entity.User;
import com.kofoos.api.entity.UserDislikesMaterial;
import com.kofoos.api.entity.WishlistFolder;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Data;

import java.util.ArrayList;
import java.util.List;

@Data
@Builder
public class UserDto {

    private int id;
    private String deviceId;
    private String language;
//    private List<WishlistFolderDto> wishlistFolderDtos;
//    private List<UserDislikesMaterialDto> userDislikesMaterialDtos;
    private List<Integer> wishlistFolderDtos;
    private List<HistoryDto> historyDtos;
    private List<Integer> userDislikesMaterialDtos;


    public static UserDto of(User user){


//        List<WishlistFolderDto> wishlistFolderDtos = new ArrayList<>();
//        List<HistoryDto> historyDtos = new ArrayList<>();
//        List<UserDislikesMaterialDto> userDislikesMaterialDtos = new ArrayList<>();
//
//        for(WishlistFolder wishlistFolder : user.getWishlistFolders()){
//            wishlistFolderDtos.add(WishlistFolderDto.of(wishlistFolder));

        List<Integer> wishlistFolderDtos = new ArrayList<>();
        List<HistoryDto> historyDtos = new ArrayList<>();
        List<Integer> userDislikesMaterialDtos = new ArrayList<>();

        for(WishlistFolder wishlistFolder : user.getWishlistFolders()){
            wishlistFolderDtos.add(wishlistFolder.getId());
        }

        for(History history : user.getHistories()){
            historyDtos.add(HistoryDto.of(history));
        }

        for(UserDislikesMaterial userDislikesMaterial : user.getUserDislikesMaterials()){
//            userDislikesMaterialDtos.add(UserDislikesMaterialDto.of(userDislikesMaterial));
            userDislikesMaterialDtos.add(userDislikesMaterial.getId());

        }

        return UserDto.builder()
                .deviceId(user.getDeviceId())
                .language(user.getLanguage())
                .wishlistFolderDtos(wishlistFolderDtos)
                .historyDtos(historyDtos)
                .userDislikesMaterialDtos(userDislikesMaterialDtos)
                .build();
    }

}