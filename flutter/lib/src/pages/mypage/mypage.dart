import 'package:flutter/material.dart';
import 'package:kofoos/src/pages/mypage/dto/ProductDto.dart';
import 'package:kofoos/src/pages/mypage/func/users_delete_func.dart';
import 'package:kofoos/src/pages/mypage/func/users_update_lang_func.dart';
import 'package:kofoos/src/pages/mypage/api/mypage_api.dart';
import 'package:kofoos/src/pages/mypage/dto/my_page_dto.dart';
import 'package:kofoos/src/pages/mypage/update_materials_page.dart';
import 'package:kofoos/src/pages/register/func/get_device_id.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../common/device_controller.dart';
import '../register/select_food.dart';
import 'func/mypage_history_func.dart';
import 'mypage_notifier.dart';
import 'package:get/get.dart';


class Mypage extends StatefulWidget {
  const Mypage({Key? key}) : super(key: key);

  @override
  _MypageState createState() => _MypageState();
}

class _MypageState extends State<Mypage> {

  final DeviceController deviceController =
      Get.find<DeviceController>(); // DeviceController 인스턴스 얻기

  @override
  Widget build(BuildContext context) {
    // Provider를 사용하여 상태를 관리합니다.
    return ChangeNotifierProvider<MyPageNotifier>(
      create: (_) => MyPageNotifier(),
      child: Consumer<MyPageNotifier>(
        builder: (context, notifier, _) {
          return Scaffold(
            body: notifier.myPageInfo == null
                ? const Center(child: CircularProgressIndicator())
                : _myPageWidget(context, notifier.myPageInfo!),
          );
        },
      ),
    );
  }

  Widget _historyCarouselWidget(List<ProductDto> products) {
    double screenWidth = MediaQuery.of(context).size.width;
    // 화면 너비에 따라 텍스트 크기를 동적으로 조절

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal, // 가로 스크롤 설정
      child: Row(
        children: products
            .map((productDto) => GestureDetector(
                  onTap: () {
                    goToProductDetail(
                        context, productDto.productItemNo); //제품 상세보기
                  },
                  child: Container(
                    width: screenWidth/3.3, // 이미지 컨테이너 너비 설정
                    height: screenWidth/3.3, // 이미지 컨테이너 높이 설정
                    margin: EdgeInsets.all(5), // 주변 여백 설정
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5), // 모서리 둥글게 처리
                      image: DecorationImage(
                        fit: BoxFit.cover, // 이미지를 컨테이너에 꽉 채우도록 설정
                        image: CachedNetworkImageProvider(
                            productDto.productUrl), // 캐시된 네트워크 이미지 로드
                      ),
                    ),
                  ),
                ))
            .toList(),
      ),
    );
  }

  Widget _myPageWidget(BuildContext context, MyPageDto info) {
    // Disliked Foods 섹션을 위한 위젯 구성
    Widget dislikedFoodsSection = _dislikedFoodsSection(info.dislikedMaterials);
    String currentDeviceId = deviceController.deviceId.value;
    // 현재 컨텍스트에서 화면의 크기를 가져오기
    double screenWidth = MediaQuery.of(context).size.width;
    // 화면 너비에 따라 텍스트 크기를 동적으로 조절
    double fontSize = screenWidth < 360 ? 18 : 20;

    // History 섹션을 위한 위젯 구성
    Widget historySection = Container(
      color: Colors.white,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ListTile(
            title: Text('History',
                style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700)),
          ),
          // 히스토리 사진을 캐러셀로 표시하는 위젯을 여기에 배치
          _historyCarouselWidget(info.products),
        ],
      ),
    );

    return Consumer<MyPageNotifier>(builder: (context, notifier, _) {
      if (notifier.myPageInfo == null) {
        return const Center(child: CircularProgressIndicator());
      } else {
        return SingleChildScrollView(
          child: Column(
            children: [
              Container(
                height: 70,
                color: const Color(0xff343F56),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 32,
                      ),
                      const Text(
                        ' My page',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      TextButton(
                        onPressed: () {
                          // 유저 회원탈퇴 api

                          usersDeleteFunc(context, currentDeviceId);
                        },
                        child: const Text(
                          'Delete Account',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                            decoration: TextDecoration.underline,
                            decorationColor: Colors.grey,
                            decorationThickness: 2.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                height: 20.0,
                color: Colors.white,
              ),
              Container(
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: ListTile(
                        title: Text(
                            'Language',
                            style: TextStyle(fontSize: fontSize, fontWeight: FontWeight.w700)),
                        trailing: ElevatedButton(
                          onPressed: () {
                            // 언어 변경 함수
                            usersUpdateLangFunc(context);
                          },
                          style: ElevatedButton.styleFrom(
                            primary: Color(0xffECECEC),
                          ),
                          child: Text(
                            getLanguageDisplayName(info.language),
                            // 유저가 선택한 언어 출력
                            style: const TextStyle(
                                color: Colors.black,
                                fontWeight: FontWeight.w600,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 20.0,
                color: Colors.white,
              ),
              const Divider(
                color: Color(0xffECECEC),
                height: 2.0,
                thickness: 2.0,
              ),
              Container(
                height: 10.0,
                color: Colors.white,
              ),

              _dislikedFoodsSectionWithTitle(context, notifier.myPageInfo!),

              Container(
                height: 10.0,
                color: Colors.white,
              ),
              const Divider(
                color: Color(0xffECECEC),
                height: 2.0,
                thickness: 2.0,
              ),
              historySection, // History 섹션
              const SizedBox(height: 40.0),
              Container(
                padding: const EdgeInsets.all(8.0),
                alignment: Alignment.center,
                child: const Text(
                  'KOFOOS\nSeoul, Korea\nContact kofoos@gmail.com',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffCACACA),
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        );
      }
    });
  }

  Widget _dislikedFoodsSectionWithTitle(BuildContext context, MyPageDto info) {
    // 현재 컨텍스트에서 화면의 크기를 가져오기
    double screenWidth = MediaQuery.of(context).size.width;
    // 화면 너비에 따라 텍스트 크기를 동적으로 조절
    double fontSize = screenWidth < 360 ? 18 : 20;

    return Container(
      color: Colors.white,
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Disliked Foods',
                style:
                    TextStyle(fontSize: fontSize, fontWeight: FontWeight.bold),
              ),
              TextButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DislikeFoodEditPage(
                            deviceId: deviceController.deviceId.value)),
                  );
                  if (result == true) {
                    Provider.of<MyPageNotifier>(context, listen: false)
                        .fetchMyPageInfo(deviceController.deviceId.value);
                  }
                },
                child: Text(
                  'More details',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    decoration: TextDecoration.underline,
                    decorationColor: Colors.grey,
                    decorationThickness: 2.0,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 8), // 여백 추가
          _dislikedFoodsSection(info.dislikedMaterials),
        ],
      ),
    );
  }

  Widget _dislikedFoodsSection(List<int> dislikedFoodIds) {
    List<Widget> dislikedFoodWidgets = foodList
        .where((food) => dislikedFoodIds.contains(food.id))
        .take(3) // 최대 3개의 아이템만 표시
        .map((food) => buildDislikedFoodWidget(food))
        .toList();

    return Wrap(
      spacing: 8.0,
      children: dislikedFoodWidgets,
    );
  }

  Widget buildDislikedFoodWidget(Food food) {
    // 현재 컨텍스트에서 화면의 크기를 가져오기
    double screenWidth = MediaQuery.of(context).size.width;

    // 화면 너비에 따라 이미지와 텍스트 크기를 동적으로 조절
    double imageSize = screenWidth * 0.17; // 화면 너비의 20%를 이미지 크기로 설정
    double fontSize =
        screenWidth < 360 ? 12 : 14; // 화면 너비가 360보다 작으면 12, 그렇지 않으면 14

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset('assets/icon/${food.image}.png',
            width: imageSize, height: imageSize), // 이미지 크기는 적절하게 조절
        SizedBox(height: 4), // 이미지와 텍스트 사이의 간격
        Text(food.name, style: TextStyle(fontSize: fontSize)), // 음식 이름
      ],
    );
  }

}
