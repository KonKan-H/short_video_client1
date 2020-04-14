import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/video_player.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';

class MyFavoriteVideo extends StatefulWidget {
  MyFavoriteVideo({Key key, this.userId}) : super(key: key);
  final userId;

  @override
  _MyFavoriteVideoState createState() {
    return _MyFavoriteVideoState();
  }
}

class _MyFavoriteVideoState extends State<MyFavoriteVideo> {
  List<Video> videoList = List();
  var userId;

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
    userId = widget.userId;
    Map<String, dynamic> data = {
      "userId" : userId
    };
    DioRequest.dioPost(URL.MY_FAVORITE_VIDEO_LIST, data).then((result) {
      List<Video> l = List();
      print(result.data);
      Video video;
      for(Map<String, dynamic> map in result.data) {
        video = Video.formJson(map);
        l.add(video);
      }
      if(mounted) {
        setState(() {
          videoList = l;
        });
      }
    });
    return  Scaffold(
      appBar: new AppBar(
        title: new Text("My Likes"),
        backgroundColor: ConstantData.MAIN_COLOR, //设置appbar背景颜色
        centerTitle: true, //设置标题是否局中
      ),
      body: new Center(
          child: Container(
            child: buildVideoList(),
          )
      ),
    );
  }

  Widget buildVideoList() {
    Widget layout;
    layout = (videoList == null || videoList.length == 0) ? Center(
      child: Text("没有数据"),
    ): GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
//          mainAxisSpacing: 8.0,
          childAspectRatio: 0.5
      ),
      padding: const EdgeInsets.all(8.0),
      children: buildGridTileList(videoList),
    );
    setState(() {
      layout;
    });
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
    return Card(
      child: Container(
        child: new Stack(
          children: <Widget>[
            new Container(
              height: ConstantData.VIDEO_HEIGHT,
              color: Colors.white70,
              alignment: Alignment.topCenter,
              child: Stack(
                children: <Widget>[
                  Container(
                    alignment: Alignment.center,
                    child: Image.network(ConstantData.COVER_FILE_URI + video.cover, fit: BoxFit.cover,),
                  ),
                  InkWell(
                    onTap: () {
                      video.looker = userId;
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => VideoPlayerPage(video: video)
                      ));
                    },
                  ),
                ],
              ),
            ),
            //头像
           Container(
             child: Stack(
               children: <Widget>[
                 new Container(
                   alignment: Alignment.bottomLeft,
                   padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
                   child: new Container(
                     width: 40,
                     height: 40,
                     child: new CircleAvatar(
                       backgroundImage: new NetworkImage(ConstantData.AVATAR_FILE_URI + video.authorAvatar),
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
                           child:  Icon(Icons.favorite, size: 25, color: Colors.red,),
                         ),
                         new Container(
                             width: 60,
                             height: 40,
                             alignment: Alignment.centerRight,
                             child: Center(
                               child: Text(TsUtils.dataDeal(video.likes), style: TextStyle(color: Colors.grey, fontWeight: FontWeight.w700),),
                             )
                         ),
                       ],
                     ),
                   ),
                 ),
               ],
             ),
           )
          ],
        ),
      ),
    );
  }
}