package com.kofoos.api.repository;

import com.kofoos.api.entity.WishlistItem;
import com.kofoos.api.wishlist.dto.ProductDto;
import com.kofoos.api.wishlist.dto.WishlistDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface WishlistRepository extends JpaRepository<WishlistItem, Integer> {


    @Query("select wi from WishlistItem wi where wi.product.id = :productId and wi.wishlistFolder.id = :folderId")
    Optional<WishlistItem> findWishlistItemByWishlistFolderIdAndProductId(int productId,int folderId);


    @Query("SELECT new com.kofoos.api.wishlist.dto.WishlistDto(wi.id, wi.bought, wi.product.itemNo, img.imgUrl) " +
            "FROM WishlistItem wi " +
            "JOIN wi.product p " +
            "JOIN p.image img " +
            "WHERE wi.wishlistFolder.id = :folderId")
    List<WishlistDto> findItemsWithImagesByUserId(@Param("folderId") int folderId);

    @Query("SELECT new com.kofoos.api.wishlist.dto.WishlistDto(wi.id, wi.bought, p.itemNo, img.imgUrl) " +
            "FROM WishlistItem wi " +
            "LEFT JOIN wi.product p " +
            "LEFT JOIN wi.image img " +
            "WHERE wi.wishlistFolder.id = :folderId")
    List<WishlistDto> findProductsByFolderId(@Param("folderId") int folderId);



    @Modifying
    @Query("UPDATE WishlistItem SET bought = :bought WHERE id = :wishlistItemId")
    int updateBought(@Param("wishlistItemId") int wishlistItemId, @Param("bought") int bought);

    @Modifying
    @Query("UPDATE WishlistItem SET wishlistFolder.id = :targetFolderId WHERE id = :itemId")
    void updateFolderId(@Param("itemId") int itemId, @Param("targetFolderId") int targetFolderId);
}
