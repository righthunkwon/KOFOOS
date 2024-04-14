package com.kofoos.api.repository;

import com.kofoos.api.entity.Image;
import com.kofoos.api.entity.Product;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface ImageRepository extends JpaRepository<Image, Integer>{
    Optional<Image> findById(int imageId);
}
