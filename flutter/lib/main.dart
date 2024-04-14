import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kofoos/src/common/device_controller.dart';
import 'package:kofoos/src/pages/camera/camera.dart';
import 'package:kofoos/src/pages/register/register.dart';
import 'package:kofoos/src/root/root_controller.dart';
import 'package:shake/shake.dart';

void main() {
  runApp(const MyApp());
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  ShakeDetector? detector;

  void initState() {
    super.initState();
    detector = ShakeDetector.autoStart(
      onPhoneShake: (){
        navigatorKey.currentState?.push(MaterialPageRoute(builder: (_) => Camera()));
      },
      minimumShakeCount: 2,
      shakeSlopTimeMS: 500,
      shakeCountResetTime: 3000,
      shakeThresholdGravity: 2.7,
    );
  }

  void _navigateToCamera() {
    if(mounted){
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => Camera()),
      );
    }
  }

  @override
  void dispose() {
    detector?.stopListening();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'KOFOOS',
      initialBinding: BindingsBuilder(() {
        Get.put(DeviceController());
        Get.put(RootController());
      }),
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),

      home: StartApp(), //Root(), StartApp()으로 변경하여 앱 시작점을 변경할 수 있습니다.

    );
  }
}
