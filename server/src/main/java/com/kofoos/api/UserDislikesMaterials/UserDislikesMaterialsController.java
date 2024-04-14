package com.kofoos.api.UserDislikesMaterials;

import com.kofoos.api.UserDislikesMaterials.UserDislikesMaterialsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;

@RestController
@RequestMapping("/api/user-dislikes")
@RequiredArgsConstructor
public class UserDislikesMaterialsController {

    private final UserDislikesMaterialsService userDislikesMaterialsService;

    @PostMapping("/{userId}")
    public ResponseEntity<?> addUserDislikedMaterials(@PathVariable int userId, @RequestBody List<Integer> materialIds) {
        userDislikesMaterialsService.addUserDislikedMaterials(userId, materialIds);
        return ResponseEntity.ok().build();
    }
}
