import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart' as dio;
import 'package:get/get.dart';
import 'package:kofoos/src/pages/wishlist/WishlistDetectionDto.dart';
import '../../../common/device_controller.dart';
import 'model/FolderDto.dart';

class WishlistApi {

  var wishlistDio = dio.Dio(
    dio.BaseOptions(
      //baseUrl: "http://10.0.2.2:8080",
      baseUrl: "http://i10a309.p.ssafy.io:8080",
      connectTimeout: 50000,
      receiveTimeout: 50000,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json',
        HttpHeaders.acceptHeader: 'application/json'
      },
    ),
  );


  Future<List<FolderDto>> getWishlistFolder() async {
    DeviceController deviceController = Get.find<DeviceController>();
    String currentDeviceId = deviceController.deviceId.value;
    try {
      var response = await wishlistDio.post('/wishlist/folder/list', data: {"deviceId": currentDeviceId});

      if (response.statusCode == 200) {
        // 첫 번째 단계: 전체 응답을 JSON 객체로 파싱
        Map<String, dynamic> decodedResponse = response.data;

        // 두 번째 단계: "folderList" 키를 가진 값을 JSON 배열로 추출
        List<dynamic> folderListJson = decodedResponse['folderList'] as List<dynamic>;

        // 세 번째 단계: JSON 배열을 FolderDto 객체로 변환
        List<FolderDto> folderList = folderListJson.map((json) => FolderDto.fromJson(json)).toList();

        print(folderList.toString());

        return folderList;
      } else {
        throw Exception('Failed to load folder list');
      }
    } catch (e) {
      throw Exception('getWishlistFolder error: $e');
    }
  }
  Future<void> sendSelectedItemsToServer(Set wishlist_item_ids ) async {
    print(wishlist_item_ids);
    await wishlistDio.post('/wishlist/product/check', data: {"wishlistItemIds": wishlist_item_ids.toList(), "bought":1});
  }
  Future<void> deleteWishlistItems(Set wishlist_item_ids ) async {
    await wishlistDio.post('/wishlist/product/cancel', data: {"wishlistItemIds": wishlist_item_ids.toList()});
  }

  Future<void> restoreWishlistItems(Set wishlist_item_ids ) async {
    await wishlistDio.post('/wishlist/product/check', data: {"wishlistItemIds": wishlist_item_ids.toList(),"bought":0});
  }

  Future<void> likeWishlistItems(int productId) async {
    DeviceController deviceController = Get.find<DeviceController>();
    String currentDeviceId = deviceController.deviceId.value;
    await wishlistDio.post('/wishlist/product/like', data: {"productId": productId,"deviceId": currentDeviceId});
  }

  Future<void> unlikeWishlistItems(int productId) async {
    DeviceController deviceController = Get.find<DeviceController>();
    String currentDeviceId = deviceController.deviceId.value;
    await wishlistDio.post('/wishlist/product/unlike', data: {"productId": productId,"deviceId": currentDeviceId});
  }

  Future<void> insertItem(WishlistDetectionDto? wishlistDetection) async {
    DeviceController deviceController = Get.find<DeviceController>();
    String currentDeviceId = deviceController.deviceId.value;
    print('여기는 api');
    print(wishlistDetection?.itemNo);
    print(wishlistDetection?.imageUrl);

    // 이미지 파일을 MultipartFile 객체로 변환하여 추가
    var formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(wishlistDetection!.imageUrl, filename: "upload.jpg"),
      // 추가 데이터도 함께 전송
      "deviceId": currentDeviceId,
      "itemNo": wishlistDetection.itemNo,
    });

    try {
      // 클래스 상단에서 정의한 wishlistDio 인스턴스를 재사용하여 요청 전송
      var response = await wishlistDio.post('/wishlist/detection/insert', data: formData);

      if (response.statusCode == 200) {
        // 성공적으로 전송됐을 때의 처리
        print("Successfully uploaded");
      } else {
        // 오류 발생 시 처리
        print("Failed to upload");
      }
    } catch (e) {
      // 예외 처리
      print("Error during file upload: $e");
    }
  }

  Future<void> deleteItem(WishlistDetectionDto? wishlistDetection) async {
    DeviceController deviceController = Get.find<DeviceController>();
    String currentDeviceId = deviceController.deviceId.value;
    print('여기는 api');
    print(wishlistDetection?.itemNo);
    print(wishlistDetection?.imageUrl);

    // 이미지 파일을 MultipartFile 객체로 변환하여 추가
    var formData = dio.FormData.fromMap({
      "file": await dio.MultipartFile.fromFile(wishlistDetection!.imageUrl, filename: "upload.jpg"),
      // 추가 데이터도 함께 전송
      "deviceId": currentDeviceId,
      "itemNo": wishlistDetection.itemNo,
    });

    try {
      // 클래스 상단에서 정의한 wishlistDio 인스턴스를 재사용하여 요청 전송
      var response = await wishlistDio.post('/wishlist/detection/insert', data: formData);

      if (response.statusCode == 200) {
        // 성공적으로 전송됐을 때의 처리
        print("Successfully uploaded");
      } else {
        // 오류 발생 시 처리
        print("Failed to upload");
      }
    } catch (e) {
      // 예외 처리
      print("Error during file upload: $e");
    }
  }
}

