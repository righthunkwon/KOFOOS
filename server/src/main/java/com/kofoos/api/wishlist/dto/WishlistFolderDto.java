package com.kofoos.api.wishlist.dto;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import com.kofoos.api.entity.Product;
import lombok.Data;

import java.util.List;

@Data
@JsonSerialize(using = ToStringSerializer.class)
public class WishlistFolderDto {
    private int folderId;
    private String folderName;
    private List<ProductDto> products;

    public WishlistFolderDto(int folderId, List<ProductDto> products) {
        this.folderId = folderId;
        this.products = products;
    }

}
