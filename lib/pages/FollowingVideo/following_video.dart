import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/video_player.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';

class FollowingVideo extends StatefulWidget {
  FollowingVideo({Key key}) : super(key: key);

  @override
  _FollowingVideoState createState() {
    return _FollowingVideoState();
  }
}

class _FollowingVideoState extends State<FollowingVideo> {
  List<Video> videoList = List();
  var userId;
  int currentPage = 1;

  @override
  void initState() {
    super.initState();
    _getUserInfo();
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
    UserInfoUntil.getUserInfo().then((userInfo) {
      if(userInfo != null && userInfo.userId != null) {
        if(mounted) {
          setState(() {
            userId = userInfo.userId;
            _getVideoList();
          });
        }
      }
    });
  }

  RefreshController _refreshController = RefreshController(initialRefresh: false);
  void _onRefresh() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use refreshFailed()
    _getVideoList();
    currentPage = 1;
    _refreshController.refreshCompleted();
  }

  _getVideoList() {
    if(userId != null) {
      Map<String, dynamic> data = {
        "userId" : userId
      };
      DioRequest.dioPost(URL.MY_FOLLOWING_VIDEO_LIST, data).then((result) {
        List<Video> l = List();
        print(result.data);
        Video video;
        List<dynamic> data = result.data['list'];
        for(Map<String, dynamic> map in data) {
          video = Video.formJson(map);
          l.add(video);
        }
        if(mounted) {
          setState(() {
            videoList = l;
          });
        }
      });
    }
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    Map<String, dynamic> data = {
      "userId" : userId.toString(),
      "currentPage": ++currentPage,
    };
    DioRequest.dioPost(URL.MY_FOLLOWING_VIDEO_LIST, data).then((result) {
      List<Video> l = List();
      print(result.data);
      Video video;
      List<dynamic> data = result.data['list'];
      for(Map<String, dynamic> map in data) {
        video = Video.formJson(map);
        l.add(video);
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
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget widget;
    if (videoList == null || videoList.length == 0) {
      widget = Center(
        child: Text("关注用户没有发布视频",),
      );
    } else {
      widget = SmartRefresher(
        enablePullUp: !(userId == null),
        enablePullDown: true,
        header: WaterDropMaterialHeader(
          backgroundColor: ConstantData.MAIN_COLOR,
        ),
        footer: CustomFooter(
          builder: (BuildContext context,LoadStatus mode){
            Widget body ;
            if(mode==LoadStatus.idle){
              body =  Text("pull up load");
            }
            else if(mode==LoadStatus.loading){
              body =  CupertinoActivityIndicator();
            }
            else if(mode == LoadStatus.failed){
              body = Text("Load Failed!Click retry!");
            }
            else if(mode == LoadStatus.canLoading){
              body = Text("release to load more");
            }
            else{
              body = Text("No more Data");
            }
            return Container(
              height: 55.0,
              child: Center(child:body),
            );
          },
        ),
        controller: _refreshController,
        onRefresh: _onRefresh,
        onLoading: _onLoading,
        child: buildVideoList(),
      );
    }
    if(userId == null ) {
      widget = Center(
        child: Text('请先登录'),
      );
    }
    return Scaffold(
      appBar: new AppBar(
        title: new Text("My Following"),
        backgroundColor: ConstantData.MAIN_COLOR, //设置appbar背景颜色
        centerTitle: true, //设置标题是否局中
      ),
      body: new Center(
          child: Container(
            child: widget,
          )
      ),
    );
  }

  Widget buildVideoList() {
    Widget layout;
    layout = (videoList == null || videoList.length == 0) ? Center(
      child: CircularProgressIndicator(),
    ): GridView(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
//          mainAxisSpacing: 8.0,
          childAspectRatio: 0.5
      ),
      padding: const EdgeInsets.all(4.0),
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