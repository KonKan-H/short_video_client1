import 'dart:math';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/video_player.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/tools.dart';

class MyVideoList extends StatefulWidget {
  MyVideoList({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() => new GridViewState();
}

class GridViewState extends State {
  var videoList = List();
  _getInitVideoList() async {
    Result result = await DioRequest.dioGet(URL.GET_VIDEO_LIST);
    print(result.data);
    TsUtils.showShort(result.msg);
    Video video;
    for(Map<String, dynamic> map in result.data) {
        video = Video.formJson(map);
        videoList.add(video);
    }
  }

  @override
  Widget build(BuildContext context) {
    _getInitVideoList();
    new GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.7
      ),
      padding: const EdgeInsets.all(8.0),
      children: buildGridTileList(),
    );
  }

  List<Widget> buildGridTileList() {
    List<Widget> widgetList = new List();
    int num = videoList.length != null? videoList.length : 0;
    print('===============');
    print(videoList.length);
    for (int i = 0; i < num; i++) {
      widgetList.add(getItemWidget(videoList[i]));
    }
    videoList = null;
    return widgetList;
  }

  //String url = "http://img5.mtime.cn/CMS/News/2020/02/03/125338.16865277_620X620.jpg";

  Widget getItemWidget(Video video) {
    String url = getPhotoUrl();
    return Container(
//      decoration: BoxDecoration(
//          borderRadius: BorderRadius.circular(3),///圆角
//          border: Border.all(color: Colors.grey,width: 1)///边框颜色、宽
//      ),
      child: new Stack(
        children: <Widget>[
          new Container(
            alignment: Alignment.center,
            child: Stack(
              children: <Widget>[
                Image.network(url, fit: BoxFit.cover,),
                // TODO:
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(
//                  Navigator.of(parentContext).push(MaterialPageRoute(
//                      builder: (context) => VideoScreen(video: Video(Random().nextInt(10000000), 'https://www.runoob.com/try/demo_source/mov_bbb.mp4', "作者"))
//                        builder: (context) => VideoPlayerPage(video: Video(Random().nextInt(10000000), 'https://aweme.snssdk.com/aweme/v1/playwm/?s_vid=93f1b41336a8b7a442dbf1c29c6bbc560f641c6c47b7bd3078f5dfd249c38b4b04f03514ce6bab0456860d6cf65253383eeb760ecc50fb8dc6461e5fa7b82702&line=0', "作者"))
                        builder: (context) => VideoPlayerPage(video: video)
                    ));
                  },
                ),
              ],
            ),
          ),
          //头像
          new Container(
            alignment: Alignment.bottomLeft,
            child: new Container(
              width: 40,
              height: 40,
              child: new CircleAvatar(
                backgroundImage: new NetworkImage(video.authorAvatar),
                radius: 100,
              ),
            ),
          ),
          new Container(
            alignment: Alignment.bottomRight,
            child: new Container(
              width: 120,
              height: 40,
              alignment: Alignment.center,
              child: Stack(
                children: <Widget>[
                  new Container(
                    width: 60,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child:  Icon(Icons.favorite, size: 30, color: Colors.red,),
                  ),
                  new Container(
                    width: 60,
                    height: 40,
                    alignment: Alignment.centerRight,
                    //todo 点赞 变量
                    child: Text(video.likes, style: TextStyle(color: Colors.white),),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String getPhotoUrl() {
    int id = Random().nextInt(999);
    String url = "https://i.picsum.photos/id/$id/200/300.jpg";
    print(url);
    return url;
  }

}
