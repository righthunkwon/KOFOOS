// DislikedMaterialRepository.java
package com.kofoos.api.repository;

import com.kofoos.api.entity.DislikedMaterial;
import com.kofoos.api.entity.UserDislikesMaterial;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

@Repository
public interface DislikedMaterialRepository extends JpaRepository<DislikedMaterial, Integer> {
    Optional<DislikedMaterial> findByName(String name);
}

