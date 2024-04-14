package com.kofoos.api.repository;

import com.kofoos.api.common.dto.ProductDto;
import com.kofoos.api.entity.Product;
import com.kofoos.api.entity.User;
import com.kofoos.api.entity.WishlistFolder;
import com.kofoos.api.wishlist.dto.FolderDto;
import com.kofoos.api.wishlist.dto.WishlistDto;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
public interface FolderRepository extends JpaRepository<WishlistFolder, Integer> {
    @Query("SELECT wf FROM WishlistFolder wf " +
            "JOIN wf.user u " +
            "WHERE u.id = :userId AND wf.name = :name")
    WishlistFolder findFolderByUserIdAndName(
            @Param("userId") int userId,
            @Param("name") String name
    );


    @Query("SELECT  new com.kofoos.api.wishlist.dto.FolderDto(wf.id,wf.name)" +
            "FROM WishlistFolder wf WHERE wf.user.id = :userId")
    List<FolderDto> findFolderByUserId(@Param("userId") int userId);


    @Query("SELECT w.product.id FROM WishlistItem w WHERE w.wishlistFolder.id = :folderId")
    List<Integer> findProductIdsByFolderId(@Param("folderId") int folderId);

}
