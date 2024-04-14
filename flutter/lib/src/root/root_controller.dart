import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import '../pages/search/search_detail_page.dart';

class RootController extends GetxController {
  static RootController get to => Get.find();
  RxInt rootPageIndex = 0.obs;
  GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
  RxBool isMultiplePageOpen = false.obs;
  DateTime? currentBackPressTime;
  var indexHistory = <int>[0];
  Rx<Type?> currentScreen = Rx<Type?>(null);
  Rx<String?> currentItemNo = Rx<String?>(null);

  var isEditing = false.obs; // 편집 모드 상태를 관리하는 Observable 변수

  void goToProductDetail(String itemNo) {
    currentScreen.value = ProductDetailView;
    currentItemNo.value = itemNo;
  }

  void toggleEditing() {
    isEditing.value = !isEditing.value; // 편집 모드 상태를 토글합니다.
  }

  void changeRootPageIndex(int index) {
    // rootPageIndex(index);
    rootPageIndex.value = index;
    indexHistory.add(index);
    print("Current Root Page Index: ${rootPageIndex.value}");
  }

  bool onBack() {
    if (indexHistory.length > 1) {
      indexHistory.removeLast();
      rootPageIndex.value = indexHistory.last;
      return false;
    }
    return true;
  }

  Future<bool> onWillPop() async {
    DateTime now = DateTime.now();
    if (currentBackPressTime == null ||
        now.difference(currentBackPressTime!) > const Duration(seconds: 2)) {
      currentBackPressTime = now;
      Fluttertoast.showToast(
          msg: "Double tap the back button\nto close the APP",
          gravity: ToastGravity.BOTTOM,
          backgroundColor: const Color(0xff6E6E6E),
          fontSize: 20,
          toastLength: Toast.LENGTH_SHORT);
      return false;
    }
    return true;
  }

  void setMultiplePage(bool ck) {
    isMultiplePageOpen(ck);
  }

  void back() {
    setMultiplePage(false);
    onWillPop();
  }
}
