import 'package:flutter/material.dart';
import 'package:kofoos/src/root/root.dart';

import '../pages/home/home.dart';

class MyAppBar extends StatelessWidget implements PreferredSizeWidget {
  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      leadingWidth: 120.0,
      leading: Builder(
        builder: (BuildContext context) {
          return InkWell(
            onTap: () {
              print('홈페이지 이동 기능 추가');
            },
            child: Container(
              margin: EdgeInsets.only(left: 15.0),
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/logo/header_logo.png'),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
