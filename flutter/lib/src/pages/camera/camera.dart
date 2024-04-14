import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kofoos/src/pages/camera/camera_detail_view.dart';
import 'package:kofoos/src/pages/home/home.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:simple_barcode_scanner/simple_barcode_scanner.dart';
import 'dart:async';

import '../../root/root_controller.dart';
import '../search/api/search_api.dart';
import '../search/search_detail_page.dart';
import 'box_widget.dart';
import 'camera_view.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  State<Camera> createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  var _count = 0;
  Timer? _detectionTimer;
  final _detectionTimeout = Duration(seconds: 10);
  final _maxFailures = 10;
  bool _isWarningMessageShown = false;
  List<ResultObjectDetection>? results;
  Duration? objectDetectionInferenceTime;

  String? classification;
  Duration? classificationInferenceTime;

  @override
  void initState() {
    super.initState();
    _resetDetection();
  }

  @override
  void dispose() {
    _detectionTimer?.cancel();
    super.dispose();
  }

  void _resetDetection() {
    _count = 0;
    _startDetectionTimer();
    _isWarningMessageShown = false;
    }

  void _startDetectionTimer() {
    _detectionTimer?.cancel();
    _detectionTimer = Timer(_detectionTimeout, _evaluateDetectionFailure);
  }

  void _evaluateDetectionFailure() {
    if ((_count >= _maxFailures || _detectionTimer?.isActive == false) && !_isWarningMessageShown) {
      _showNoMatchFoundDialog();
      _isWarningMessageShown = true;
    }
  }

  void _showNoMatchFoundDialog() {
    if (!_isWarningMessageShown) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            titlePadding: EdgeInsets.zero,
            title: ClipRRect(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20.0),
                topRight: Radius.circular(20.0),
              ),
              child: Image.asset(
                'assets/info/error.gif',
                fit: BoxFit.cover,
                height: 200,
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
                    color: Colors.black,
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  "No matching products found after multiple attempts.",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffCACACA),

                  ),
                ),
                SizedBox(height: 12),
                Text(
                  "How about trying the barcode scanner button?",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color(0xffCACACA),
                  ),
                ),
              ],
            ),
            actions: <Widget>[
              TextButton(
                child: Text("OK", style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.of(context).pop();
                  _resetDetection();
                },
              ),
            ],
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20.0),
            ),
            backgroundColor: Colors.white,
          );
        },
      );
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: <Widget>[
            // Camera View
            CameraView(resultsCallback, resultsCallbackClassification),
            // Bounding boxes
            boundingBoxes2(results),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: EdgeInsets.only(bottom: 20.0),
        child: FloatingActionButton(
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => SimpleBarcodeScannerPage()),
            );
          },
          child: Icon(Icons.barcode_reader),
          backgroundColor: Color(0xffECECEC),
          foregroundColor: Color(0xff343F56),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  void showSnackBar(BuildContext context, List<ResultObjectDetection>? results) async {
    if (results == null || results.isEmpty) {
      return;
    }

    ScaffoldMessenger.of(context).hideCurrentSnackBar();

    String? itemNo;
    bool showMoreDetail = false;
    SearchApi searchApi = SearchApi();
    dynamic data;

    for (var result in results) {
      if (result.score > 0.75) {
        itemNo = result.className?.split("_")[0];
        showMoreDetail = true;
        break;
      }
    }

    if (itemNo != null) {
      data = await searchApi.getProductDetail(itemNo);
    }

    if (showMoreDetail && data != null && !_isWarningMessageShown) {
      _count = 0;

      final snackBar = SnackBar(
        content: Container(
          height: 250.0,
          child: Center(
            child: GestureDetector(
              onTap: () async {
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                await Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CameraDetailView(
                        itemNo: data['itemNo'],
                      ),
                    ));

              },
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Is this the right product?", style: TextStyle(fontSize: 20.0)),
                  Image.network(data['imgurl'], height: 200),
                ],
              ),
            ),
          ),
        ),
        duration: Duration(seconds: 3),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24.0)),
      );

      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoxWidget(result: e)).toList(),
    );
  }

  void resultsCallback(
      List<ResultObjectDetection> results, Duration inferenceTime) {
    if (!mounted) {
      return;
    }
    if (results.isEmpty || results.every((result) => result.score <= 0.75)) {
      _count++;
      if (_count >= _maxFailures) {
        _evaluateDetectionFailure();
      }
    } else {
      _resetDetection();
    }
    setState(() {
      this.results = results;
      objectDetectionInferenceTime = inferenceTime;
      for (var element in results) {
        print({
          "rect": {
            "left": element.rect.left,
            "top": element.rect.top,
            "width": element.rect.width,
            "height": element.rect.height,
            "right": element.rect.right,
            "bottom": element.rect.bottom,
          },
        });
      }
    });
    showSnackBar(context, results);
  }

  void resultsCallbackClassification(
      String classification, Duration inferenceTime) {
    if (!mounted) {
      return;
    }
    setState(() {
      this.classification = classification;
      classificationInferenceTime = inferenceTime;
    });
  }
}
