import 'dart:io';
import 'package:flutter/material.dart';
import '../api/register_api.dart';
import 'get_device_id.dart';


//디바이스 정보 수집 동의 메시지 띄우는 메서드
void showConsentDialog(BuildContext context) async {
  String locale = Platform.localeName; // 디바이스의 현재 설정된 언어를 가져옵니다.
  print('device language: $locale'); //디바이스 설정 언어 확인용
  // 사용자의 동의를 받는 대화상자를 표시합니다.
  bool isAgreed = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Privacy Consent'),
      content: const Text(
          'Do you allow us to collect your device ID for our service?'),
      actions: [
        TextButton(
          child: const Text('No'),
          onPressed: () => Navigator.of(context).pop(false),
        ),
        TextButton(
          child: const Text('Yes'),
          onPressed: () => Navigator.of(context).pop(true),
        ),
      ],
    ),
  ) ??
      false;

  if (isAgreed) {
    // 동의하면 디바이스 아이디를 가져오고 DB에 저장합니다.
    String deviceId = await getDeviceId();
    String language = Platform.localeName;
    registerUser(context,deviceId, language);
    // 다음 페이지로 이동합니다.
  }else {
    exit(0); // 동의 안하면 앱 종료
  }
}
