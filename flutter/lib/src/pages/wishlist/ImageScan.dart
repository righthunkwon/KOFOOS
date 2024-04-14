import 'package:flutter/material.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:pytorch_lite/pytorch_lite.dart';


class ImageScan  {
  ClassificationModel? _imageModel;
  //CustomModel? _customModel;
  ModelObjectDetection? _objectModelYoloV8;

  String? textToShow;
  List? _prediction;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];

  ImageScan();

  Future<void> initializeModel() async {
    String pathObjectDetectionModelYolov8 = "assets/ai/best.torchscript";
    try {
      _objectModelYoloV8 = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModelYolov8, 104, 640, 640,
          labelPath: "assets/ai/labels.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov8);
      print("모델 로드 성공");
    } catch (e) {
      print("모델 로드 실패: $e");
    }
  }

// 이미지 파일 리스트를 받아 각 이미지에 대한 객체 탐지를 실행하고 결과를 반환하는 메서드
  Future<List<ResultDto>> runObjectDetectionYoloV8(XFile image) async {
    //pick a random image
    List<ResultDto> results = [];

    Stopwatch stopwatch = Stopwatch()..start();

    objDetect = await _objectModelYoloV8!.getImagePrediction(
        await File(image!.path).readAsBytes(),
        minimumScore: 0.8,
        iOUThreshold: 0.6);
    textToShow = inferenceTimeAsString(stopwatch);

    print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');
    for (var element in objDetect) {
      print({
        "score": element?.score,
        "className": element?.className,
      });

      ResultDto resultDto = ResultDto( name: element?.className as String, score: element?.score as double);
      results.add(resultDto);
    }

    return results;

  }
  /* Future<List<String?>> runObjectDetectionYoloV8(List<File> images) async {
    if (_objectModelYoloV8 == null) {
      print("모델 초기화 실패");
      return [];
    }

    List<String?> results = [];
    for (File image in images) {
      print(image);
      print('진단 시작!');
      try {
        List<ResultObjectDetection> detectionResults = await _objectModelYoloV8!.getImagePrediction(
            await image.readAsBytes(),
            minimumScore: 0.3,
            iOUThreshold: 0.3);
        if (detectionResults.isNotEmpty) {
          double max = 0.75;
          ResultObjectDetection maxDetectionResult=detectionResults[0];

          for(ResultObjectDetection det in detectionResults){
            if(max <= det.score){

              max = det.score;
              maxDetectionResult=det;
            }
          }
          print("정확도 최대값: ");
          print(max);
          print(maxDetectionResult.className);
          results.add(maxDetectionResult.className as String);
          print('=====결과값이 있을 때 결과 개수: ${results.length}====');
        } else {
          // 비어 있는 결과인 경우 null 대신 빈 리스트를 추가하거나 결과를 추가하지 않음
          // results.add([]); // 빈 리스트를 추가하는 방법
          print('=====결과값이 없을 때 결과 개수: ${results.length}====');
        }
        print('=====if문 나와서 결과 개수: ${results.length}====');
        print(detectionResults);
      } catch (e) {
        print("Object detection failed for image: ${image.path}, Error: $e");
        // 실패한 경우 null 대신 빈 리스트를 추가하거나 결과를 추가하지 않음
        // results.add([]); // 빈 리스트를 추가하는 방법
        print('===== catch문 결과 개수: ${results.length}====');
      }
    }

    return results;
  }
*/
  String inferenceTimeAsString(Stopwatch stopwatch) =>
      "Inference Took ${stopwatch.elapsed.inMilliseconds} ms";

  Future runClassification() async {
    objDetect = [];
    //pick a random image
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    //get prediction
    //labels are 1000 random english words for show purposes
    print(image!.path);
    Stopwatch stopwatch = Stopwatch()..start();

    textToShow = await _imageModel!
        .getImagePrediction(await File(image.path).readAsBytes());
    textToShow = "${textToShow ?? ""}, ${inferenceTimeAsString(stopwatch)}";

    List<double?>? predictionList = await _imageModel!.getImagePredictionList(
      await File(image.path).readAsBytes(),
    );

    print(predictionList);

  }

}

class ResultDto {
  late String name;
  late double score;

  ResultDto({required this.name, required this.score});

}
