import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:kofoos/src/common/back_button_widget.dart';
import 'package:kofoos/src/pages/search/search_detail_page.dart';

import 'api/search_api.dart';

class SearchProductPage extends StatefulWidget {
  const SearchProductPage(
      {Key? key, required this.cat1, required this.cat2, required this.order})
      : super(key: key);

  final String cat1;
  final String cat2;
  final String order;

  @override
  State<SearchProductPage> createState() => _SearchProductPageState();
}

class _SearchProductPageState extends State<SearchProductPage> {
  SearchApi searchApi = SearchApi();
    late Future<dynamic> data;
    int visibleItemCount = 15;

        @override
        void initState() {
      super.initState();
      data = searchApi.getProducts(widget.cat1, widget.cat2, widget.order);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: data,
      builder: (context, AsyncSnapshot<dynamic> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Text('Error');
        } else if (snapshot.hasData) {
          var products = snapshot.data as List<dynamic>;

          return Stack(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    color: Colors.white,
                    child: Text(
                      ' Products(${products.length})',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Expanded(
                    child: NotificationListener<ScrollNotification>(
                      onNotification: (ScrollNotification scrollInfo) {
                        if (scrollInfo.metrics.pixels ==
                            scrollInfo.metrics.maxScrollExtent) {
                          setState(() {
                            visibleItemCount =
                                (visibleItemCount + 15).clamp(0, products.length);
                          });
                        }
                        return false;
                      },
                      child: GridView.builder(
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 3,
                        ),
                        itemCount: visibleItemCount,
                        itemBuilder: (context, index) {
                          if (index < products.length) {
                            return _product(context, products[index]);
                          } else {
                            return SizedBox.shrink();
                          }
                        },
                      ),
                    ),
                  ),
                ],
              ),
              // 추가된 부분
              Positioned(
                child: BackButtonWidget(),
              ),
            ],
          );
        }
        return Text('Error');
      },
    );
  }


}

Widget _product(BuildContext context, dynamic item) {
  String httpImgUrl = item['imgurl'].replaceFirst('https', 'http');
  return GestureDetector(
    onTap: () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProductDetailView(
            itemNo: item['itemNo'],
          ),
        ),
      );
    },
    child: Container(
      margin: const EdgeInsets.all(8),
      width: 100,
      height: 100,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(5.0),
        child: CachedNetworkImage(
          filterQuality: FilterQuality.low,
          imageUrl: httpImgUrl,
          fit: BoxFit.cover,
        ),
      ),
    ),
  );
}
