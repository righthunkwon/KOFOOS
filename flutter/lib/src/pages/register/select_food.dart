import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'api/register_api.dart';

//회원 가입할 때 비선호 음식 선택 페이지
class FoodSelectionPage extends StatefulWidget {
  const FoodSelectionPage({super.key});

  @override
  _FoodSelectionPageState createState() => _FoodSelectionPageState();
}

class _FoodSelectionPageState extends State<FoodSelectionPage> {
  List<Food> selectedFoods = [];

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
    // 화면 크기에 따른 동적 크기 조정
    double imageSize = MediaQuery.of(context).size.width / 10;
    double fontSize = MediaQuery.of(context).size.width / 32;

    return Material(
      // InkWell의 효과를 ClipRRect로 제한
      color: Colors.transparent, // Material의 배경색을 투명하게 설정
      child: InkWell(
        onTap: () => toggleFood(food),
        borderRadius: BorderRadius.circular(40), // InkWell의 모서리 둥글게
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? Colors.blue.shade50 : Colors.transparent,
            border: Border.all(color: Colors.grey.shade300),
            borderRadius: BorderRadius.circular(40),
          ),
          child: Center(
            // Center 위젯으로 감싸서 중앙에 위치시킴
            child: Column(
              mainAxisSize: MainAxisSize.min, // 최소 크기로 설정
              mainAxisAlignment: MainAxisAlignment.center, // 중앙 정렬
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
    'chicken': const Color(0xffF6BC77),
    'squid&clam': const Color(0xffADD2E6),
    'tomato': const Color(0xffA80A0A),
    // ... 다른 음식과 색상들 ...
  };

  Color getFoodColor(String food) {
    // 매핑된 색상을 반환하거나, 매핑되지 않았다면 기본 색상을 반환
    return foodColorMap[food] ?? Colors.grey;
  }

  //칩 위젯 추가
  Widget selectedFoodChip(Food food) {
    return Chip(
      avatar: CircleAvatar(
        backgroundColor: Colors.transparent,
        child: Image.asset(
          'assets/icon/${food.image}.png', // 이미지 파일의 경로
          width: 20.0, // 이미지의 너비
          height: 20.0, // 이미지의 높이
          fit: BoxFit.cover, // 이미지가 알맞게 맞도록
        ),
      ),

      backgroundColor: getFoodColor(food.name),
      // 음식별 지정된 색상을 사용
      label: Text(
        food.name,
        style: const TextStyle(color: Colors.white), // 텍스트 색상을 흰색으로 지정
      ),
      shape: RoundedRectangleBorder(
        side: BorderSide.none, // 테두리 없애기
        borderRadius: BorderRadius.circular(20), // 원하는 모양으로 설정
      ),
      onDeleted: () {
        setState(() {
          selectedFoods.remove(food);
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // 가로세로 길이 동일하게 설정
    final double gridItemSize = MediaQuery.of(context).size.width / 3 - 16;
    // 가로로 3개씩 표시될 수 있게 GridView.builder 사용
    return Scaffold(
      // appBar: AppBar(
      //   backgroundColor: Colors.blue,
      //   title: const Text('Any foods you cannot eat?'),
      // ),
      body: Column(
        children: <Widget>[
          const SizedBox(height: 70),
          const Padding(
            padding: EdgeInsets.only(left: 40.0), // 왼쪽에 20 픽셀의 패딩을 추가
            child: Align(
              alignment: Alignment.centerLeft, // 텍스트를 왼쪽으로 정렬
              child: Text(
                "Any foods",
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
                "you cannot eat?",
                style: TextStyle(
                  fontSize: 28, // 폰트 크기 설정
                  fontWeight: FontWeight.w600,
                  // 추가적인 텍스트 스타일링 옵션
                ),
              ),
            ),
          ),
          Expanded(
            // GridView를 Expanded 위젯으로 감싸 화면 크기에 맞게 조절
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
                onPressed: () => submitSelection(context, selectedFoods),
                child: const Text('Next'),
              ),
            ),
          ),
          const SizedBox(height: 55),
        ],
      ),
    );
  }
}

class Food {
  final int id;
  final String name;
  final String image;

  Food({required this.id, required this.name, required this.image});

  factory Food.fromJson(Map<String, dynamic> json) {
    return Food(
      id: json['id'],
      name: json['name'],
      image: json['image'],
    );
  }
}

//식품 목록.
List<Food> foodList = [
  Food(id: 0, name: 'dairy product', image: 'dairy product'),
  Food(id: 1, name: 'eggs', image: 'eggs'),
  Food(id: 2, name: 'gluten', image: 'gluten'),
  Food(id: 3, name: 'shrimp&crab', image: 'shrimp&crab'),
  Food(id: 4, name: 'peanut', image: 'peanut'),
  Food(id: 5, name: 'nuts', image: 'nuts'),
  Food(id: 6, name: 'pork', image: 'pork'),
  Food(id: 7, name: 'beef', image: 'beef'),
  Food(id: 8, name: 'peach', image: 'peach'),
  Food(id: 9, name: 'mackerel', image: 'mackerel'),
  Food(id: 10, name: 'squid&clam', image: 'squid&clam'),
  Food(id: 11, name: 'chicken&duck', image: 'chicken'),
  Food(id: 12, name: 'buckwheat', image: 'buckwheat'),
  Food(id: 13, name: 'bean', image: 'bean'),
  Food(id: 14, name: 'apple', image: 'apple'),
  Food(id: 15, name: 'tomato', image: 'tomato'),
  Food(id: 16, name: 'banana', image: 'banana'),
  Food(id: 17, name: 'kale', image: 'kale'),
  Food(id: 18, name: 'celery', image: 'celery'),
  Food(id: 19, name: 'mushroom', image: 'mushroom'),
  Food(id: 20, name: 'mustard', image: 'mustard'),
];
