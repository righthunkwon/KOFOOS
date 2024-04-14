import 'dart:io';

import 'package:dio/dio.dart';
import 'package:get/get.dart';
import '../../../common/device_controller.dart';

class SearchApi {

  final DeviceController deviceController = Get.find<DeviceController>();
  var searchDio = Dio(
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

  Future<List<String>> getRanking() async {
    try {
      var response = await searchDio.get('/products/category/ranking');
      List<String> ranking = List<String>.from(response.data);
      return ranking;
    } catch (e) {
      throw Exception('getRanking error: $e');
    }
  }

  Future<List<String>> getCat3(String cat1, String cat2) async {
    try {
      var response =
          await searchDio.get('/products/category?cat1=$cat1&cat2=$cat2');
      List<String> cat3List = List<String>.from(response.data);
      List<String> uniqueCat3List = cat3List.toSet().toList();
      return uniqueCat3List;
    } catch (e) {
      throw Exception('getRanking error: $e');
    }
  }

  Future<dynamic> getProductDetail(String itemNo) async {
    String currentDeviceId = deviceController.deviceId.value;
    try {
      final response = await searchDio.get('/products/detail/no/$itemNo/$currentDeviceId');
      return response.data;
    } on DioError catch (e) {
      throw Exception('getProductDetail error:$e');
    }
  }

  Future<List<dynamic>> getProducts(String cat1, String cat2, String order) async {
    try {
      final response = await searchDio
          .get('/products/list?cat1=$cat1&cat2=$cat2&order=$order');
      return response.data;
    } on DioError catch (e) {
      throw Exception('getProduct error:$e');
    }
  }

  Future<dynamic> getProductByBarcode(String barcode) async {
    try {
      final response = await searchDio.get('/products/detail/$barcode');
      return response.data;
    } on DioError catch (e) {
      throw Exception('getProductDetail error:$e');
    }
  }

  Future<List<dynamic>> getRecommendProducts(int productId) async {
    try {
      final response = await searchDio.get('/recommend/product/$productId');
      return List<dynamic>.from(response.data);
    } on DioError catch (e) {
      throw Exception('getProduct error:$e');
    }
  }
}
