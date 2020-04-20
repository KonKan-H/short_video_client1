import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/video_player.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';

class VideoList extends StatefulWidget {
  VideoList({Key key, @required this.userId, this.couldDelete}):super(key: key);
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
  bool isMyself, ifDelete = false;
  List<Video> videoList = List();
  int currentPage = 1;
  @override
  void initState() {
    //id为空 查找所有视频
//    if(userId == null ) {
//      UserInfoUntil.getUserInfo().then((userInfo) {
//        if (userInfo != null && userInfo.userName != null) {
//          userId = userInfo.userId;
//        }
//      });
//    }
    _getVideoList();
    super.initState();
  }

  _getVideoList() {
    //id不为空 查找id用户的视频
    Map<String, dynamic> data = {
      "userId" : userId
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
    _getVideoList();
    currentPage = 1;
    _refreshController.refreshCompleted();
  }

  void _onLoading() async{
    // monitor network fetch
    await Future.delayed(Duration(milliseconds: 1000));
    // if failed,use loadFailed(),if no data return,use LoadNodata()
    Map<String, dynamic> data = {
      "userId" : userId.toString(),
      "currentPage": ++currentPage,
    };
    DioRequest.dioPost(URL.GET_VIDEO_LIST, data).then((result) {
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
  Widget build(BuildContext context) {
    Widget layout;
    layout = (videoList == null || videoList.length == 0) ?
//    Center(
//      child: Text('没有数据',),
//    )
    CircularProgressIndicator()
        : SmartRefresher(
      enablePullUp: true,
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
        child: new Stack(
          children: <Widget>[
            //封面
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
                      if(userId != null) {
                        video.looker = userId;
                      } else {
                        UserInfoUntil.getUserInfo().then((userInfo) {
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
                    onLongPress: () {
                      if(isMyself) {
                        showCupertinoAlertDialog(video);
                      }
                    },
                  ),
                ],
              ),
            ),
            //头像
            Container(
              alignment: Alignment.bottomCenter,
              child: Stack(
                children: <Widget>[
                  new Container(
                    alignment: Alignment.bottomLeft,
                    padding: EdgeInsets.fromLTRB(5, 0, 0, 5),
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
                      videoList.remove(video);
                      setState(() {
                        videoList;
                      });
                      ifDelete = false;
                      TsUtils.showShort("删除成功");
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


