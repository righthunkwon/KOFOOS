package com.kofoos.api.UserDislikesMaterials;

import com.kofoos.api.repository.UserDislikesMaterialRepository;
import com.kofoos.api.repository.DislikedMaterialRepository;
import com.kofoos.api.entity.User;
import com.kofoos.api.entity.DislikedMaterial;
import com.kofoos.api.entity.UserDislikesMaterial;
import com.kofoos.api.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
@RequiredArgsConstructor
public class UserDislikesMaterialsService {

    private final UserDislikesMaterialRepository userDislikesMaterialsRepo;
    private final UserRepository userRepository;
    private final DislikedMaterialRepository dislikedMaterialRepository;

    public void addUserDislikedMaterials(int userId, List<Integer> dislikedMaterialIds) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new RuntimeException("User not found"));

        for(int materialId : dislikedMaterialIds) {
            DislikedMaterial material = dislikedMaterialRepository.findById(materialId)
                    .orElseThrow(() -> new RuntimeException("Disliked Material not found"));

            UserDislikesMaterial userDislikesMaterials = UserDislikesMaterial.builder()
                    .user(user)
                    .dislikedMaterial(material)
                    .build();
            userDislikesMaterialsRepo.save(userDislikesMaterials);
        }
    }
}
