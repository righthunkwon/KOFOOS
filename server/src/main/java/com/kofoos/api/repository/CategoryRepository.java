package com.kofoos.api.repository;

import com.kofoos.api.entity.Category;
import com.kofoos.api.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface CategoryRepository extends JpaRepository<Category, Integer> {

    @Query("select c.cat2 from Category c where c.cat1 = :cat1")
    List<String> findCat2(String cat1);

    @Query("select c.cat3 from Category c where c.cat1 = :cat1 and c.cat2 = :cat2")
    List<String> findCat3(String cat1,String cat2);

    @Query("SELECT c.cat1, c.cat2 FROM Category c " +
            "LEFT JOIN c.products p " +
            "GROUP BY c.cat1, c.cat2 " +
            "ORDER BY SUM(p.hit) DESC limit 7")
    List<String> ranking();

    @Query("select c.id from Category c where c.cat1 = :cat1 and c.cat2 = :cat2")
    List<Integer> findId(String cat1, String cat2);


}
