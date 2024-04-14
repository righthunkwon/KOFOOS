package com.kofoos.api.User;

import com.kofoos.api.User.dto.MyPageDto;
import com.kofoos.api.User.dto.UpdateFoodRequestDto;
import com.kofoos.api.User.dto.UpdateLangRequestDto;
import com.kofoos.api.User.dto.UserRequestDto;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import com.kofoos.api.entity.User;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    //유저 등록 여부 확인 API
    @GetMapping("/check-registration/{deviceId}")
    public ResponseEntity<Boolean> checkUserRegistration(@PathVariable String deviceId) {
        boolean isRegistered = userService.isUserAlreadyRegistered(deviceId);
        return ResponseEntity.ok(isRegistered);
    }

    //유저 등록
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody User user) {
        if (userService.isUserAlreadyRegistered(user.getDeviceId())) { //이미 등록된 유저인지 확인
            return ResponseEntity.status(HttpStatus.CONFLICT).body("User already registered.");
        }
        userService.registerUser(user);
        return ResponseEntity.ok().build(); //성공하면 200
    }

    //마이페이지 조회
    @PostMapping("/mypage")
    public ResponseEntity<MyPageDto> getMyPageInfo(@RequestBody UserRequestDto requestDto) {

        String deviceId = requestDto.getDeviceId();
        int userId = userService.getUserId(deviceId);
        System.out.println("마이페이지 userId:" + userId);
        MyPageDto myPageInfo = userService.getMyPageInfo(userId);
        return ResponseEntity.ok(myPageInfo);
    }

    //비선호 식재료 목록 조회 API
    @GetMapping("/{deviceId}/dislikes")
    public ResponseEntity<List<Integer>> getUserDislikedMaterials(@PathVariable String deviceId) {

        int userId = userService.getUserId(deviceId);
        List<Integer> dislikedMaterialsIds = userService.getUserDislikedMaterials(userId);
        if (dislikedMaterialsIds != null && !dislikedMaterialsIds.isEmpty()) {
            return ResponseEntity.ok(dislikedMaterialsIds);
        } else {
            return ResponseEntity.notFound().build();
        }
    }

    //회원 가입 후 비선호 음식 등록
    @PostMapping("/{deviceId}/dislikes")
    public ResponseEntity<?> addUserDislikedMaterials(@PathVariable String deviceId, @RequestBody Map<String, List<Integer>> request) {
        int userId = userService.getUserId(deviceId);
        List<Integer> dislikedFoodsIds = request.get("dislikedFoods");
        userService.addUserDislikedMaterials(userId, dislikedFoodsIds);
        return ResponseEntity.ok().build();
    }

    // 비선호 식재료 목록 업데이트
    @PostMapping("/update_food")
    public ResponseEntity<?> updateUserDislikedMaterialsPost(@RequestBody UpdateFoodRequestDto requestDto) {
        try {
            String deviceId = requestDto.getDeviceId();
            int userId = userService.getUserId(deviceId);
            List<Integer> newDislikedFoodsIds = requestDto.getDislikedFoods();
            userService.updateUserDislikedMaterials(userId, newDislikedFoodsIds);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating disliked foods: " + e.getMessage());
        }
    }


    //회원 언어 업데이트
    @PostMapping("/update_language")
    public ResponseEntity<?> updateUserLanguage(@RequestBody UpdateLangRequestDto requestDto) {
        try {
            String deviceId = requestDto.getDeviceId();
            String newLanguage = requestDto.getLanguage();
            int userId = userService.getUserId(deviceId);
            userService.updateUserLanguage(userId, newLanguage);
            return ResponseEntity.ok().build();
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error updating language: " + e.getMessage());
        }
    }
    //회원 탈퇴
    @DeleteMapping("delete")
    public ResponseEntity<?> deleteUser(@RequestBody UserRequestDto requestDto) {
        String deviceId = requestDto.getDeviceId();
        int userId = userService.getUserId(deviceId);
        userService.deleteUser(userId);
        return ResponseEntity.ok().build();
    }


}
