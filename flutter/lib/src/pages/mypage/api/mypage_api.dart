import 'package:dio/dio.dart';
import 'dart:convert';

import '../dto/my_page_dto.dart'; // JSON 처리를 위해 필요

class MyPageApi {
  Dio dio = Dio();
  final baseUrl = 'http://i10a309.p.ssafy.io:8080/api/users';

  // 마이페이지 정보 불러오기
  Future<MyPageDto> fetchMyPageInfo(String deviceId) async {
    final response = await dio.post(
      '$baseUrl/mypage',
      data: {
        'deviceId': deviceId,
      },
    );
    if (response.statusCode == 200) {
      print('마이페이지 가져오기 성공');
      return MyPageDto.fromJson(response.data);
    } else {
      print('마이페이지 가져오기 실패: ${response.statusCode}');
      throw Exception('Failed to load MyPage info');
    }
  }

  // 사용자가 이전에 선택한 비선호 식재료 목록 불러오기
  Future<List<int>> loadUserDislikedFoods(String deviceId) async {
    final response = await dio.get('$baseUrl/${deviceId}/dislikes');
    if (response.statusCode == 200) {
      List<dynamic> responseBody = response.data;
      return List<int>.from(responseBody);
    } else {
      print('Failed to load disliked foods: ${response.statusCode}');
      throw Exception('Failed to load disliked foods');
    }
  }

  // 사용자의 비선호 식재료 목록 업데이트
  Future<void> submitDislikedFoods(String deviceId, List<int> dislikedFoodsIds) async {
    final response = await dio.post(
      '$baseUrl/update_food',
      data: json.encode({
        'deviceId': deviceId,
        'dislikedFoods': dislikedFoodsIds,
      }),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200) {
      print('Disliked foods updated successfully');
    } else {
      print('Failed to update disliked foods: ${response.statusCode}');
      throw Exception('Failed to update disliked foods');
    }
  }

  //사용자 언어 업데이트
  Future<void> updateUserLanguage(String deviceId, String language) async {
    final response = await dio.post(
      '$baseUrl/update_language', // 언어 업데이트 API 엔드포인트, 실제 경로는 서버 구현에 따라 다를 수 있음
      data: json.encode({
        'deviceId': deviceId,
        'language': language,
      }),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );

    if (response.statusCode == 200) {
      print('Language updated successfully');
    } else {
      throw Exception('Failed to update language');
    }
  }


  Future<void> deleteUser(String deviceId) async {
    final response = await dio.delete(
      '$baseUrl/delete',
      data: json.encode({'deviceId': deviceId}),
      options: Options(headers: {'Content-Type': 'application/json'}),
    );
    if (response.statusCode == 200) {
      print('Account deletion successful');
    } else {
      print('Failed to delete account: ${response.statusCode}');
      throw Exception('Failed to delete account');
    }
  }


}
