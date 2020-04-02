import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/common/video_list.dart';
import 'package:short_video_client1/resources/strings.dart';

class FollowingVideo extends StatelessWidget {
  FollowingVideo({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: new AppBar(
          title: new Text("关注视频"),
          backgroundColor: ConstantData.MAIN_COLOR, //设置appbar背景颜色
          centerTitle: true, //设置标题是否局中
        ),
        body: new Center(
          child: VideoListPage(userId: null,),
        ),
    );
  }
}
