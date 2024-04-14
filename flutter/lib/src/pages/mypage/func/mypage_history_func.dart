import 'package:flutter/material.dart';

import '../../search/search_detail_page.dart';

void goToProductDetail(BuildContext context, String productItemNo) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailView(
        itemNo: productItemNo,
      ),
    ),
  );
}
