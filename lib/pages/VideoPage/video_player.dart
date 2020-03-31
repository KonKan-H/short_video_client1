import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/Attention.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/pages/VideoPage/layout/BottomSheet.dart';
import 'package:short_video_client1/pages/VideoPage/likebutton/like_button.dart';
import 'package:short_video_client1/pages/common/user_info_page.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:uuid/uuid.dart';
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
  bool isLiked, isAttention;

  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    _getLikeAndAttention();
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

  _getLikeAndAttention() async {
    Result likeResult = await DioRequest.dioPost(URL.VIDEO_LIKE_OR_NOT, Video.model2map(video));
    isLiked = likeResult.data;
    Attention attention = new Attention();
    attention.userId = video.authorId;
    attention.fansId = video.looker;
    Result attentionResult = await DioRequest.dioPost(URL.USER_ATTENTION,Attention.model2map(attention));
    isAttention = attentionResult.data;
    setState(() {
      isLiked;
      isAttention;
    });
  }

  @override
  Widget build(BuildContext context) {
    //取得屏幕宽度
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;

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
                  Material(
                    //透明色
                    color: Color(0x00FFFFFF),
                    shape: CircleBorder(),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) => UserInfoPage(userId : video.authorId)
                        ));
                      },
                      child: Container(
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
                              child: Offstage(
                                offstage: isAttention == null ? false : isAttention,
                                child: Material(
                                  color: Color(0x00FFFFFF),
                                  shape: CircleBorder(),
                                  child: InkWell(
                                    onTap: () async {
                                      bool flag = await attentionUser(video);
                                      if(flag) {
                                        TsUtils.showShort('关注成功');
                                        setState(() {
                                          isAttention = flag;
                                        });
                                      } else {
                                        TsUtils.showShort('关注失败');
                                      }
                                    },
                                    child:  Container(
                                      width: 25,
                                      height: 25,
                                      decoration: BoxDecoration(
                                          color: Colors.redAccent,
                                          borderRadius: BorderRadius.circular(25)
                                      ),
                                      child: Icon(Icons.add, size: 20, color: Colors.white,),
                                    ),
                                  ),
                                ),
                              )
                          )
                        ],),
                      ),
                    ),
                  ),
                  //点赞爱心
                  Container(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        isLiked != null ? Container(
                          child: LikeButton(
                            width: 72.0,
                            duration: Duration(seconds: 2),
                            circleStartColor: Color(0xffffff),
                            looker: userId,
                            video: video,
                            isLike: isLiked,
                          ),
                        ):Container(
                          child: Icon(Icons.favorite, color: Colors.white,)
                        ),
                      ],
                    ),
                  ),
                  Container(
                    child: Column(
                      children: <Widget>[
                        RaisedButton(
                          child: Icon(Icons.comment, color: Colors.white, size: 35,),
                          color: Color(0x00FFFFFF),
                          onPressed: () {
                            showBottom(context);
                          },
                          shape: CircleBorder(),
                        ),
                        Container(
                          child: Text(TsUtils.dataDeal(video.comments), style: TextStyle(color: Colors.white, fontSize: 13, decoration: TextDecoration.none),),
                        ),
                      ],
                    )
                  ),
                  Container(
                      child: Column(
                        children: <Widget>[
                          RaisedButton(
//                            child: Text('下载', style: TextStyle(color: Colors.white),),
                            child: Icon(Icons.share, color: Colors.white, size: 35,),
                            color: Color(0x00FFFFFF),
                            onPressed: () {
                              _downLoadVideo(video);
                            },
                            shape: CircleBorder(),
                          ),
                          Container(
                            child: Text(TsUtils.dataDeal(video.downloads), style: TextStyle(color: Colors.white, fontSize: 13, decoration: TextDecoration.none),),
                          )
                        ],
                      )
                  ),
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

  //标题
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

  //下载视频
  _downLoadVideo(Video video) async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize();
    // 获取存储路径
    var _localPath = (await _findLocalPath()) + ConstantData.VIDEO_LOCALHOST;
    final savedDir = Directory(_localPath);
    // 判断下载路径是否存在
    bool hasExisted = await savedDir.exists();
    // 不存在就新建路径
    if (!hasExisted) {
      savedDir.create();
    }
    String fileName = Uuid().v1() + '.mp4';
    await FlutterDownloader.enqueue(
      url: video.url,
      fileName: fileName,
      savedDir: _localPath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
    TsUtils.showShort('下载成功');
    setState(() {
      video.downloads ++;
    });
    Map<String, dynamic> data = Video.model2map(video);
    Result result = await DioRequest.dioPut(URL.VIDEO_DOWNLOAD, data);
  }

  // 获取存储路径
  Future<String> _findLocalPath() async {
    // 如果是android，使用getExternalStorageDirectory
    // 如果是iOS，使用getApplicationSupportDirectory
    final directory = Theme.of(context).platform == TargetPlatform.android
        ? await getExternalStorageDirectory()
        : await getApplicationSupportDirectory();
    return directory.path;
  }
}

Future<bool> attentionUser(Video video) async {
  Attention attention = new Attention();
  attention.userId = video.authorId;
  attention.fansId = video.looker;
  Result result = await DioRequest.dioPost(URL.ATTENTION_USER,Attention.model2map(attention));
  print(result.data);
  return result.data as bool;
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



