import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../common/device_controller.dart';
import '../../../root/root.dart';
import '../func/show_consent_dialog.dart';
import '../select_food.dart';

// Dio 인스턴스 생성
final Dio dio = Dio();

// API 서버의 기본 URL
const String baseUrl = 'http://i10a309.p.ssafy.io:8080/api/users/';

//회원 등록 api
Future<void> registerUser(BuildContext context, String deviceId, String language) async {
  var url = '${baseUrl}register'; // URL 재사용
  try {
    var response = await dio.post(
      url,
      data: {
        'deviceId': deviceId,
        'language': language,
      },
    );
    if (response.statusCode == 200) {
      print('User registered successfully');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const FoodSelectionPage()),
      );
    } else {
      print('Failed to register user');
    }
  } catch (e) {
    print(e.toString());
  }
}

//사용자 등록 여부 확인 및 화면 이동 로직
Future<void> checkUserRegistration(BuildContext context, String deviceId) async {
  var url = '${baseUrl}check-registration/$deviceId'; // URL 재사용
  try {
    var response = await dio.get(url);
    if (response.statusCode == 200) {
      var isRegistered = response.data;
      if (isRegistered) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => Root()),
        );
      } else {
        showConsentDialog(context);
      }
    } else {
      print('Failed to check user registration');
    }
  } catch (e) {
    print(e.toString());
  }
}

// 선택된 음식들 db로 보내기
Future<void> submitSelection(BuildContext context, List<Food> selectedFoods) async {
  print('Selected foods: $selectedFoods'); // 잘 들어갔는지 확인용
  final DeviceController deviceController = Get.find<DeviceController>();
  String deviceId = deviceController.deviceId.value; // Getx를 통해 deviceId 값을 가져옴

  var url = '${baseUrl}$deviceId/dislikes'; // URL 재사용

  try {
    var response = await dio.post(
      url,
      data: json.encode({
        'dislikedFoods': selectedFoods.map((food) => food.id).toList(),
      }),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == 200) {
      print('Disliked foods submitted successfully');
      // 다음 페이지로 이동
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => Root()), // Home으로 이동
            (Route<dynamic> route) => false, // 조건이 false를 반환하므로 이전의 모든 페이지를 제거
      );
    } else {
      print('Failed to submit disliked foods');
    }
  } catch (e) {
    print(e.toString());
  }
}
