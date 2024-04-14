package com.kofoos.api.wishlist.dto;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import lombok.Data;

@Data
public class WishlistDto {

    private int wishlistItemId;
    private int bought;
    private String itemNo;
    private String imageUrl;


    public WishlistDto(int wishlistItemId, int bought, String itemNo, String imageUrl) {
        this.wishlistItemId = wishlistItemId;
        this.bought = bought;
        this.itemNo = itemNo;
        this.imageUrl = imageUrl;
    }
}
