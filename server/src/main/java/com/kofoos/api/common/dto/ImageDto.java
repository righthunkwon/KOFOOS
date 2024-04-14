package com.kofoos.api.common.dto;

import com.kofoos.api.entity.Image;
import com.kofoos.api.entity.Product;
import com.kofoos.api.entity.WishlistItem;
import jakarta.persistence.Column;
import jakarta.persistence.OneToOne;
import lombok.Builder;
import lombok.Data;

@Data
@Builder
public class ImageDto {

    private int id;
    private String imgUrl;
//    private WishlistItemDto wishlistItemDto;



    public static ImageDto of(Image image){
        return ImageDto.builder()
                .imgUrl(image.getImgUrl())
                .build();
    }



}

