import 'dart:math';
import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoList/video_player.dart';

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
                Image.network(url, fit: BoxFit.cover,),
                // TODO: 取消按钮更改
                RaisedButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(
//                      builder: (context) => VideoScreen(video: Video(Random().nextInt(10000000), 'https://www.runoob.com/try/demo_source/mov_bbb.mp4', "作者"))
                        builder: (context) => VideoPlayerPage(video: Video(Random().nextInt(10000000), 'https://aweme.snssdk.com/aweme/v1/playwm/?s_vid=93f1b41336a8b7a442dbf1c29c6bbc560f641c6c47b7bd3078f5dfd249c38b4b04f03514ce6bab0456860d6cf65253383eeb760ecc50fb8dc6461e5fa7b82702&line=0', "作者"))
                    ));
                  },
                ),
              ],
            ),
          ),

          new Container(
            key: Key('头像'),
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
