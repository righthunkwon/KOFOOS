import 'package:flutter/material.dart';
import '../../common/device_controller.dart';
import 'api/register_api.dart';
import 'func/get_device_id.dart';
import 'package:get/get.dart';

class StartApp extends StatelessWidget {
  const StartApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KOFOOS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const SplashScreen(),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

// SplashScreen의 코드와 나머지 부분은 여기에...
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      // 로고 이미지가 2초간 표시된 후 동의 팝업을 표시합니다.
      getDeviceId().then((deviceId) {
        // DeviceController 인스턴스를 얻고 deviceId를 설정
        final deviceController = Get.find<DeviceController>();
        deviceController.setDeviceId(deviceId);

        checkUserRegistration(context,deviceId);
      });
    });
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child:
        Image.asset('assets/logo/main_logo.png'), // 로고 이미지 파일명을 정확히 지정해야 합니다.
      ),
    );
  }
}
