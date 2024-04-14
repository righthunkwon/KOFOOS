package com.kofoos.api.repository;

import com.kofoos.api.entity.UserDislikesMaterial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface UserDislikesMaterialRepository extends JpaRepository<UserDislikesMaterial,Integer> {
    List<UserDislikesMaterial> findByUserId(int userId);
    void deleteByUserId(int userId);
}
