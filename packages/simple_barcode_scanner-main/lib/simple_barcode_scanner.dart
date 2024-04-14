library simple_barcode_scanner;

import 'package:flutter/material.dart';
import 'package:simple_barcode_scanner/enum.dart';
import 'package:simple_barcode_scanner/screens/shared.dart';
import 'package:kofoos/src/pages/search/search_detail_page.dart';
import 'package:kofoos/src/pages/camera/camera_detail_view.dart';
import 'package:kofoos/src/pages/search/api/search_api.dart';

export 'package:simple_barcode_scanner/simple_barcode_scanner.dart';

class SimpleBarcodeScannerPage extends StatefulWidget {
  ///Barcode line color default set to #ff6666
  final String lineColor;

  ///Cancel button text while scanning
  final String cancelButtonText;

  ///Flag to show flash icon while scanning or not
  final bool isShowFlashIcon;

  ///Enter enum scanType, It can be BARCODE, QR, DEFAULT
  final ScanType scanType;

  ///AppBar Title
  final String? appBarTitle;

  ///center Title
  final bool? centerTitle;

  final Widget? child;

  @override
  _SimpleBarcodeScannerPageState createState() => _SimpleBarcodeScannerPageState();

  /// appBatTitle and centerTitle support in web and window only
  /// Remaining field support in only mobile devices
  SimpleBarcodeScannerPage({
    Key? key,
    this.lineColor = "#ff6666",
    this.cancelButtonText = "Cancel",
    this.isShowFlashIcon = false,
    this.scanType = ScanType.barcode,
    this.appBarTitle,
    this.centerTitle,
    this.child,
  }) : super(key: key);

}

class _SimpleBarcodeScannerPageState extends State<SimpleBarcodeScannerPage>{




  // void showOverlayButton() async {
  //   if (await FlutterOverlayWindow.isPermissionGranted()) {
  //     await FlutterOverlayWindow.showOverlay(
  //       height: 60,
  //       width: 60,
  //       alignment: OverlayAlignment.bottomRight,
  //       overlayTitle: "Scan",
  //       overlayContent: "Tap to scan",
  //       enableDrag: false,
  //     );
  //   } else {
  //     bool? isGranted = await FlutterOverlayWindow.requestPermission();
  //     if (isGranted ?? false) {
  //       await FlutterOverlayWindow.showOverlay(
  //         height: 60,
  //         width: 60,
  //         alignment: OverlayAlignment.bottomRight,
  //         overlayTitle: "Scan",
  //         overlayContent: "Tap to scan",
  //         enableDrag: false,
  //       );
  //     }
  //   }
  // }

  Key scannerKey = UniqueKey();
  bool isDialogShowing = false;
  void restartScanner() {
    setState(() {
      scannerKey = UniqueKey();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(
          children: <Widget>[
            BarcodeScanner(
              lineColor: widget.lineColor,
              cancelButtonText: widget.cancelButtonText,
              isShowFlashIcon: widget.isShowFlashIcon,
              scanType: widget.scanType,
              appBarTitle: widget.appBarTitle,
              centerTitle: widget.centerTitle,
              onScanned: (res) async {
                SearchApi searchApi = SearchApi();
                var item = await searchApi.getProductByBarcode(res);
                if (item != null && item['name'] != "-") {
                  print("Product found: " + item.toString());
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraDetailView(
                        itemNo: item['itemNo'],
                      ),
                    ),
                  );
                } else if (res != "-1" && item['name'] == "-") {
                  print("No matched product: " + res);
                  if(!isDialogShowing){
                    isDialogShowing = true;
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        Future.delayed(Duration(seconds: 3), () {
                          Navigator.of(context).pop(true);
                        });
                        return AlertDialog(
                          titlePadding: EdgeInsets.zero,
                          title: ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20.0), // 상단 왼쪽을 둥글게 만듭니다.
                              topRight: Radius.circular(20.0), // 상단 오른쪽을 둥글게 만듭니다.
                            ),
                            child: Image.asset(
                              'assets/info/error.gif', // 이미지 경로를 여기에 넣으세요.
                              fit: BoxFit.cover, // 이미지의 너비를 조정하세요.
                              height: 200, // 이미지의 높이를 다이얼로그의 높이로 설정합니다.
                            ),
                          ),
                          content: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text(
                                "No Match Found",
                                style: TextStyle(
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.red,
                                ),
                              ),
                              SizedBox(height: 8),
                              Text(
                                "😢No product information available.😢",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                          backgroundColor: Colors.white,
                        );
                      },
                    ).then((val) {
                      isDialogShowing = false;
                    });
                  }
                  Future.delayed(Duration(seconds: 3), () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => SimpleBarcodeScannerPage()),
                    );
                  });
                } else {
                  Navigator.of(context).pop();
                }
              },
            ),
          ],
        )
    );

  }
}
