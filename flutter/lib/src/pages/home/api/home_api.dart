import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import 'package:kofoos/src/common/device_controller.dart';

class HomeApi {
  final DeviceController deviceController = Get.find<DeviceController>();

  var homeDio = Dio(
    BaseOptions(
      baseUrl: "http://i10a309.p.ssafy.io:8080",
      connectTimeout: 50000,
      receiveTimeout: 50000,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json'
      },
    ),
  );

  Future<List<String>> getRanking(int barcode) async {
    try {
      var response = await homeDio.get('/detail/$barcode');
      List<String> ranking = List<String>.from(response.data);
      return ranking;
    } catch (e) {
      throw Exception('getRanking error: $e');
    }
  }

  Future<List<dynamic>> getRecommendHot() async {
    try {
      var response = await homeDio.get('/recommend/hot');
      List<dynamic> recommendHotList = response.data;
      return recommendHotList;
    } catch (e) {
      throw Exception('getRecommendHot error: $e');
    }
  }

  Future<List<dynamic>> getRecommendHistory() async {
    String currentDeviceId = deviceController.deviceId.value;
    try {
      var response = await homeDio.post(
        '/recommend/history',
        data: {'deviceId': '$currentDeviceId'},
      );
      List<dynamic> recommendHistoryList = response.data;
      return recommendHistoryList;
    } catch (e) {
      throw Exception('getRecommendHot error: $e');
    }
  }
}
