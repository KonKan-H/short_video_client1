import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Attention.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/video_player.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key, @required this.authorId, @required this.looker}) : super(key: key);
  final authorId;
  final looker;

  @override
  _UserInfoPageState createState() {
    return _UserInfoPageState(authorId: authorId, looker: looker);
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  _UserInfoPageState({Key key, @required this.authorId, @required this.looker});
  //当页用户id
  var authorId;
  var looker;
  //当页用户信息
  UserInfo userInfo;
  bool isMyself = false, isAttention = false;
  List<Video> videoList = new List();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  //取得当页用户信息
  _getUserInfo() async {
    Map<String, dynamic> data = {
      "userId" : authorId
    };
    Result result = await DioRequest.dioPost(URL.GET_USER_INFO, data);
    setState(() {
      result;
    });
    userInfo = await UserInfoUtil.map2UserInfo(result.data);
    isMyself = (authorId == looker);
    setState(() {
      userInfo;
      isMyself;
    });
    if(userInfo != null) {
      Attention attention = new Attention();
      attention.userId = authorId;
      attention.fansId = looker;
      Result r = await DioRequest.dioPost(URL.USER_ATTENTION_OR_NOT, Attention.model2map(attention));
      setState(() {
        isAttention = r.data as bool;
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //取得视频列表
//    if(authorId == null ) {
//      UserInfoUntil.getUserInfo().then((userInfo) {
//        if (userInfo != null && userInfo.userName != null) {
//          authorId = userInfo.userId;
//        }
//      });
//    }
    Map<String, dynamic> data = {
      "userId" : authorId
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
        TsUtils.showShort("没有更多数据");
        TsUtils.logInfo("返回数据为空，已为最后一页");
      }
      if(mounted) {
        setState(() {
          l;
        });
      }
      videoList = l;
    });

    return Scaffold(
      appBar: AppBar(
        title: Text("User Video"),
        centerTitle: true,
        actions: <Widget>[
          Offstage(
            offstage: isMyself,
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: isAttention ? Icon(IconData(0xe6fe, fontFamily: 'MyIcon',), size: 30,) :
              Icon(IconData(0xe700, fontFamily: 'MyIcon',), size: 30,),
              onPressed: () async {
                Attention attention = new Attention();
                attention.userId = authorId;
                attention.fansId = looker;
                bool flag = await attentionUserYON(attention, isAttention);
                if(mounted) {
                  setState(() {
                    flag;
                  });
                }
                if(flag != null) {
                  if(flag) {
                    if(isAttention) {
                      TsUtils.showShort("取消关注");
                    } else {
                      TsUtils.showShort("关注成功");
                    }
                    setState(() {
                      isAttention = !isAttention;
                    });
                  }
                }
              },
            ),
          )
        ],
        backgroundColor: ConstantData.MAIN_COLOR,
      ),
      body: Center(
        child: CustomScrollView(reverse: false, shrinkWrap: false,slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            backgroundColor: ConstantData.MAIN_COLOR,
            expandedHeight: 200.0,
            iconTheme: IconThemeData(color: Colors.transparent),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (userInfo == null || userInfo.userAvatar == null) ?
                Image.asset('images/ic_avatar_default.png', width: 60.0, height: 60.0,)
                    : Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: NetworkImage(ConstantData.AVATAR_FILE_URI + userInfo.userAvatar),
                          fit:BoxFit.cover
                      ),
                      border: Border.all(color: Colors.white, width: 2.0)
                  ),
                ),
                Container(
                    margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                    alignment: Alignment.center,
                    child: Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Container(
                              child: (userInfo == null || userInfo.sex == null) ? Container(child: Icon(IconData(0xe605, fontFamily: 'MyIcon',)),) :
                              Icon(userInfo.sex == '女' ? IconData(0xe605, fontFamily: 'MyIcon',) : IconData(0xe606, fontFamily: 'MyIcon',),
                                size: 20, color: Colors.white,),
                            ),
                            Container(
                              child: userInfo == null? null : Text((userInfo.userName == null ? null : userInfo.userName) +
                                  '  ' + (userInfo.age == null ? null: userInfo.age.toString()),
                                style: TextStyle(color: Colors.white, fontSize: 16.0),),
                            ),
                          ],
                        )
                    )
                ),
                Container(
                    child: Offstage(
                      offstage: (userInfo == null || userInfo.userName == null) ? true : false,
                      child: userInfo == null ? null :
                      (userInfo.fans == null && userInfo.attentions == null) ? Text('粉丝：0  关注：0',
                        style: TextStyle(color: Colors.white, fontSize: 16.0),):
                      Text('粉丝：${userInfo.fans}  关注：${userInfo.attentions}', style: TextStyle(color: Colors.white, fontSize: 16.0),),
                    )
                ),
                Container(
                  child: (userInfo == null || userInfo.area == null) ? Container(child: null,) : Offstage(
                    offstage: userInfo.area == null ? true : false,
                    child:  Text(userInfo.area, style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  ),
                ),
                Container(
                  padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: (userInfo == null || userInfo.introduction == null) ? Container(child: null,) : Offstage(
                    offstage: userInfo.introduction == null ? true : false,
                    child:  Text(userInfo.introduction, style: TextStyle(color: Colors.white, fontSize: 16.0),
                      ),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: new SliverGrid( //Grid
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
//                  mainAxisSpacing: 8.0,
                  childAspectRatio: 0.5
              ),
              delegate: new SliverChildBuilderDelegate((BuildContext context, int index) {
                  Video video = videoList[index];
                //创建子widget
                  return new Container(
                    alignment: Alignment.center,
                    child: getItemWidget(video),
                  );
                },
                childCount: videoList.length,
              ),
            ),
          ),
          //List
        ],
        ),
      ),
    );
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
                      video.looker = authorId;
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

Future<bool> attentionUserYON(Attention attention, bool isAttention) async {
  Result result;
  bool flag = false;
  if(!isAttention) {
    //关注
    result = await DioRequest.dioPost(URL.ATTENTION_USER_INSERT, Attention.model2map(attention));
    flag = result.data as bool;
  } else {
    //取消关注
    result = await DioRequest.dioPost(URL.ATTENTION_USER_CANCEL, Attention.model2map(attention));
    flag = result.data as bool;
  }
  if(flag) {
    flag = true;
  }
  return flag;
}
