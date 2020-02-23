import 'package:flutter/material.dart';

import 'login_page.dart';

class UserInfo extends StatelessWidget {
  UserInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("用户页面"),
          backgroundColor: Color.fromARGB(255, 119, 136, 213), //设置appbar背景颜色
          centerTitle: true, //设置标题是否局中
        ),
        body: Center(
          child: LoginPage(),
        ),
      ),
    );
  }
}
