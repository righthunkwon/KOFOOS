package com.kofoos.api.wishlist;

import com.kofoos.api.entity.Product;
import com.kofoos.api.wishlist.dto.FolderDto;
import com.kofoos.api.wishlist.dto.ProductDto;
import com.kofoos.api.common.dto.WishlistFolderDto;
import com.kofoos.api.wishlist.dto.WishlistDto;

import java.util.List;

public interface WishlistService {
    void like(int productId, String deviceId);

    void unlike(int productId, String deviceId);

    void moveItems(List<Integer> items, int wishlistFolderId);

    void cancel(List<Integer> itemIds);


   
    void create(String folderName, String deviceId);

    void delete(Integer folderId, String deviceId);

    List<FolderDto> findFolderList(String deviceId);

    List<WishlistDto> findFolder(int folderId);

    void check(List<Integer> itemIds, int bought);

    int findDefaultFolderId(String deviceId);

    void insertImage(String deviceId, int id ,int imageId);
}
