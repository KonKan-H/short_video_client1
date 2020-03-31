import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/video_player.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';

class MyVideoList extends StatefulWidget {
  MyVideoList({Key key, @required this.userId}):super(key: key);
  var userId;

  @override
  State<StatefulWidget> createState() {
    return new GridViewState(userId: userId);
  }
}

class GridViewState extends State {
  GridViewState({Key key, this.userId});
  var userId;
  List<Video> videoList = List();

  @override
  Widget build(BuildContext context) {
    if(userId == null ) {
      UserInfoUntil.getUserInfo().then((userInfo) {
        if (userInfo != null && userInfo.userName != null) {
          userId = userInfo.userId;
        }
      });
    }
    Map<String, dynamic> data = {
      "userId" : userId
    };
    DioRequest.dioPost(URL.GET_VIDEO_LIST, data).then((result) {
      List<Video> l = List();
      print(result.data);
      Video video;
      for(Map<String, dynamic> map in result.data) {
        video = Video.formJson(map);
        l.add(video);
      }
//      setState(() {
//        l;
//      });
      videoList = l;
    });
    Widget layout;

    layout = (videoList == null || videoList.length == 0) ? Center(
      child: CircularProgressIndicator(),
    ): GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8.0,
          crossAxisSpacing: 8.0,
          childAspectRatio: 0.7
      ),
      padding: const EdgeInsets.all(8.0),
      children: buildGridTileList(videoList),
    );
    return layout;
  }

  List<Widget> buildGridTileList(List<Video> videoList) {
    List<Widget> widgetList = new List();
    int num = videoList.length != null? videoList.length : 0;
    for (int i = 0; i < num; i++) {
      widgetList.add(getItemWidget(videoList[i]));
    }
    return widgetList;
  }

  Widget getItemWidget(Video video) {
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
                Image.network(video.cover, fit: BoxFit.cover,),
                InkWell(
                  onTap: () {
                    video.looker = userId;
                    Navigator.push(context, MaterialPageRoute(
//                  Navigator.of(parentContext).push(MaterialPageRoute(
//                      builder: (context) => VideoScreen(video: Video(Random().nextInt(10000000), 'https://www.runoob.com/try/demo_source/mov_bbb.mp4', "作者"))
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
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Container(
                    width: 30,
                    height: 40,
                    alignment: Alignment.centerLeft,
                    child:  Icon(Icons.favorite, size: 30, color: Colors.red,),
                  ),
                  new Container(
                    width: 60,
                    height: 40,
                    alignment: Alignment.centerRight,
                    child: Center(
                      child: Text(TsUtils.dataDeal(video.likes), style: TextStyle(color: Colors.white),),
                    )
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

//  String getPhotoUrl() {
//    int id = Random().nextInt(999);
//    String url = "https://i.picsum.photos/id/$id/200/300.jpg";
//    print(url);
//    return url;
//  }
}
