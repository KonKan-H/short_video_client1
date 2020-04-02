import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/common/video_list.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';

class MyVideoList extends StatefulWidget {
  MyVideoList({Key key, this.userId, this.isMyself}) : super(key: key);
  final userId;
  bool isMyself;
  @override
  _MyVideoListState createState() {
    return _MyVideoListState(userId: userId, isMyself: isMyself);
  }
}

class _MyVideoListState extends State<MyVideoList> {
  _MyVideoListState({Key key, this.userId, this.isMyself});
  var userId;
  bool isMyself;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: new AppBar(
        title: new Text("我的视频"),
        backgroundColor: ConstantData.MAIN_COLOR, //设置appbar背景颜色
        centerTitle: true, //设置标题是否局中
      ),
      body: new Center(
          child: Container(
            child: VideoListPage(userId: userId, isMyself: isMyself),
          )
      ),
    );
  }
}