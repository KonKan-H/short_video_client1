import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/VideoPage/video_list.dart';
import 'package:short_video_client1/resources/strings.dart';

class MyVideoList extends StatefulWidget {
  MyVideoList({Key key, this.userId, this.couldDelete}) : super(key: key);
  final userId;
  bool couldDelete;
  @override
  _MyVideoListState createState() {
    return _MyVideoListState(userId: userId, couldDelete: couldDelete);
  }
}

class _MyVideoListState extends State<MyVideoList> {
  _MyVideoListState({Key key, this.userId, this.couldDelete});
  var userId;
  bool couldDelete;

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
            child: VideoList(userId: userId, couldDelete: couldDelete),
          )
      ),
    );
  }
}