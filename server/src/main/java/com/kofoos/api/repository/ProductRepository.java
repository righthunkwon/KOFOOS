package com.kofoos.api.repository;

import com.kofoos.api.entity.Product;
import com.kofoos.api.entity.WishlistFolder;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

public interface ProductRepository extends JpaRepository<Product, Integer> {

    Optional<Product> findById(int id);
    @Query("SELECT p, i FROM Product p JOIN p.image i WHERE p.id IN :productIds")
    List<Object[]> findProductsWithImagesByIds(@Param("productIds") List<Integer> productIds);



    @Query("select p from Product p where p.barcode = :barcode")
    Optional<Product> findProductByBarcode(String barcode);


    @Query("select p from Product p where p.itemNo = :itemNo")
    Optional<Product> findProductByItemNo(String itemNo);

    @Modifying
    @Query("update Product p set p.like = p.like + 1 where p.id = :id")
    void upLike(int id);


    @Modifying
    @Query("update Product p set p.like = p.like - 1 where p.id = :id")
    void downLike(int id);

    @Query("select distinct(p) from Product p " +
            "join fetch p.image " +
            "join fetch p.category c " +
            "join p.productMaterials pm " +
            "left join pm.dislikedMaterial dm " +
            "where c.cat1 = :cat1 and c.cat2 = :cat2 " +
            "order by p.like desc ")
    List<Product> findRelatedProductsOrderByLike(String cat1, String cat2, Pageable pageable);

    @Query("select distinct(p) from Product p " +
            "join fetch p.image " +
            "join p.productMaterials pm " +
            "left join pm.dislikedMaterial dm " +
            "join fetch p.category c " +
            "where c.cat1 = :cat1 and c.cat2 = :cat2 and " +
            "   dm.id not in ( " +
            "       select udm.id " +
            "       from UserDislikesMaterial udm " +
            "       join udm.user u " +
            "       where u.deviceId = :deviceId " +
            "   ) " +
            "order by p.like desc ")
    List<Product> findRelatedProductsOrderByLikeWithAllergyFiltering(String cat1, String cat2, String deviceId, Pageable pageable);


    @Query("select p from Product p " +
            "join fetch p.image " +
            "join p.editorProductsLists epl " +
            "join epl.editorRecommendationArticle era " +
            "where era.id = :rArticleId " +
            "order by p.id " )
    List<Product> findProductsByArticleId(int rArticleId, Pageable pageable);

    @Query("select distinct(p) from Product p " +
            "join fetch p.image " +
            "join p.productMaterials pm " +
            "left join pm.dislikedMaterial " +
            "order by coalesce(p.like,0)*0.7 + coalesce(p.hit)*0.3 desc ")
    List<Product> findHotProductsOrderByLikeAndHit(Pageable pageable);

    @Query("select p from Product p join fetch p.productMaterials join fetch p.image join p.category c on c.cat1 = :cat1 and c.cat2 = :cat2 and c.cat3 = :cat3")
    List<Product> findProductsByCategory(String cat1, String cat2,String cat3);

    @Query("select p from Product p left join fetch p.productMaterials join fetch p.image join p.category on p.category.id = :id ORDER BY p.like")
    List<Product> findProductsOrderByLike(int id);
    @Query("select p from Product p left join fetch p.productMaterials join fetch p.image join p.category on p.category.id = :id ORDER BY p.hit desc ")
    List<Product> findProductsOrderByHit(int id);

    @Modifying
    @Query(value = "update product set description = :description, tag_string = :tagString where item_no = :itemNo",nativeQuery = true)
    void updateGptTag(String itemNo, String tagString, String description);


    @Query("select count(p) from Product p ")
    int intCount();


}
