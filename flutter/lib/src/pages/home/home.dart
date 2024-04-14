import 'package:flutter/material.dart';
import 'package:kofoos/src/pages/home/api/home_api.dart';
import 'package:kofoos/src/pages/home/func/home_recommend_func.dart';
import 'package:kofoos/src/pages/home/home_editor_page_2.dart';
import 'package:kofoos/src/pages/home/home_editor_page_3.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:kofoos/src/pages/home/home_editor_page_1.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:kofoos/src/pages/search/api/search_api.dart';
import 'package:kofoos/src/pages/search/search_detail_page.dart';

class Home extends StatelessWidget {
  Home({Key? key}) : super(key: key);
  HomeApi homeApi = HomeApi();
  SearchApi searchApi = SearchApi();

  Widget _homeEditorWidget(BuildContext context) {
    return CarouselSlider.builder(
      itemCount: 3,
      options: CarouselOptions(
        height: 300,
        viewportFraction: 1.0,
        enableInfiniteScroll: true,
        autoPlay: true,
        autoPlayInterval: Duration(seconds: 4),
        autoPlayAnimationDuration: Duration(milliseconds: 800),
        autoPlayCurve: Curves.fastOutSlowIn,
      ),
      itemBuilder: (BuildContext context, int index, int realIndex) {
        return GestureDetector(
          onTap: () {
            if (index == 0) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeEditorPage1(),
                ),
              );
            } else if (index == 1) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeEditorPage2(),
                ),
              );
            } else if (index == 2) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeEditorPage3(),
                ),
              );
            }
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 300,
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage('assets/editor/carousel/e$index.jpg'),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _homeRecommendWidget1(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: homeApi.getRecommendHot(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('No data available');
        } else {
          List<dynamic> recommendHotList = snapshot.data!;
          return Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'What\'s Hot in Korea 🔥',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  // 전체보기 버튼
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      print('해당 테마 상품 전체보기 기능 추가 필요');
                      homeRecommendFunc(context, recommendHotList);
                    },
                    child: Text(
                      'All  >',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < recommendHotList.length; i++)
                        GestureDetector(
                          onTap: () {
                            String itemNo = recommendHotList[i]['itemNo'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailView(
                                  itemNo: itemNo,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: recommendHotList[i]['imgUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 30,
                thickness: 2.0,
                color: Color(0xffECECEC),
              ),
            ],
          );
        }
      },
    );
  }

  // Widget _homeRecommendWidget2(BuildContext context) {
  //   return FutureBuilder<List<dynamic>>(
  //     future: homeApi.getRecommendHistory(),
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         return Container();
  //       } else {
  //         // 기본적으로 recommend 데이터를 보여주는 UI 코드 작성
  //         List<dynamic> recommendHistoryList = snapshot.data!;
  //         return Column(
  //           children: [
  //             SizedBox(
  //               height: 10.0,
  //             ),
  //             Row(
  //               children: [
  //                 SizedBox(
  //                   width: 10.0,
  //                 ),
  //                 Text(
  //                   'Just For You ✨',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 Spacer(),
  //                 TextButton(
  //                   style: TextButton.styleFrom(
  //                     padding: EdgeInsets.zero,
  //                   ),
  //                   onPressed: () {
  //                     print('해당 테마 상품 전체보기 기능 추가 필요');
  //                     homeRecommendFunc(context, recommendHistoryList);
  //                   },
  //                   child: Text(
  //                     'All  >',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               height: 120,
  //               child: SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: Row(
  //                   children: [
  //                     for (int i = 0; i < recommendHistoryList.length; i++)
  //                       GestureDetector(
  //                         onTap: () {
  //                           String itemNo = recommendHistoryList[i]['itemNo'];
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => ProductDetailView(
  //                                 itemNo: itemNo,
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                         child: Container(
  //                           margin: const EdgeInsets.all(8),
  //                           width: 100,
  //                           height: 100,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(5),
  //                             child: CachedNetworkImage(
  //                               imageUrl: recommendHistoryList[i]['imgUrl'],
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Divider(
  //               height: 40,
  //               thickness: 0,
  //               color: Color(0xffECECEC),
  //             ),
  //           ],
  //         );
  //       }
  //     },
  //   );
  // }
  //
  // Widget _homeRecommendWidget3(BuildContext context) {
  //   return FutureBuilder<List<dynamic>>(
  //     future: searchApi.getRecommendProducts('2313'), // productId를 2313으로 넣어 호출
  //     builder: (context, snapshot) {
  //       if (snapshot.connectionState == ConnectionState.waiting) {
  //         return Center(child: CircularProgressIndicator());
  //       } else if (snapshot.hasError) {
  //         return Text('Error: ${snapshot.error}');
  //       } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
  //         // 히스토리가 없을 경우 초기 추천 제품을 보여줌
  //         return Text('준비중');
  //       } else {
  //         // recommend 데이터를 보여주는 UI 코드 작성
  //         List<dynamic> recommendProductsList = snapshot.data!;
  //         return Column(
  //           children: [
  //             SizedBox(
  //               height: 10.0,
  //             ),
  //             Row(
  //               children: [
  //                 SizedBox(
  //                   width: 10.0,
  //                 ),
  //                 Text(
  //                   'Just For You ✨',
  //                   style: TextStyle(
  //                     fontSize: 20,
  //                     fontWeight: FontWeight.bold,
  //                   ),
  //                 ),
  //                 Spacer(),
  //                 TextButton(
  //                   style: TextButton.styleFrom(
  //                     padding: EdgeInsets.zero,
  //                   ),
  //                   onPressed: () {
  //                     print('해당 테마 상품 전체보기 기능 추가 필요');
  //                     homeRecommendFunc(context, recommendProductsList);
  //                   },
  //                   child: Text(
  //                     'All  >',
  //                     style: TextStyle(
  //                       fontSize: 14,
  //                       color: Colors.grey,
  //                     ),
  //                   ),
  //                 ),
  //               ],
  //             ),
  //             Container(
  //               height: 120,
  //               child: SingleChildScrollView(
  //                 scrollDirection: Axis.horizontal,
  //                 child: Row(
  //                   children: [
  //                     for (int i = 0; i < recommendProductsList.length; i++)
  //                       GestureDetector(
  //                         onTap: () {
  //                           String itemNo = recommendProductsList[i]['itemNo'];
  //                           Navigator.push(
  //                             context,
  //                             MaterialPageRoute(
  //                               builder: (context) => ProductDetailView(
  //                                 itemNo: itemNo,
  //                               ),
  //                             ),
  //                           );
  //                         },
  //                         child: Container(
  //                           margin: const EdgeInsets.all(8),
  //                           width: 100,
  //                           height: 100,
  //                           child: ClipRRect(
  //                             borderRadius: BorderRadius.circular(5),
  //                             child: CachedNetworkImage(
  //                               imageUrl: recommendProductsList[i]['imgUrl'],
  //                               fit: BoxFit.cover,
  //                             ),
  //                           ),
  //                         ),
  //                       ),
  //                   ],
  //                 ),
  //               ),
  //             ),
  //             Divider(
  //               height: 40,
  //               thickness: 0,
  //               color: Color(0xffECECEC),
  //             ),
  //           ],
  //         );
  //       }
  //     },
  //   );
  // }


  Widget _homeRecommendWidget2(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: homeApi.getRecommendHistory(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return _homeRecommendWidget3(context);
        } else {
          List<dynamic> recommendHistoryList = snapshot.data!;
          return Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Just For You ✨',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      print('해당 테마 상품 전체보기 기능 추가 필요');
                      homeRecommendFunc(context, recommendHistoryList);
                    },
                    child: Text(
                      'All  >',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < recommendHistoryList.length; i++)
                        GestureDetector(
                          onTap: () {
                            String itemNo = recommendHistoryList[i]['itemNo'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailView(
                                  itemNo: itemNo,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: recommendHistoryList[i]['imgUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 40,
                thickness: 0,
                color: Color(0xffECECEC),
              ),
            ],
          );
        }
      },
    );
  }

  Widget _homeRecommendWidget3(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: searchApi.getRecommendProducts(2313), // productId를 2313으로 넣어 호출
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else {
          List<dynamic> defaultRecommendList = snapshot.data!;
          return Column(
            children: [
              SizedBox(
                height: 10.0,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 10.0,
                  ),
                  Text(
                    'Just For You ✨',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Spacer(),
                  TextButton(
                    style: TextButton.styleFrom(
                      padding: EdgeInsets.zero,
                    ),
                    onPressed: () {
                      print('해당 테마 상품 전체보기 기능 추가 필요');
                      homeRecommendFunc(context, defaultRecommendList);
                    },
                    child: Text(
                      'All  >',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                height: 120,
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      for (int i = 0; i < defaultRecommendList.length; i++)
                        GestureDetector(
                          onTap: () {
                            String itemNo = defaultRecommendList[i]['itemNo'];
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ProductDetailView(
                                  itemNo: itemNo,
                                ),
                              ),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(8),
                            width: 100,
                            height: 100,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(5),
                              child: CachedNetworkImage(
                                imageUrl: defaultRecommendList[i]['imgUrl'],
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              Divider(
                height: 40,
                thickness: 0,
                color: Color(0xffECECEC),
              ),
            ],
          );
        }
      },
    );
  }


  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          _homeEditorWidget(context),
          _homeRecommendWidget1(context),
          _homeRecommendWidget2(context),
        ],
      ),
    );
  }
}
