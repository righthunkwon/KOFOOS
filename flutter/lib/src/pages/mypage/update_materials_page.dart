import 'package:flutter/material.dart';
import '../register/select_food.dart';
import 'api/mypage_api.dart';

// 사용자가 이전에 선택한 비선호 식재료 목록을 수정하는 페이지
class DislikeFoodEditPage extends StatefulWidget {
  final String deviceId; // 사용자 ID를 전달받기 위한 변수

  // 생성자를 통해 사용자 ID를 받습니다.
  const DislikeFoodEditPage({Key? key, required this.deviceId}) : super(key: key);

  @override
  _DislikeFoodEditPageState createState() => _DislikeFoodEditPageState();
}

class _DislikeFoodEditPageState extends State<DislikeFoodEditPage> {
  List<Food> selectedFoods = []; // 사용자가 선택한 비선호 식재료 목록을 저장할 변수
  bool isLoading = true; // 데이터 로딩 상태를 표시하기 위한 변수
  final MyPageApi _myPageApi = MyPageApi(); // MyPageApi 인스턴스 생성

  @override
  void initState() {
    super.initState();
    _loadUserDislikedFoods(); // 수정된 함수 호출
  }

  //기존에 선택한 비선호 음식 리스트 가져오기
  void _loadUserDislikedFoods() async {
    try {
      List<int> dislikedFoodsIds =
      await _myPageApi.loadUserDislikedFoods(widget.deviceId);
      setState(() {
        selectedFoods = foodList
            .where((food) => dislikedFoodsIds.contains(food.id))
            .toList();
        isLoading = false;
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  void toggleFood(Food food) {
    setState(() {
      if (selectedFoods.contains(food)) {
        selectedFoods.remove(food);
      } else {
        selectedFoods.add(food);
      }
    });
  }

  Widget foodButton(Food food) {
    bool isSelected = selectedFoods.contains(food);
    double imageSize = MediaQuery.of(context).size.width / 10;
    double fontSize = MediaQuery.of(context).size.width / 32;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => toggleFood(food),
        borderRadius: BorderRadius.circular(40),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/icon/${food.image}.png',
                    width: imageSize, height: imageSize),
                const SizedBox(height: 6),
                Text(food.name, style: TextStyle(fontSize: fontSize)),
              ],
            ),
          ),
        ),
      ),
    );
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
    'chicken&duck': const Color(0xffF6BC77),
    'squid&clam': const Color(0xffADD2E6),
    'tomato': const Color(0xffA80A0A),
    // ... 다른 음식과 색상들 ...
  };

  Color getFoodColor(String food) {
    // 매핑된 색상을 반환하거나, 매핑되지 않았다면 기본 색상을 반환
    return foodColorMap[food] ?? Colors.grey;
  }

  Widget selectedFoodChip(Food food) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset('assets/icon/${food.image}.png',
          width: 20.0,
          height: 20.0,
          fit: BoxFit.cover,
        ),
      ),

      // backgroundColor: getFoodColor(food.name),

      label: Text(food.name, style: const TextStyle(color: Colors.white)),
      backgroundColor: getFoodColor(food.name), // 예시: 선택된 음식에 대한 색상은 blue로 설정
      onDeleted: () => toggleFood(food),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double gridItemSize = MediaQuery.of(context).size.width / 3 - 16;

    return Scaffold(
      // appBar: AppBar(title: const Text('Edit Disliked Foods')),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: <Widget>[
          const SizedBox(height: 70),
          const Padding(
            padding: EdgeInsets.only(left: 40.0), // 왼쪽에 20 픽셀의 패딩을 추가
            child: Align(
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
              child: Text(
                "Update foods",
                style: TextStyle(
                  fontSize: 30, // 폰트 크기 설정
                  fontWeight: FontWeight.w600,
                  // 추가적인 텍스트 스타일링 옵션
                ),
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(left: 40.0), // 왼쪽에 20 픽셀의 패딩을 추가
            child: Align(
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
              child: Text(
                "you cannot eat ",
                style: TextStyle(
                  fontSize: 28, // 폰트 크기 설정
                  fontWeight: FontWeight.w600,
                  // 추가적인 텍스트 스타일링 옵션
                ),
              ),
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(vertical: 30, horizontal: 40),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                childAspectRatio: 1.0,
              ),
              itemCount: foodList.length,
              itemBuilder: (context, index) {
                return SizedBox(
                  width: gridItemSize,
                  height: gridItemSize,
                  child: foodButton(foodList[index]),
                );
              },
            ),
          ),
          if (selectedFoods.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Wrap(
                spacing: 8.0, // 칩 사이의 공간
                children: selectedFoods
                    .map((food) => selectedFoodChip(food))
                    .toList(),
              ),
            ),
          Align(
            alignment: Alignment.bottomRight, // 우측 하단에 정렬
            child: Padding(
              padding: const EdgeInsets.only(top: 25, right: 40),
              child: ElevatedButton(
                onPressed: _submitSelection,
                child: const Text('Done'),
              ),
            ),
          ),
          const SizedBox(height: 55),
        ],
      ),
    );
  }

  //변경사항 반영하기
  void _submitSelection() async {
    try {
      await _myPageApi.submitDislikedFoods(
          widget.deviceId, selectedFoods.map((food) => food.id).toList());
      Navigator.pop(context,true); // 성공 시 이전 화면으로 돌아가기
    } catch (e) {
      print(e);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to update disliked foods.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
