import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/pages/VideoPage/layout/BottomSheet.dart';
import 'package:short_video_client1/pages/VideoPage/layout/video_layout.dart';
import 'package:short_video_client1/pages/VideoPage/likebutton/like_button.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:video_player/video_player.dart';
import 'package:short_video_client1/models/Video.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key key, @required this.video}): super(key: key);
  final Video video;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState(
      video: video);
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  _VideoPlayerPageState({Key key, @required this.video});
  final Video video;
  var userId, id, userName, userAvatar, sex, area, introduction, age, mobilePhone;
  bool isLiked = false;
  UserInfo userInfo;

  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController = VideoPlayerController.network(video.url)
      ..initialize().then((_) {
        //确保在视频初始化后显示第一帧，甚至在按下播放按钮之前。
        setState(() {
          _videoPlayerController.setLooping(true);
        });
      });
    _getUserInfo();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      OsApplication.eventBus.on<LoginEvent>().listen((event) {
        if(event != null) {
          userName = event.userName;
          userAvatar = event.userAvatar;
          age = event.age.toString();
          area = event.area;
          sex = event.sex;
          userAvatar = event.userAvatar;
          userId = event.userId;
        } else {
          userName = null;
        }
      });
    });

  }

  _getUserInfo() {
    UserInfoUntil.getUserInfo().then((userInfo) {
      if(userInfo != null && userInfo.userName != null) {
        setState(() {
          id = userInfo.id;
          userName = userInfo.userName;
          userAvatar = userInfo.userAvatar;
          age = userInfo.age;
          area = userInfo.area;
          sex = userInfo.sex;
          userAvatar = userInfo.userAvatar;
          userId = userInfo.userId;
          mobilePhone = userInfo.mobilePhone;
          introduction = userInfo.introduction;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //取得屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double rpx = MediaQuery.of(context).size.width / 750;

    return Stack(
      children: <Widget>[
        Scaffold(
          appBar: AppBar(
              title: Text(video.authorName.toString()),
          ),
          body: Container(
            alignment: Alignment.center,
            decoration: BoxDecoration(color: Colors.black),
            child: _videoPlayerController.value.initialized
              ? Container(
                child: AspectRatio(
                  aspectRatio: _videoPlayerController.value.aspectRatio,
                  child: VideoPlayer(_videoPlayerController),
                ),
              )
                  : Center(
              child: CircularProgressIndicator(),
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              setState(() {
              _videoPlayerController.value.isPlaying
                ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
                });
             // print(_videoPlayerController.value);
            },
            child: Icon(_videoPlayerController.value.isPlaying
            ? Icons.pause
                : Icons.play_arrow),
          ),
        ),
        Positioned(
          right: 0,
          width: 0.20 * screenWidth,
          height: 0.5 * screenHeight,
          top: 0.28 * screenHeight,
          child:
            Container(
  //            decoration: BoxDecoration(color: Colors.orange),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Container(
                    width: 60,
                    height: 70,
                    child: Stack(children: <Widget>[
                      Container(
                        width: 60,
                        height: 60,
                        //alignment: Alignment.bottomCenter,
                        child: CircleAvatar(backgroundImage: NetworkImage(video.authorAvatar),),
                      ),
                      Positioned(
                        bottom: 0,
                        left: 17.5,
                        child: Container(
                          width: 25,
                          height: 25,
                          decoration: BoxDecoration(
                              color: Colors.redAccent,
                              borderRadius: BorderRadius.circular(25)
                          ),
                          child: Icon(Icons.add, size: 20, color: Colors.white,),),)
                    ],),
                  ),
                  //IconText(text: "999w", icon: Icon(Icons.favorite, size: 40, color: Colors.redAccent,),),
                  //点赞爱心
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Container(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: <Widget>[
                              LikeButton(
                                width: 72.0,
                                duration: Duration(seconds: 2),
                                circleStartColor: Color(0xffffff),
                                looker: userId,
                                video: video,
                                //onIconClicked: likeButton(isLiked),
                                //circleStartColor: Colors.white,
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          child: Text((video.likes == 0 || video.likes == null) ? '点赞': video.likes.toString(), style: TextStyle(color: Colors.white,fontSize: 13.0, decoration: TextDecoration.none), ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: RaisedButton(
                      child: Text('评论', style: TextStyle(color: Colors.white),),
                      color: Colors.black,
                      onPressed: () {
                        showBottom(context);
                      },
                      shape: CircleBorder(
                        side: BorderSide(
                          color: Colors.white,
                        ),
                      ),
                    )
                  ),
                  //IconText(text: "评论", icon: Icon(Icons.comment, size: 30, color: Colors.white,),),
                  IconText(text: (video.downloads == 0 || video.downloads == null) ? '分享': video.downloads.toString(), icon: Icon(Icons.reply, size: 30, color: Colors.white,),),
                ],
              ),),
        ),
        //标题
        Positioned(
          bottom: 0,
          width: 0.7 * screenWidth,
          height: 0.2 * screenHeight,
          child: Container(
//            decoration: BoxDecoration(color: Colors.redAccent),
            child: Container(
              child: Container(
                child: titleSection(),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }

  Widget titleSection() {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.topLeft,
          padding: const EdgeInsets.all(4),
          child: Text('@' + video.authorName, style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              decoration: TextDecoration.none),),
        ),
        Container(
          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
          alignment: Alignment.topLeft,
          child: Text(video.description,
            style: TextStyle(color: Colors.white,
                fontSize: 14,
                decoration: TextDecoration.none),
            maxLines: 4, overflow: TextOverflow.ellipsis,),
        ),
      ],
    );
  }
}

showBottom(context) {
  showModalBottomSheet(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(10)),
      context: context,
      builder: (_) {
        return Container(
            height: 600,
            child: GestureDetector(
                onTap: () {
                  FocusScope.of(context).requestFocus(FocusNode());
                },
                child: ReplyFullList(pCtx: context)
            ));
      });
}


