import 'package:get/get.dart';

class DeviceController extends GetxController {
  var deviceId = "".obs; // `.obs`를 사용하여 반응형 변수로 선언

  void setDeviceId(String id) {
    deviceId.value = id; // 디바이스 아이디 설정
  }
}
