import 'package:flutter/material.dart';
import 'package:kofoos/src/pages/search/search_detail_page.dart';

void homeEditorFunc(BuildContext context, int i) {
  String itemNo = '';
  if (i == 0) itemNo = '20114';
  else if (i == 1) itemNo = '15839';
  else if (i == 2) itemNo = '30078';
  else if (i == 3) itemNo = '60120';
  else if (i == 4) itemNo = '15054';
  else if (i == 5) itemNo = '35218';
  else if (i == 6) itemNo = '40095';
  else if (i == 7) itemNo = '10093';
  else if (i == 8) itemNo = '30069';
  else if (i == 9) itemNo = '45082';
  else if (i == 10) itemNo = '45083';
  else if (i == 11) itemNo = '2006';
  else if (i == 12) itemNo = '15088';
  else if (i == 13) itemNo = '15455';
  else if (i == 14) itemNo = '15478';

  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProductDetailView(
        itemNo: itemNo,
      ),
    ),
  );
}
