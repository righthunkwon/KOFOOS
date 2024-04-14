package com.kofoos.api.wishlist.dto;

import com.kofoos.api.common.dto.ImageDto;
import com.kofoos.api.common.dto.WishlistFolderDto;
import com.kofoos.api.common.dto.WishlistItemDto;
import com.kofoos.api.entity.Image;
import com.kofoos.api.entity.WishlistItem;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class WishlistDetectionDto {
    private int bought;
    private int productId;
    private int imageId;
    private int folderId;


    public WishlistDetectionDto( int bought, int productId, int imageId, int folderId) {
        this.bought = bought;
        this.productId = productId;
        this.imageId = imageId;
        this.folderId=folderId;
    }

//    public static WishlistItem of(WishlistDetectionDto wishlistItemDto){
//        Image image = Image.builder().id(wishlistItemDto.getImageId()).build();
//
//        return WishlistItem.builder()
//                .bought(wishlistItemDto.getBought())
//                .image(image)
//                .wishlistFolder(WishlistFolderDto.of((wishlistItemDto.getWishlistFolder())))
//                .build();
//    }



}
