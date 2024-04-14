import 'package:flutter/material.dart';
import 'package:kofoos/src/pages/search/api/search_api.dart';
import 'package:kofoos/src/pages/search/search_category_page.dart';
import 'package:kofoos/src/pages/search/search_product_page.dart';

class Search extends StatefulWidget {
  Search({Key? key}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  SearchApi searchApi = SearchApi();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 1),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
    _controller.forward();
  }

  Widget _rankingTitle(BuildContext context) {
    return Container(
      height: 70,
      color: Color(0xff343F56),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          children: [
            Icon(
              Icons.add_chart_rounded,
              color: Colors.white,
              size: 32,
            ),
            Text(
              ' Daily Ranking',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _rankingData(BuildContext context) {
    return FutureBuilder<List<String>>(
      future: searchApi.getRanking(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Text('');
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          List<String> ranking = snapshot.data!;
          return ListView.builder(
            itemCount: ranking.length,
            itemBuilder: (context, index) {
              return _buildRankingItem(context, index, ranking);
            },
          );
        }
      },
    );
  }

  Widget _buildRankingItem(
      BuildContext context, int index, List<String> ranking) {

    // 대분류 추출
    List<String> categoryList = ranking
        .map((category) => category.split(',')[0]) // 첫 번째 항목만 추출
        .toList();

    // 중분류 추출
    List<String> subCategoryList = ranking
        .where((category) =>
    category.split(',').length > 1)
        .map((category) => category.split(',')[1])
        .toList();

    // 대분류 이름
    String categoryName = categoryList[index];
    // 중분류 이름(랭킹 목록)
    String subCategoryName = subCategoryList[index];

    if (index == 0 || index == 1 || index == 2) {
      // 랭킹 1, 2, 3위
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchProductPage(
                  cat1: categoryName, cat2:subCategoryName,
                  order: " "
              ),
            ),
          );
        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: index == 0
                ? Colors.amber[400]
                : (index == 1 ? Colors.grey[400] : Colors.brown[500]),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2.0,
                blurRadius: 5.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 16.0,
              ),
              Image.asset(
                'assets/ranking/r${index + 1}.png',
                width: 30.0,
                height: 30.0,
              ),
              SizedBox(
                width: 24.0,
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    subCategoryName,
                    style: TextStyle(
                      fontSize: 18.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    } else {
      // 랭킹 4~7위
      return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchProductPage(
                  cat1: categoryName, cat2:subCategoryName,
                  order: " "
              ),
            ),
          );        },
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: 60.0,
          margin: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
          decoration: BoxDecoration(
            color: Color(0xffECECEC),
            borderRadius: BorderRadius.circular(12.0),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                spreadRadius: 2.0,
                blurRadius: 5.0,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: 26.0,
              ),
              Text(
                '${index + 1}',
                style: TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                width: 40.0,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    subCategoryName,
                    style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }
  }

  Widget _categoryAllButton(BuildContext context) {
    return Positioned(
      bottom: 30.0,
      right: 30.0,
      child: ElevatedButton(
        onPressed: () {
          print('카테고리 전체보기로 이동');
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => SearchCategoryPage(),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          primary: Color(0xff343F56),
          onPrimary: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
        ),
        child: Text('All  >', style: TextStyle(fontSize: 16)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _rankingTitle(context),
        SizedBox(
          height: 12.0,
        ),
        Expanded(
          child: Stack(
            children: [
              _rankingData(context),
              _categoryAllButton(context),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
