import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:short_video_client1/pages/common/video_list.dart';
import 'package:short_video_client1/resources/strings.dart';


class VideoList extends StatelessWidget {
  VideoList({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("Video List"),
          backgroundColor: ConstantData.MAIN_COLOR, //设置appbar背景颜色
          centerTitle: true, //设置标题是否局中
        ),
        body: new Center(
          child: Container(
            child: VideoListPage(userId: null),
          )
        ),
      );
  }
}