import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/UserInfo/my_info.dart';
import 'package:short_video_client1/resources/strings.dart';

class MyInfoHomePage extends StatelessWidget {
  MyInfoHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("User Info"),
          backgroundColor: ConstantData.MAIN_COLOR, //设置appbar背景颜色
          centerTitle: true, //设置标题是否局中
        ),
        body: MyInfoPage(),
    );
  }
}
