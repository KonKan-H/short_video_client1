import 'package:flutter/material.dart';
import 'dart:math';

import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoList/video_player.dart';


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

class MyVideoList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => new GridViewState();
}

class GridViewState extends State {
  @override
  Widget build(BuildContext context) =>
    new GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
        childAspectRatio: 0.7
      ),
      padding: const EdgeInsets.all(8.0),
      children: buildGridTileList(50),
    );
//      new GridView.count(
//        primary: false,
//        padding: const EdgeInsets.all(8.0),
//        mainAxisSpacing: 8.0,//竖向间距
//        crossAxisCount: 2,//横向Item的个数
//        crossAxisSpacing: 8.0,//横向间距
//        children: buildGridTileList(50)
//      );

  List<Widget> buildGridTileList(int number) {
    List<Widget> widgetList = new List();
    for (int i = 0; i < number; i++) {
      widgetList.add(getItemWidget());
    }
    return widgetList;
  }

  //String url = "http://img5.mtime.cn/CMS/News/2020/02/03/125338.16865277_620X620.jpg";



  Widget getItemWidget() {
    String url = getPhotoUrl();
    return Container(
//      color: Colors.black,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(3),///圆角
          border: Border.all(color: Colors.grey,width: 1)///边框颜色、宽
      ),
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Image.network(url, fit: BoxFit.cover),
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
                      builder: (context) => new VideoScreen(video: Video(Random().nextInt(10000000), url))
                    ));
                  },
                ),
              ],
            ),
          ),
          new Container(
            alignment: Alignment.bottomLeft,
            child: new Container(
              width: 40,
              height: 40,
              child: new CircleAvatar(
                backgroundImage: new NetworkImage("https://profile.csdnimg.cn/5/C/E/3_ww897532167"),
                radius: 100,
              ),
            ),
          )
        ],
      ),
    );
    //BoxFit 可设置展示图片时 的填充方式
//    return new Image(image: new NetworkImage(url), fit: BoxFit.cover);
//    return Stack(
//      children: <Widget>[
//        new Container(
//          child: Image.network(url, fit: BoxFit.contain,),
//          decoration: BoxDecoration(
//
//          ),
//        ),
//        new Container(
//            width: 50,
//            height: 50,
//            child: new CircleAvatar(
//              backgroundImage: new NetworkImage("https://profile.csdnimg.cn/5/C/E/3_ww897532167"),
//              radius: 100,
//            ),
//        )
//      ],
////      child: Container(
////        color: Colors.black,
////        child: Image.network(url, fit: BoxFit.contain,),
//    );
  }

  String getPhotoUrl() {
    int id = Random().nextInt(999);
    String url = "https://i.picsum.photos/id/$id/200/300.jpg";
    print(url);
    return url;
  }

}



