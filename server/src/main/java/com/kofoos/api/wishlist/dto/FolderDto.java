package com.kofoos.api.wishlist.dto;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import com.fasterxml.jackson.databind.ser.std.ToStringSerializer;
import lombok.Data;

import java.util.List;


@Data
public class FolderDto {
    private int folderId;
    private String folderName;
    private List<WishlistDto> items;

    public FolderDto(int folderId, String folderName) {
        this.folderId = folderId;
        this.folderName = folderName;
    }

    public void setItems(List<WishlistDto> items) {
        this.items = items;
    }
}
