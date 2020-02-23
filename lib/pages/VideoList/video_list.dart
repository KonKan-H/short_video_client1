import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/common/video_list.dart';


class VideoList extends StatelessWidget {
  VideoList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: new Text("视频列表"),
          backgroundColor: Color.fromARGB(255, 119, 136, 213), //设置appbar背景颜色
          centerTitle: true, //设置标题是否局中
        ),
        body: new Center(
          child: Container(
            child: MyVideoList(),
          )
        ),
      ),
    );
  }
}




