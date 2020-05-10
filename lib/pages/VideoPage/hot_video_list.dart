import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/video_player.dart';
import 'package:short_video_client1/resources/common/bgWedget.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';

class HotVideoList extends StatefulWidget {
  HotVideoList({Key key}):super(key: key);

  @override
  State<StatefulWidget> createState() {
    return new GridViewState();
  }
}

class GridViewState extends State {
  List<Video> videoList = List();
  int currentPage = 1;
  var userId;
  @override
  void initState() {
    _getUserInfo();
    _getHotVideoList();
    super.initState();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      if(event != null) {
        if(mounted) {
          setState(() {
            userId = event.userId;
          });
        }
      }
    });
  }

  _getUserInfo() {
    UserInfoUtil.getUserInfo().then((userInfo) {
      if(userInfo != null && userInfo.userId != null) {
        if(mounted) {
          setState(() {
            userId = userInfo.userId;
          });
        }
      }
    });
  }

  _getHotVideoList() {
    Map<String, dynamic> map = {
    "currentPage" : currentPage
  };
    DioRequest.dioPost(URL.HOT_VIDEO, map).then((result) {
      List<Video> l = List();
      print(result.data);
      Video video;
      List<dynamic> data;
      try {
        data = result.data['list'];
        for(Map<String, dynamic> map in data) {
          video = Video.formJson(map);
          l.add(video);
        }
      } on Error catch(e) {
        TsUtils.showShort("没有更多数据");
        TsUtils.logInfo("返回数据为空，已为最后一页");
      }
      if(mounted) {
        setState(() {
          videoList = l;
        });
      }
    });
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _getHotVideoList();
    currentPage = 1;
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    Map<String, dynamic> data = {
      "currentPage": ++currentPage,
    };
    DioRequest.dioPost(URL.GET_VIDEO_LIST, data).then((result) {
      List<Video> l = List();
      print(result.data);
      Video video;
      List<dynamic> data;
      try {
        data = result.data['list'];
        for(Map<String, dynamic> map in data) {
          video = Video.formJson(map);
          l.add(video);
        }
      } on Error catch(e) {
        TsUtils.logInfo("返回数据为空，已为最后一页");
      }
      if(mounted) {
        setState(() {
          videoList.addAll(l);
        });
      }
    });
    _refreshController.loadComplete();
  }

  @override
  Widget build(BuildContext context) {
    Widget layout;
    layout = (videoList == null || videoList.length == 0) ?
//    Center(
//      child: Text('没有数据',),
//    )
    bgWidget('没有数据')
        : SmartRefresher(
      enablePullUp: true,
      enablePullDown: true,
      header: WaterDropMaterialHeader(
        backgroundColor: ConstantData.MAIN_COLOR,
      ),
      controller: _refreshController,
      onRefresh: _onRefresh,
      onLoading: _onLoading,
      child: GridView(
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
//          mainAxisSpacing: 8.0,
            childAspectRatio: 0.5
        ),
        padding: const EdgeInsets.all(4.0),
        children: buildGridTileList(videoList),
      ),
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
        child: new Column(
          children: <Widget>[
            //封面
            new Container(
              height: ConstantData.VIDEO_HEIGHT,
              color: Colors.white70,
              alignment: Alignment.topCenter,
              child: Stack(
                children: <Widget>[
                  Container(
                    color: Colors.black,
                    alignment: Alignment.center,
                    child: Image.network(ConstantData.COVER_FILE_URI + video.cover, fit: BoxFit.cover,),
                  ),
                  InkWell(
                    onTap: () {
                      if(userId != null) {
                        video.looker = userId;
                      } else {
                        UserInfoUtil.getUserInfo().then((userInfo) {
                          if (userInfo != null && userInfo.userName != null) {
                            setState(() {
                              video.looker = userInfo.userId;
                            });
                          }
                        });
                      }
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
              alignment: Alignment.bottomCenter,
              height: 45,
              child: Stack(
                children: <Widget>[
                  new Container(
                    padding: EdgeInsets.fromLTRB(5, 3, 0, 3),
                    child: new Container(
                      width: 40,
                      height: 40,
                      child: new CircleAvatar(
                        backgroundImage: NetworkImage(ConstantData.AVATAR_FILE_URI + video.authorAvatar),
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
            ),
          ],
        ),
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


