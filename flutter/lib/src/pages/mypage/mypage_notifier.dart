// my_page_notifier.dart
import 'package:flutter/material.dart';
import 'package:kofoos/src/pages/mypage/func/users_update_lang_func.dart';
import '../../common/device_controller.dart';
import 'dto/my_page_dto.dart';
import 'api/mypage_api.dart';
import 'package:get/get.dart';


//상태 변경 반영용
class MyPageNotifier with ChangeNotifier {
  final DeviceController deviceController = Get.find<DeviceController>();
  MyPageDto? myPageInfo;
  final MyPageApi _api = MyPageApi();

  MyPageNotifier() {
    initializeDeviceId(); // 객체 생성 후 deviceId 초기화
  }

  // deviceId를 비동기적으로 초기화하는 메서드
  Future<void> initializeDeviceId() async {
    String deviceId = deviceController.deviceId.value; // DeviceController에서 deviceId 가져오기
    fetchMyPageInfo(deviceId); // 비동기적으로 deviceId를 설정한 후 API 호출
  }

  void fetchMyPageInfo(String deviceId) async {
    try {
      myPageInfo = await _api.fetchMyPageInfo(deviceId);
      print('마이페이지 데이터 로드 성공: $myPageInfo');
      notifyListeners();
    } catch (e) {
      print('마이페이지 데이터 로드 실패: $e');
    }
  }

// 기타 상태 변경 함수들...
}
