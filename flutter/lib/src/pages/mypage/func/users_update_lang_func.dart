import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import '../../../common/device_controller.dart';
import '../api/mypage_api.dart';
import '../mypage_notifier.dart';

void usersUpdateLangFunc(BuildContext context) {
  final DeviceController deviceController = Get.find<DeviceController>();
  final MyPageApi myPageApi = MyPageApi(); // API 인스턴스 생성
  final myPageNotifier = context.read<MyPageNotifier>();

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return SimpleDialog(
        title: Text('Select Language'),
        children: [
          ListTile(
            title: Text('한국어'),
            onTap: () async{
                  print('한국어 선택');
              await myPageApi.updateUserLanguage(deviceController.deviceId.value, 'ko_KR');
              myPageNotifier.fetchMyPageInfo(deviceController.deviceId.value); // 언어 업데이트 후 정보 갱신
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('English'),
            onTap: () async{
              print('영어 선택');
              await myPageApi.updateUserLanguage(deviceController.deviceId.value, 'en_US');
              myPageNotifier.fetchMyPageInfo(deviceController.deviceId.value); // 언어 업데이트 후 정보 갱신
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('中文'),
            onTap: () async{
              print('중국어 선택');
              await myPageApi.updateUserLanguage(deviceController.deviceId.value, 'zh_CN');
              myPageNotifier.fetchMyPageInfo(deviceController.deviceId.value); // 언어 업데이트 후 정보 갱신
              Navigator.pop(context);
            },
          ),
          ListTile(
            title: Text('日本語'),
            onTap: () async{
              print('일본어 선택');
              await myPageApi.updateUserLanguage(deviceController.deviceId.value, 'ja_JP');
              myPageNotifier.fetchMyPageInfo(deviceController.deviceId.value); // 언어 업데이트 후 정보 갱신
              Navigator.pop(context);
            },
          ),
        ],
      );
    },
  );
}

// 언어 코드와 언어 이름 매핑
String getLanguageDisplayName(String languageCode) {
  switch (languageCode) {
    case 'ko_KR':
      return '한국어';
    case 'en_US':
      return 'English';
    case 'zh_CN':
      return '中文';
    case 'ja_JP':
      return '日本語';
    default:
      return 'English';
  }
}
