package com.kofoos.api.common.dto;

import com.kofoos.api.entity.Image;
import com.kofoos.api.entity.Product;
import com.kofoos.api.entity.WishlistFolder;
import com.kofoos.api.entity.WishlistItem;
import jakarta.persistence.*;
import lombok.Builder;
import lombok.Data;

@Data@Builder
public class WishlistItemDto {

    private int id;
    private Integer bought;
    private ProductDto productDto;
    private ImageDto imageDto;
    private WishlistFolderDto wishlistFolderDto;

    public static WishlistItemDto of(WishlistItem wishlistItem){
        return WishlistItemDto.builder()
                .bought(wishlistItem.getBought())
//                .imageDto(ImageDto.of(wishlistItem.getImage()))
                .wishlistFolderDto(WishlistFolderDto.of((wishlistItem.getWishlistFolder())))
                .build();
    }

    public void updateBought(Integer bought) {
        this.bought=bought;
    }
}
