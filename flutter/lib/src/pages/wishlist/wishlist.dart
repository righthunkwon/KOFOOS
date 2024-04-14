import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../root/root_controller.dart';
import '../search/api/search_api.dart';
import '../search/search_detail_page.dart';
import 'ImageScan.dart';
import 'WishlistDetectionDto.dart';
import 'api/model/FolderDto.dart';
import 'api/wishlist_api.dart';
import 'package:image_picker/image_picker.dart';
import 'package:carousel_slider/carousel_slider.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({Key? key}) : super(key: key);

  @override
  _WishlistState createState() => _WishlistState();
}

class _WishlistState extends State<Wishlist> {
  // 이미지 선택 상태를 관리하기 위한 집합
  final Set<int> _selectedItems = {};

  List<FolderDto> folderList = [];
  WishlistApi wishlistApi = WishlistApi();
  int _itemCount = 0;
  bool _isEditing = false; // 편집 모드 상태를 관리하는 변수
  List<String> _imagePaths = []; // 이미지 파일 경로를 저장할 리스트
  int _current = 0;
  late PageController _pageController;
  SearchApi searchApi = SearchApi();
  late List<String> results;
  ImageScan imageScan = ImageScan();
  List<WishlistDetectionDto>? wishlistDetections = null;

  WishlistDetectionDto? _selectedDetection; // 선택된 이미지 정보를 저장할 변수
  bool _isButtonVisible = false; // 버튼 표시 상태를 관리할 변수
  List<WishlistDetectionDto> _checkedItems = []; // 체크된 아이템의 ID를 저장하는 리스트

  // 상태 변수로 isLoading을 추가합니다. 기본값은 false입니다.
  bool isLoading = false;

  int _currentPageIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchWishlistFolders();
    _pageController = PageController(initialPage: 0);
  }

  Future<void> fetchWishlistFolders() async {
    try {
      var folders = await wishlistApi.getWishlistFolder();
      setState(() {
        folderList = folders;
        // 모든 폴더의 아이템 수를 합산하여 _itemCount를 업데이트
        _itemCount =
            folderList.fold(0, (sum, folder) => sum + folder.items.length);
      });
    } catch (e) {
      print('폴더 목록 가져오기 실패: $e');
    }

    await imageScan.initializeModel(); // 모델 초기화
  }

  Future<void> updateWishlistBought() async {
    try {
      await wishlistApi.sendSelectedItemsToServer(_selectedItems);
      setState(() {
        fetchWishlistFolders(); // UI를 갱신하기 위해 데이터를 다시 불러옵니다.
        _selectedItems.clear();
      });
    } catch (e) {
      print('위시리스트 제품 구매여부 변환 실패: $e');
    }
  }

  Future<void> deleteWishlistItem() async {
    try {
      await wishlistApi.deleteWishlistItems(_selectedItems);
      setState(() {
        fetchWishlistFolders(); // UI를 갱신하기 위해 데이터를 다시 불러옵니다.
        _selectedItems.clear();
      });
    } catch (e) {
      print('위시리스트 제품 구매여부 변환 실패: $e');
    }
  }

  Future<void> restoreWishlistItem() async {
    try {
      await wishlistApi.restoreWishlistItems(_selectedItems);
      setState(() {
        fetchWishlistFolders(); // UI를 갱신하기 위해 데이터를 다시 불러옵니다.
        _selectedItems.clear();
      });
    } catch (e) {
      print('위시리스트 제품 구매여부 변환 실패: $e');
    }
  }

  Future<String> getProductDetail(String itemNo) async {
    if(itemNo==null)
      return "X";
    Map<String, dynamic> product = await searchApi.getProductDetail(itemNo);
    return product['imgurl'];
  }

  Future<void> _pickImages() async {
    setState(() {
      isLoading = true; // 이미지를 선택하고 처리를 시작할 때 로딩 상태를 true로 설정합니다.
    });
    List<WishlistDetectionDto> items = [];
    final ImagePicker picker = ImagePicker();

    final List<XFile>? images = await picker.pickMultiImage();

    if (images != null && images.isNotEmpty) {
      print('이미지 개수');
      print(images.length);
      for (var file in images) {
        List<ResultDto> results =
        await imageScan.runObjectDetectionYoloV8(file) as List<ResultDto>;

        print('진단 결과 개수');
        print(results.length);
        String? itemNo;

        if(results.length==0){
          print('진단 개수 Null');
          items.add(WishlistDetectionDto(itemNo: null, score: 0, imageUrl: file.path));
        }
        for (var result in results) {
          if (result == null)  {
            itemNo = null;
          } else {
            itemNo = findItemNoByMaxScore(results);
          }
          items.add(WishlistDetectionDto(itemNo: itemNo, score: result.score, imageUrl: file.path));
        }
      }
    }
    print('아이템스의 개수');
    print(items.length);

    setState(() {
      wishlistDetections = items;
      isLoading=false;
    });
  }

  String findItemNoByMaxScore(List<ResultDto> results) {
    double max = 0;
    String maxDetection = results[0].name;

    for (var result in results!) {
      if (max < result.score) {
        max = result.score;
        maxDetection = result.name;
      }
    }

    return maxDetection.split("_")[0];
  }

  // 로딩 인디케이터를 표시하는 위젯을 만드는 함수입니다.
  Widget _buildLoadingIndicator() {
    return Center(
      child: CircularProgressIndicator(),
    );
  }

  void _onLongPress(WishlistDetectionDto detection) {
    setState(() {
      _selectedDetection = detection;
      _isButtonVisible = true;
    });
  }

  Future<void> _onInsertPressed() async {
    if (wishlistDetections == null || _currentPageIndex < 0 || _currentPageIndex >= wishlistDetections!.length) {
      print('유효하지 않은 상태입니다.');
      return;
    }

    try {
      await wishlistApi.insertItem(wishlistDetections?[_currentPageIndex]);
      setState(() {
        // 현재 페이지에 해당하는 항목을 리스트에서 제거
        wishlistDetections!.removeAt(_currentPageIndex);
        // 항목 제거 후, 현재 페이지 인덱스 조정
        if (_currentPageIndex >= wishlistDetections!.length) {
          _currentPageIndex = wishlistDetections!.length - 1;
        }
        // 버튼 숨기기
        _isButtonVisible = false;
        fetchWishlistFolders();
      });
    } catch (e) {
      print('위시리스트 제품 구매여부 변환 실패: $e');
      // 사용자에게 오류 발생을 알림
      // 예: showDialog, ScaffoldMessenger.of(context).showSnackBar 등을 사용
    } finally {
      setState(() {
        _isButtonVisible = false; // 버튼 숨기기
      });
    }
  }
  Future<void> _onDeletePressed() async {
    if (wishlistDetections == null || _currentPageIndex < 0 || _currentPageIndex >= wishlistDetections!.length) {
      print('유효하지 않은 상태입니다.');
      return;
    }

    try {
      wishlistDetections?[_currentPageIndex].itemNo="10000000" ;
      await wishlistApi.insertItem(wishlistDetections?[_currentPageIndex]);
      setState(() {
        // 현재 페이지에 해당하는 항목을 리스트에서 제거
        wishlistDetections!.removeAt(_currentPageIndex);
        // 항목 제거 후, 현재 페이지 인덱스 조정
        if (_currentPageIndex >= wishlistDetections!.length) {
          _currentPageIndex = wishlistDetections!.length - 1;
        }
        // 버튼 숨기기
        _isButtonVisible = false;
        fetchWishlistFolders();
      });
    } catch (e) {
      print('위시리스트 제품 구매여부 변환 실패: $e');
      // 사용자에게 오류 발생을 알림
      // 예: showDialog, ScaffoldMessenger.of(context).showSnackBar 등을 사용
    } finally {
      setState(() {
        _isButtonVisible = false; // 버튼 숨기기
        fetchWishlistFolders();
      });
    }
  }
  Widget _buildCarouselSlider() {
    return Stack(
      children: [
        Container(
          margin: EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.white, // 배경 색상을 흰색으로 설정
            boxShadow: [
              // 그림자 효과 추가
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 2,
                blurRadius: 7,
                offset: Offset(0, 3),
              ),
            ],
            borderRadius: BorderRadius.circular(8.0),
          ),
          child: CarouselSlider(
            options: CarouselOptions(
              autoPlay: false,
              // 자동 재생 활성화
              aspectRatio: 2.0,
              enlargeCenterPage: true,
              // 중앙의 슬라이드를 크게 표시
              viewportFraction: 1,
              // 슬라이드의 뷰포트 비율
              onPageChanged: (index, reason) {
                setState(() {
                  _currentPageIndex = index; // 현재 페이지 인덱스 업데이트
                });
              },
            ),
            items: _buildCarouselWithResults(),
          ),
        ),
        // 버튼 디자인 개선
        if (_isButtonVisible)
          Positioned(
            bottom: 16,
            right: 100,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: _onInsertPressed,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.indigo , // 버튼 배경 색상 개선
                    onPrimary: Colors.white, // 버튼 텍스트 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // 버튼 모서리 둥글게
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // 내부 패딩
                    elevation: 5, // 버튼의 그림자 강조
                  ),
                  child: Text(
                    'CORRECT',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(width: 10), // 버튼 사이의 간격
                ElevatedButton(
                  onPressed: _onDeletePressed,
                  style: ElevatedButton.styleFrom(
                    primary: Colors.red, // DELETE 버튼 배경 색상
                    onPrimary: Colors.white, // 버튼 텍스트 색상
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0), // 버튼 모서리 둥글게
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0), // 내부 패딩
                    elevation: 5, // 버튼의 그림자 강조
                  ),
                  child: Text(
                    'WRONG',
                    style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),

      ],
    );
  }

  Widget _buildPhotoUploadWidget() {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 1,
            blurRadius: 5,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Text(
            'upload a picture',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18.0,
              color: Colors.black54,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 8.0),
          Text(
            'Find products faster through AI',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.black45,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16.0),
          ElevatedButton.icon(
            onPressed: _pickImages,
            icon: Icon(Icons.cloud_upload_outlined, size: 24),
            label: Text('Image Upload'),
            style: ElevatedButton.styleFrom(
              primary: Colors.blueAccent, // 버튼 배경 색상
              onPrimary: Colors.white, // 버튼 텍스트 색상
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30.0), // 버튼 모서리 둥글게
              ),
              padding: EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 10.0,
              ),
              elevation: 3, // 버튼의 그림자 강조
            ),
          ),
        ],
      ),
    );
  }

  // 클래스 수준의 상태 변수
  Map<String, bool> _showButtons = {};

  List<Widget> _buildCarouselWithResults() {
    List<Widget> carouselItems = [];

    if (wishlistDetections == null || wishlistDetections!.isEmpty) {
      carouselItems.add(_buildPhotoUploadWidget());
    } else {
      carouselItems.addAll(wishlistDetections!.map((wishlistDetection) {
        return GestureDetector(
          onTap: () {
            if (wishlistDetection.itemNo != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ProductDetailView(
                    itemNo: wishlistDetection.itemNo!,
                  ),
                ),
              );
            }
          },
          onLongPress: () {
            setState(() {
              _isButtonVisible = true;
            });
          },
          child: Container(
            margin: EdgeInsets.all(5.0),
            child: Column(
              children: [
                SizedBox(
                  height: 120, // 고정된 높이 설정
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center, // 가운데 정렬
                    children: <Widget>[
                      Image.file(
                        File(wishlistDetection.imageUrl),
                        width: 120, // 가로 크기 조정
                        height: 120, // 세로 크기 조정
                        fit: BoxFit.cover,
                      ),
                      SizedBox(width: 10), // 두 이미지 사이의 간격
                      if (wishlistDetection.itemNo != null)
                        Stack(
                          children: [
                            if (wishlistDetection.itemNo != null)
                              FutureBuilder<String>(
                                future: getProductDetail(wishlistDetection.itemNo!),
                                builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
                                  if (snapshot.connectionState == ConnectionState.waiting) {
                                    return SizedBox(
                                      width: 120,
                                      height: 120,
                                      child: Center(child: CircularProgressIndicator()),
                                    );
                                  } else if (snapshot.hasError || snapshot.data == null) {
                                    return SizedBox(
                                      width: 100,
                                      height: 100,
                                      child: Center(child: Text('Error: ${snapshot.error}')),
                                    );
                                  } else {
                                    return Image.network(
                                      snapshot.data!,
                                      width: 100,
                                      height: 100,
                                      fit: BoxFit.cover,
                                    );
                                  }
                                },
                              ),
                            if (wishlistDetection.itemNo != null)
                              Positioned(
                                right: 0,
                                child: Container(
                                  padding: EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: Colors.black54,
                                    borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(8),
                                    ),
                                  ),
                                  child: Text(
                                    '${wishlistDetection.score.toStringAsFixed(2)}', // Assuming score is a double
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        )


                    ],
                  ),
                ),
                // 버튼 표시를 제거합니다.
              ],
            ),
          ),
        );
      }).toList());
    }

    return carouselItems; // List<Widget> 타입 반환
  }

  Widget _buildTabBar() {
    return TabBar(
      tabs: folderList.map((folder) => Tab(text: folder.folderName)).toList(),
    );
  }

  void _toggleEditing() async {
    setState(() {
      _isEditing = !_isEditing;
      if (!_isEditing) {
        _selectedItems.clear();
      }
    });
    RootController.to.isEditing.value = _isEditing;

    if (!_isEditing) {
      if (_selectedItems.isNotEmpty) {
        await updateWishlistBought(); // 선택된 아이템을 서버에 업데이트
      }
      await fetchWishlistFolders(); // 폴더 목록을 다시 가져옴
    }
  }

  Widget _buildGridItem(FolderDto folder, int index) {
    final int wishlistItemId = folder.items[index].wishlistItemId;
    final bool isBought = folder.items[index].bought == 1;
    final bool isSelected = _selectedItems.contains(wishlistItemId);

    return GestureDetector(
      onTap: () {
        if (_isEditing) {
          setState(() {
            if (isSelected) {
              _selectedItems.remove(wishlistItemId);
            } else {
              _selectedItems.add(wishlistItemId);
            }
          });
        } else {
          if(folder.items[index].itemNo != null) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ProductDetailView(
                  itemNo: folder.items[index].itemNo!,
                ),
              ),
            );
          } else {
            // itemNo가 없는 경우 이미지 팝업으로 확대
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  content: Container(
                    width: double.infinity,
                    height: 300.0, // 팝업에서 보여질 이미지의 높이
                    child: Image.network(
                      folder.items[index].imageUrl,
                      fit: BoxFit.cover,
                    ),
                  ),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context); // 팝업 닫기
                      },
                      child: Text('Close'),
                    ),
                  ],
                );
              },
            );
          }
        }
      },
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Image.network(
            folder.items[index].imageUrl,
            width: 102.0,
            height: 120.0,
            fit: BoxFit.cover,
          ),
          // 구매 표시
          if (isBought) ...[
            Container(
              width: 102.0,
              height: 120.0,
              color: Colors.black.withOpacity(0.5),
            ),
            Transform.rotate(
              angle: -0.785398, // 45 degrees in radians
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 4.0, vertical: 2.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.green, width: 2),
                  borderRadius: BorderRadius.circular(4.0),
                ),
                child: Text(
                  'COMPLETE',
                  style: TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
          // 편집 모드에서의 선택 표시
          if (_isEditing)
            Positioned(
              top: 0,
              left: 0,
              child: Container(
                width: 24.0,
                height: 24.0,
                decoration: BoxDecoration(
                  color: Colors.grey.withOpacity(isSelected ? 0 : 1),
                  shape: BoxShape.circle,
                ),
                child: isSelected
                    ? Icon(Icons.check_circle_rounded,
                    color: Colors.blue)
                    : Container(), // 선택되지 않은 경우 회색 동그라미 표시
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTabBarView() {
    print("folderList length: ${folderList.length}");
    return TabBarView(
      children: folderList.map((folder) {
        return GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: folder.items.length,
          itemBuilder: (context, index) {
            return _buildGridItem(folder, index); // 각 이미지를 선택 가능한 아이템으로 구성
          },
        );
      }).toList(),
    );
  }

  Widget _wishlistWidget(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Column(
              children: [
                _buildCarouselSlider(),
                Row(
                  // 페이지 인디케이터를 위한 Row 위젯
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: _buildCarouselWithResults().asMap().entries.map((entry) {
                    return GestureDetector(
                      onTap: () => _pageController.animateToPage(
                        entry.key,
                        duration: Duration(milliseconds: 300), // 애니메이션 지속 시간
                        curve: Curves.easeInOut, // 애니메이션 속도 곡선
                      ),
                      child: Container(
                        width: 12.0,
                        height: 12.0,
                        margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _current == entry.key
                              ? Theme.of(context).primaryColor // 현재 페이지에 해당하는 동그라미는 다른 색상으로
                              : Theme.of(context).primaryColor.withOpacity(0.4), // 나머지 동그라미는 투명도를 낮춤
                        ),
                      ),
                    );
                  }).toList(),
                ),
                Card(
                  elevation: 2.0,
                  margin: EdgeInsets.all(8.0),
                  child: DefaultTabController(
                    length: folderList.length,
                    initialIndex: 0,
                    child: Column(
                      children: [
                        _buildTabBar(),
                        _buildItemCountAndEditButton(),
                        Container(
                          height: 900,
                          child: _buildTabBarView(),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
            isLoading ? _buildLoadingIndicator() : SizedBox(), // isLoading이 true일 때만 로딩 인디케이터를 표시합니다.
          ],
        ),
      ],
    );
  }

  Widget _buildItemCountAndEditButton() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
              'Items (${folderList.fold(0, (previousValue, folder) => previousValue + folder.items.length)})'),
          Obx(() => TextButton(
            onPressed: _toggleEditing,
            child: Text(
                Get.find<RootController>().isEditing.isTrue
                    ? 'Done'
                    : 'Edit',
                style: TextStyle(color: Colors.blue)),
            style: ButtonStyle(
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          )),
        ],
      ),
    );
  }

  Widget _buildEditingBottomBar(BuildContext context) {
    return BottomAppBar(
      color: Colors.black,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          // 첫 번째 항목: 구매
          Column(
            mainAxisSize: MainAxisSize.min, // 내용에 맞게 크기를 최소로 설정
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.check_circle_outline_outlined,
                    color: Colors.white),
                onPressed: updateWishlistBought,
              ),
            ],
          ),
          // 두 번째 항목: 복원
          Column(
            mainAxisSize: MainAxisSize.min, // 내용에 맞게 크기를 최소로 설정
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.shopping_cart_sharp, color: Colors.white),
                onPressed: restoreWishlistItem,
              ),
            ],
          ),
          // 세 번째 항목: 삭제
          Column(
            mainAxisSize: MainAxisSize.min, // 내용에 맞게 크기를 최소로 설정
            children: <Widget>[
              IconButton(
                icon: Icon(Icons.delete, color: Colors.white),
                onPressed: deleteWishlistItem,
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // GetX 컨트롤러 인스턴스를 얻습니다.
    final RootController rootController = Get.find<RootController>();

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            _wishlistWidget(context),
            Padding(
              padding: EdgeInsets.only(bottom: 80.0), // BottomAppBar에 공간을 제공
            ),
          ],
        ),
      ),
      bottomNavigationBar: Obx(
            () => Visibility(
          visible: rootController.isEditing.isTrue,
          child: _buildEditingBottomBar(context),
          replacement: SizedBox.shrink(), // `null` 대신 사용될 위젯
        ),
      ), // Obx를 사용하여 BottomNavigationBar 추가
    );
  }
}
