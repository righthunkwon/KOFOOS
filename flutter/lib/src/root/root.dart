import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kofoos/src/common/appbar_widget.dart';
import 'package:kofoos/src/pages/mypage/mypage.dart';
import 'package:kofoos/src/pages/search/search.dart';
import 'package:kofoos/src/pages/home/home.dart';
import 'package:kofoos/src/pages/camera/camera.dart';
import 'package:kofoos/src/pages/wishlist/wishlist.dart';
import 'package:kofoos/src/root/root_controller.dart';
import 'package:lazy_load_indexed_stack/lazy_load_indexed_stack.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class Root extends GetView<RootController> {
  Root({Key? key}) : super(key: key);

  Widget _cameraTemp(BuildContext context) {

    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Camera()),
          );
        },
        child: Text('Temp'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        bool canPop = controller.onBack();
        return !canPop;
      },
      //
      child: Obx(
            () => Scaffold(
          backgroundColor: Colors.white,
          appBar: MyAppBar(),
          body: LazyLoadIndexedStack(
            index: controller.rootPageIndex.value,
            children: [
              Navigator(
                key: UniqueKey(),
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => Home(),
                  );
                },
              ),
              Navigator(
                key: UniqueKey(),
                onGenerateRoute: (routeSettings) {
                  return MaterialPageRoute(
                    builder: (context) => Search(),
                  );
                },
              ),
              Camera(),
              const Wishlist(),
              const Mypage(),
            ],
          ),
          bottomNavigationBar: controller.isEditing.isTrue
              ? null // isEditing가 true일 때는 바텀 네비게이션 바를 표시하지 않습니다.
              : BottomNavigationBar(
            backgroundColor: Colors.white,
            currentIndex: controller.rootPageIndex.value,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            onTap: (index) {
              if (index == 2) {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => Camera()),
                );
              } else {
                controller.changeRootPageIndex(index);
              }
            },
            items: const [
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.home, color: Color(0xffCACACA)),
                label: 'home',
                activeIcon: Icon(Icons.home, color: Color(0xff343F56)),
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.search, color: Color(0xffCACACA)),
                label: 'search',
                activeIcon: Icon(Icons.search, color: Color(0xff343F56)),
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.camera_alt, color: Color(0xffCACACA)),
                label: 'camera',
                activeIcon: Icon(Icons.camera_alt, color: Color(0xff343F56)),
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.favorite, color: Color(0xffCACACA)),
                label: 'wishlist',
                activeIcon: Icon(Icons.favorite, color: Color(0xff343F56)),
              ),
              BottomNavigationBarItem(
                backgroundColor: Colors.white,
                icon: Icon(Icons.person, color: Color(0xffCACACA)),
                label: 'mypage',
                activeIcon: Icon(Icons.person, color: Color(0xff343F56)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}