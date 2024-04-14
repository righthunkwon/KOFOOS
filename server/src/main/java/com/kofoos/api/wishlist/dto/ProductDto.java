package com.kofoos.api.wishlist.dto;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import lombok.Data;

@Data
@JsonSerialize(using = ToStringSerializer.class)
public class ProductDto {
    private int productId;
    private String imageUrl;

    public ProductDto(int productId, String imageUrl) {
        this.productId = productId;
        this.imageUrl = imageUrl;
    }

    // Getters and setters
}
