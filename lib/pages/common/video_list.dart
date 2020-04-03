import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/video_player.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';

class VideoListPage extends StatefulWidget {
  VideoListPage({Key key, @required this.userId, this.couldDelete}):super(key: key);
  var userId;
  bool couldDelete;

  @override
  State<StatefulWidget> createState() {
    return new GridViewState(userId: userId, isMyself: couldDelete);
  }
}

class GridViewState extends State {
  GridViewState({Key key, this.userId, this.isMyself});
  var userId;
  bool isMyself, isDelete = false;
  List<Video> videoList = List();

  @override
  Widget build(BuildContext context) {
    //id为空 查找所有视频
    if(userId == null ) {
      UserInfoUntil.getUserInfo().then((userInfo) {
        if (userInfo != null && userInfo.userName != null) {
          userId = userInfo.userId;
        }
      });
    }
    //id不为空 查找id用户的视频
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
      setState(() {
        l;
      });
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
    return Container(
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
                  onLongPress: () {
                    if(isMyself) {
                      showCupertinoAlertDialog(video);
                      setState(() {
                        if(isDelete) {
                          videoList.remove(video);
                          setState(() {
                            videoList;
                            isDelete = true;
                          });
                        }
                      });
                    }
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

  showCupertinoAlertDialog(Video video) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("是否删除该视频"),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text(video.description == null ? "" : video.description.toString(), maxLines: 1,
                    overflow: TextOverflow.ellipsis,),
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              CupertinoDialogAction(
                child: Text("确定"),
                onPressed: () {
                  DioRequest.dioPost(URL.VIDEO_DELETE, Video.model2map(video)).then((result) {
                    bool flag = result.data as bool;
                    if(flag) {
                      setState(() {
                        isDelete = flag;
                      });
                    }
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          );
        });
  }

//  String getPhotoUrl() {
//    int id = Random().nextInt(999);
//    String url = "https://i.picsum.photos/id/$id/200/300.jpg";
//    print(url);
//    return url;
//  }
}


