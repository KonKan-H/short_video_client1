import 'package:flutter/material.dart';
import 'package:short_video_client1/resources/strings.dart';

import 'login_page.dart';

class UserInfo extends StatelessWidget {
  UserInfo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("用户页面"),
          backgroundColor: ConstantData.MAIN_COLOR, //设置appbar背景颜色
          centerTitle: true, //设置标题是否局中
        ),
        body: Center(
          child: LoginPage(),
        ),
    );
  }
}
