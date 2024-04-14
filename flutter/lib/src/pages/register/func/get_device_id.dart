import 'dart:io' show Platform;
import 'package:device_info/device_info.dart';

//디바이스 아이디 가져오기
Future<String> getDeviceId() async {
  DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
  print('디바이스아이디 가져와');
  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.androidId; // Unique ID for Android devices
  } else if (Platform.isIOS) {
    IosDeviceInfo iosInfo = await deviceInfo.iosInfo;
    return iosInfo.identifierForVendor; // Unique ID for iOS devices
  }
  return 'unknown';
}