import 'dart:io';
import 'package:flutter/material.dart';
import '../api/mypage_api.dart';

void usersDeleteFunc(BuildContext context, String deviceId) {
  final api = MyPageApi(); // MyPageApi 인스턴스 생성
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Delete account'),
        content: const Text('Are you sure you want to delete your account?'),
        actions: [
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black, // 버튼의 텍스트 색상
            ),
            onPressed: () {
              Navigator.of(context).pop(); // 창 닫기
            },
            child: const Text('Keep Account'),
          ),
          TextButton(
            style: TextButton.styleFrom(
              primary: Colors.black, // 버튼의 텍스트 색상
            ),
            onPressed: () async {
              try {
                await api.deleteUser(deviceId); // 회원 탈퇴 API 호출
                // 회원 탈퇴 성공 후 감사 메시지 표시
                Navigator.of(context).pop(); // 현재 대화 상자 닫기
                _showThankYouDialog(context); // 감사 메시지 대화 상자 표시
              } catch (e) {
                print('Error deleting account: $e');
                Navigator.of(context).pop(); // 에러 발생 시 대화 상자 닫기
              }
            },
            child: const Text('Yes, Delete'),
          ),
        ],
      );
    },
  );
}

//앱 종료 전 메시지
void _showThankYouDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Account Deleted'),
        content: const Text('Thank you for using us'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // 감사 메시지 대화 상자 닫기
              exit(0); // 앱 종료
            },
            child: const Text('OK'),
          ),
        ],
      );
    },
  );
}
