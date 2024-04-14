import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:kofoos/src/pages/mypage/api/mypage_api.dart';
import 'package:kofoos/src/pages/search/api/search_api.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:vibration/vibration.dart';
import '../../common/device_controller.dart';
import '../register/select_food.dart';
import 'package:get/get.dart';

import '../wishlist/api/wishlist_api.dart';

class CameraDetailView extends StatefulWidget {
  const CameraDetailView({super.key, required this.itemNo});

  final String itemNo;

  @override
  State<CameraDetailView> createState() => _CameraDetailViewState();
}

class _CameraDetailViewState extends State<CameraDetailView>
    with SingleTickerProviderStateMixin {
  SearchApi searchApi = SearchApi();
  WishlistApi wishlistApi = WishlistApi();
  late Future<dynamic> data;
  bool isLiked = false;
  int count = 0;
  late int productId = -1;
  late TabController _tabController;
  MyPageApi _myPageApi = MyPageApi(); // MyPageApi 인스턴스 생성
  List<int> userDislikedFoodsIds = []; // 사용자의 비선호 식재료 ID 리스트
  bool isLoading = true; // 로딩 상태
  final DeviceController deviceController = Get.find<DeviceController>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadUserDislikedFoods(); // 사용자의 비선호 식재료 리스트를 로드
    final deviceId = deviceController.deviceId.value; // 현재 deviceId 가져오기
    data = searchApi.getProductDetail(widget.itemNo).then(
      (productData) {
        var wishList = productData['wishList'] as List<dynamic>?;
        setState(() {
          count = productData['like'];
          productId = productData['productId'];
          isLiked = wishList?.contains(deviceId) ?? false;
        });
        return productData;
      },
    );
  }

  Future<void> Like() async {
    setState(() {
      isLiked = !isLiked;
      count += isLiked ? 1 : -1;
    });

    try {
      if (isLiked) {
        await wishlistApi.likeWishlistItems(productId);
      } else {
        await wishlistApi.unlikeWishlistItems(productId);
      }
    } catch (e) {
      print("Wishlist API 호출 실패: $e");
      setState(() {
        isLiked = !isLiked;
        count += isLiked ? 1 : -1;
      });
    }
  }

  // 사용자의 비선호 식재료 리스트를 로드하는 메서드
  void _loadUserDislikedFoods() async {
    try {
      String deviceId = deviceController.deviceId.value;
      userDislikedFoodsIds = await _myPageApi.loadUserDislikedFoods(deviceId);
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("비선호 식재료 로드 실패: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  final Map<String, Color> foodColorMap = {
    'nuts': const Color(0xff866464),
    'apple': const Color(0xffEDDC44),
    'banana': const Color(0xffF3D59C),
    'beef': const Color(0xffDCBEEF),
    'bean': const Color(0xff07870D),
    'mackerel': const Color(0xff61A2C7),
    'buckwheat': const Color(0xffC5C761),
    'celery': const Color(0xff9FCC9E),
    'shrimp&crab': const Color(0xffFFAC7D),
    'dairy product': const Color(0xff359EFF),
    'eggs': const Color(0xffFFDB7D),
    'gluten': const Color(0xffF5E6CA),
    'kale': const Color(0xff9CB29C),
    'mushroom': const Color(0xffB75F0D),
    'mustard': const Color(0xff767676),
    'peach': const Color(0xffFFD3D3),
    'peanut': const Color(0xff6B8664),
    'pork': const Color(0xffFE9999),
    'chicken': const Color(0xffF6BC77),
    'squid&clam': const Color(0xffADD2E6),
    'tomato': const Color(0xffA80A0A),
  };

  Color getFoodColor(String food) {
    // 매핑된 색상을 반환하거나, 매핑되지 않았다면 기본 색상을 반환
    return foodColorMap[food] ?? Colors.grey;
  }

  void _displayWarningMotionToast(){
    MotionToast(
      backgroundType: BackgroundType.solid,
      title: Text(
        '❗ WARNING ❗',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.black87,
        ),
      ),
      primaryColor: Colors.amber,
      secondaryColor: Colors.red,
      description: Text(
        'There are disliked materials.',
        style: TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      animationCurve: Curves.elasticOut,
      borderRadius: 10,
      animationDuration: const Duration(milliseconds: 1000),
      icon: Icons.warning,
      iconSize: 35,
      width: 300,
      height: 80,
    ).show(context);
  }

  Widget _Ingredient(List<dynamic>? dislikedMaterials) {

    bool hasDislikedMaterials = dislikedMaterials != null && dislikedMaterials.isNotEmpty && dislikedMaterials.any((materialId) => userDislikedFoodsIds.contains(materialId));

    if (hasDislikedMaterials) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _displayWarningMotionToast();
      });
    }
    // 비선호 식재료가 없는 경우 "No disliked materials" 칩을 표시
    if (dislikedMaterials == null || dislikedMaterials.isEmpty) {
      return _buildChip("No disliked materials", Colors.grey);
    }

    // 비선호 식재료가 있는 경우 각 식재료에 대한 칩을 생성
    List<Widget> chips = dislikedMaterials.map<Widget>((materialId) {
      // select_food.dart의 foodList에서 현재 materialId와 일치하는 식재료 객체를 찾습니다.
      Food? food = foodList.firstWhereOrNull((food) => food.id == materialId);

      // 해당 식재료가 사용자의 비선호 목록에 있는지 확인합니다.
      bool isDisliked = userDislikedFoodsIds.contains(materialId);

      // 식재료 객체를 찾았다면 식재료 칩을 생성합니다.
      if (food != null) {
        if (isDisliked) {
          Vibration.vibrate(duration: 500);
        }

        return Container(
          margin: EdgeInsets.fromLTRB(1.5, 0, 1.5, 0),
          child: Stack(
            alignment: Alignment.topLeft, // "warning" 문구의 위치를 조정합니다.
            children: [
              Container(
                margin: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  border: isDisliked
                      ? Border.all(color: Colors.transparent, width: 2)
                      : null,
                ),
                child: Chip(
                  backgroundColor:
                  isDisliked ? Colors.black : getFoodColor(food.name),
                  avatar: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    child: Image.asset('assets/icon/${food.image}.png',
                        width: 20, height: 20),
                  ),
                  label: Text(
                    food.name,
                    style:
                    const TextStyle(color: Colors.white), // 텍스트 색상을 흰색으로 지정
                  ),
                ),
              ),
              if (isDisliked)
                Positioned(
                  // isDisliked가 true일 경우에만 "warning" 문구를 표시합니다.
                  top: 0,
                  right: 0,
                  child: Container(
                    padding: EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.amber,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '⛔WARNING',
                      style: TextStyle(
                        color: Colors.black87,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      } else {
        return Container();
      }
    }).toList();

    return Scrollbar(
      thickness: 10,
      child: Wrap(
        alignment: WrapAlignment.start,
        spacing: 0.0, //좌우 간격
        runSpacing: 1.0, // 가로로 나열하면서 줄바꿈
        children: [...chips],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (snapshot.hasData) {
          var data = snapshot.data;
          bool isDisliked = data['dislikedMaterials'].any((material) => userDislikedFoodsIds.contains(material));
          return Scaffold(
            appBar: AppBar(
              title: Text('Product Detail'),
            ),
            body: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    // 제품 사진
                    child: Stack(
                      alignment: AlignmentDirectional.topStart,
                      children: [
                        // 제품 사진
                        Container(
                          width: MediaQuery.of(context).size.width,
                          height: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Image.network(
                            data['imgurl'],
                            fit: BoxFit.cover,
                          ),
                        ),
                        if (isDisliked)
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                            child: Image.asset(
                              alignment: Alignment.topLeft,
                              "assets/info/warning.png",
                              width: MediaQuery.of(context).size.width*0.5,
                              height: MediaQuery.of(context).size.width*0.5,
                            ),
                          ),
                      ],
                    ),
                  ),
                  Container(
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text(
                        '   ${data['categorySearchDto']['cat1']}' +
                            " >  " +
                            data['categorySearchDto']['cat2'] +
                            " >  " +
                            data['categorySearchDto']['cat3'],
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // 상품명
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: Text(
                      '  ${data['name']}',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  // 좋아요
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Padding(
                        padding: EdgeInsets.only(right: 10),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 3),
                          width: 85,
                          height: 40,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "   $count",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                              ),
                              IconButton(
                                iconSize: 14,
                                padding: EdgeInsets.symmetric(vertical: 3),
                                icon: Icon(
                                  isLiked
                                      ? Icons.favorite
                                      : Icons.favorite_outline,
                                  color: isLiked ? Colors.red : Colors.white,
                                ),
                                onPressed: () {
                                  print(count);
                                  Like();
                                },
                              ),
                            ],
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Color(0xffCACACA),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  // 재료 목록(비선호/알러지 식품)
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    child: _Ingredient(data['dislikedMaterials']),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // 탭바
                  Container(
                    height: 50,
                    child: TabBar(
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: Text(
                            'Information',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Recommend',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        Tab(
                          child: Text(
                            'Available stock',
                            style: TextStyle(
                                fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    height: 300,
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          // 제품 태그 및 설명
                          child: Column(
                            children: [
                              SizedBox(
                                height: 10,
                              ),
                              // 제품태그
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: <Widget>[
                                  Wrap(
                                    spacing: 8.0, // 각 태그 간의 간격
                                    runSpacing: 4.0, // 줄바꿈 간격
                                    children: _buildTagsList(
                                        data['tagString'] ??
                                            'No tag available'),
                                  ),
                                ],
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              // 상품설명
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(data['description'] ??
                                    'No description available'),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          // 좌우 여유 공간 설정
                          child: Recommendation(productId: productId),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 12.0),
                          // 좌우 여유 공간 설정
                          child: Stock(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        }
        return Text('Error');
      },
    );
  }
}

List<Widget> _buildTagsList(String tagString) {
  List<String> tags = tagString.split(',').map((tag) => tag.trim()).toList();
  return tags.map((tag) => _buildTags(tag, Colors.white)).toList();
}

Widget _buildTags(String label, Color color) {
  return Chip(
    labelPadding: EdgeInsets.all(2.0),
    label: Text(
      label,
      style: TextStyle(
        color: Colors.white,
      ),
    ),
    backgroundColor: Color(0xff343F56),
    elevation: 0.0,
    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

Widget _buildChip(String label, Color color) {
  IconData? icon;
  if (label != 'No disliked materials') {
    icon = Icons.error;
  }

  return Chip(
    labelPadding: EdgeInsets.all(2.0),
    label: Row(
      mainAxisSize: MainAxisSize.min, // 수정: Row의 크기를 최소화
      children: [
        if (icon != null)
          Icon(
            icon,
            color: Colors.red,
            size: 18,
          ),
        SizedBox(width: icon != null ? 5 : 0),
        Flexible(
          // 수정: 칩이 사용 가능한 영역만큼만 차지
          child: Text(
            label,
            style: TextStyle(
              color: Colors.black,
            ),
          ),
        ),
      ],
    ),
    backgroundColor: Colors.amber,
    elevation: 0.0,
    shadowColor: Colors.transparent,
    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(20),
    ),
  );
}

class Recommendation extends StatelessWidget {
  int productId;

  Recommendation({Key? key, required this.productId}) : super(key: key);
  SearchApi searchApi = SearchApi();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: searchApi.getRecommendProducts(productId),
      builder: (context, AsyncSnapshot<List<dynamic>> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('오류: ${snapshot.error}');
        } else if (snapshot.hasData && snapshot.data != null) {
          List<dynamic> recommendedProducts = snapshot.data!;

          // 최대 6개의 아이템만 선택
          recommendedProducts = recommendedProducts.take(6).toList();

          return Wrap(
            alignment: WrapAlignment.center,
            spacing: 8.0, // 가로 간격 조절
            runSpacing: 4.0, // 세로 간격 조절
            children: recommendedProducts.map((product) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraDetailView(
                        itemNo: product['itemNo'],
                      ),
                    ),
                  );
                },
                child: Container(
                  width: 100,
                  height: 100,
                  margin: EdgeInsets.all(4.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(5),
                        child: Image.network(
                          product['imgUrl'],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        }
        return Text('추천 제품이 없습니다.');
      },
    );
  }
}

class Stock extends StatelessWidget {
  const Stock({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 200,
      height: 200,
      child: Center(
          child: Text(
            'Comming Soon !',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 30, color: Colors.black45),
          )),
    );
  }
}
