import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:path_provider/path_provider.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/Attention.dart';
import 'package:short_video_client1/models/Reply.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/pages/VideoPage/layout/BottomSheet.dart';
import 'package:short_video_client1/pages/VideoPage/likebutton/like_button.dart';
import 'package:short_video_client1/pages/VideoPage/my_video_list.dart';
import 'package:short_video_client1/pages/common/user_info_page.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
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
  bool isLiked, isAttention;
  double screenWidth;
  double screenHeight;
  List<Reply> replies = List();

  VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    TsUtils.logInfo(ConstantData.VIDEO_FILE_URI + video.url);
    _videoPlayerController = VideoPlayerController.network(ConstantData.VIDEO_FILE_URI + video.url)
      ..initialize().then((_) {
        //确保在视频初始化后显示第一帧，甚至在按下播放按钮之前。
        _videoPlayerController.play();
        setState(() {
          _videoPlayerController.setLooping(true);
        });
      });
    _getUserInfo();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      if(event != null) {
        userName = event.userName;
        userAvatar = event.userAvatar;
        age = event.age.toString();
        area = event.area;
        sex = event.sex;
        userAvatar = event.userAvatar;
        userId = event.userId;
        video.looker = event.userId;
      }
    });
    _getReplyList();
    _getLikeAndAttention();
  }

  _getUserInfo() {
    UserInfoUtil.getUserInfo().then((userInfo) {
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
          video.looker = userInfo.userId;
        });
      }
    });
  }

  _getLikeAndAttention() async {
    if(video.looker == null) {
      return;
    }
    Result likeResult = await DioRequest.dioPost(URL.VIDEO_LIKE_OR_NOT, Video.model2map(video));
    Attention attention = new Attention();
    attention.userId = video.authorId;
    attention.fansId = video.looker;
    DioRequest.dioPost(URL.USER_ATTENTION_OR_NOT,Attention.model2map(attention)).then((value) {
      if(mounted) {
        setState(() {
          isLiked = likeResult.data;
          isAttention = value.data;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    //取得屏幕宽度
    screenWidth = MediaQuery.of(context).size.width;
    screenHeight = MediaQuery.of(context).size.height;

    return Stack(
      children: <Widget>[
        Scaffold(
          body: Material(
            child: InkWell(
              child: Container(
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
              onTap: () {
                if(mounted) {
                  setState(() {
                    _videoPlayerController.value.isPlaying
                      ? _videoPlayerController.pause()
                    : _videoPlayerController.play();
                  });
                }
              },
            ),
          ),
        ),
        Positioned(
          right: 0,
          width: 0.20 * screenWidth,
          height: 0.4 * screenHeight,
          bottom: 0.2 * screenHeight,
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
                        if(video.looker == null) {
                          TsUtils.showShort("请先登录");
                          return;
                        }
                        if(video.authorId == video.looker) {
                          _videoPlayerController.pause();
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => MyVideoList(userId: userId, couldDelete: true)
                          ));
                        } else {
                          _videoPlayerController.pause();
                          Navigator.push(context, MaterialPageRoute(
                              builder: (context) => UserInfoPage(authorId : video.authorId, looker: video.looker,)
                          ));
                        }
                      },
                      child: Container(
                        width: 60,
                        height: 70,
                        child: Stack(children: <Widget>[
                          Container(
                            width: 60,
                            height: 60,
                            //alignment: Alignment.bottomCenter,
                            child: CircleAvatar(backgroundImage: NetworkImage(ConstantData.AVATAR_FILE_URI + video.authorAvatar),),
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
                                      if(userId == null) {
                                        TsUtils.showShort('请先登录');
                                        return;
                                      }
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
                            width: 90.0,
                            duration: Duration(seconds: 1),
                            circleStartColor: Color(0xffffff),
                            looker: userId,
                            video: video,
                            isLike: isLiked,
                          ),
                        ):Column(
                          children: <Widget>[
                            Container(
                                padding: EdgeInsets.fromLTRB(0, 7, 0, 0),
                                child: Icon(Icons.favorite, color: Colors.white, size: 35,)
                            ),
                            Container(
                              child: Text("点赞", style: TextStyle(color: Colors.white, fontSize: 13, decoration: TextDecoration.none),),
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                  //评论
                  Container(
                    child: Column(
                      children: <Widget>[
                        Material(
                          color: Colors.transparent,
                          child: InkWell(
                            child: Icon(IconData(0xf003b, fontFamily: 'MyIcon'), color: Colors.white, size: 35,),
                            onTap: () {
                              _getReplyList();
                              showBottom(context, video);
                            },
                          ),
                        ),
                        Container(
                          child: Text(TsUtils.dataDeal(video.comments), style: TextStyle(color: Colors.white, fontSize: 13, decoration: TextDecoration.none),),
                        ),
                      ],
                    )
                  ),
                  Container(
//                      child: videoControlAction(icon: IconData(0xe633, fontFamily: 'MyIcon'), label: TsUtils.dataDeal(video.downloads)),
                      child: Column(
                        children: <Widget>[
                          Material(
                            color: Colors.transparent,
                            child: InkWell(
                              highlightColor: Colors.transparent,
                              child: Icon(IconData(0xe633, fontFamily: 'MyIcon',), size: 28, color: Colors.white,),
                              onTap: () {
                                _downLoadVideo(video);
                              },
                            ),
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
          height: 0.25 * screenHeight,
          child: Container(
//            decoration: BoxDecoration(color: Colors.redAccent),
            padding: EdgeInsets.all(4),
            child: Container(
              child: titleSection(),
            ),
          ),
        ),
        Positioned(
          top: 0.08 * screenHeight,
          left: 5,
          child: Container(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                child: Icon(IconData(0xe952, fontFamily: "play"), color: Colors.white, size: 35,),
                onTap: () {
                  _videoPlayerController.pause();
                  Navigator.pop(context);
                },
              ),
            ),
          ),
        ),
        Offstage(
          offstage: _videoPlayerController.value.isPlaying,
          child: Center(
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                highlightColor: Colors.transparent,
                child: Icon(IconData(0xe637, fontFamily: 'play'), color: Colors.white, size: 60,),
                onTap: () {
                  if(mounted) {
                    setState(() {
                      _videoPlayerController.value.isPlaying
                          ? _videoPlayerController.pause()
                          : _videoPlayerController.play();
                    });
                  }
                },
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
    return Container(
      padding: EdgeInsets.only(left: 16, bottom: 60),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.only(top: 7, bottom: 7),
            child: Row(
              children: <Widget>[
                Text(
                  "@" + video.authorName,
                  style: TextStyle(
                    fontSize: 14, color: Colors.white, fontWeight: FontWeight.w500, decoration: TextDecoration.none),
                ),
                Text(
                  " " + TsUtils.dateDeal(video.createTime),
                  style: TextStyle(
                    fontSize: 12, color: Colors.white, fontWeight: FontWeight.w100, decoration: TextDecoration.none
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 4, bottom: 7),
            child: Text(
                video.description,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.none,),
                maxLines: 3, overflow: TextOverflow.ellipsis,
                ),
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.music_note,
                size: 19,
                color: Colors.white,
              ),
              Text(
                "Ready for music ...",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                    decoration: TextDecoration.none),
              )
            ],
          ),
        ],
      ),
    );
//    return Column(
//      children: <Widget>[
//        Container(
//          alignment: Alignment.topLeft,
//          padding: const EdgeInsets.all(4),
//          child: Text('@' + video.authorName, style: TextStyle(
//              color: Colors.white,
//              fontSize: 17,
//              decoration: TextDecoration.none),),
//        ),
//        Container(
//          padding: const EdgeInsets.fromLTRB(4, 0, 0, 0),
//          alignment: Alignment.topLeft,
//          child: Text(video.description == null ? "" : video.description,
//            style: TextStyle(color: Colors.white,
//                fontSize: 14,
//                decoration: TextDecoration.none),
//            maxLines: 4, overflow: TextOverflow.ellipsis,),
//        ),
//      ],
//    );
  }

  //下载视频
  _downLoadVideo(Video video) async {
    WidgetsFlutterBinding.ensureInitialized();
    FlutterDownloader.initialize();
    // 获取存储路径
    //var _localPath = (await _findLocalPath()) + ConstantData.VIDEO_LOCALHOST;
    var _localPath = ConstantData.VIDEO_LOCALHOST;
    final savedDir = Directory(_localPath);
    // 判断下载路径是否存在
    bool hasExisted = await savedDir.exists();
    // 不存在就新建路径
    if (!hasExisted) {
      savedDir.create();
    }
    String fileName = video.url.toString().substring(0, video.url.toString().indexOf(".")) + '.mp4';
    print(ConstantData.VIDEO_FILE_URI + fileName);
//    ProgressDialog pr = TsUtils.showProgressDiolog(context, "视频下载中....");
//    await pr.show();
    await FlutterDownloader.enqueue(
      url: ConstantData.VIDEO_FILE_URI + fileName,
      fileName: fileName,
      savedDir: _localPath,
      showNotification: true,
      // show download progress in status bar (for Android)
      openFileFromNotification: true, // click on notification to open downloaded file (for Android)
    );
//    pr.hide();
    TsUtils.showShort('下载成功, 文件保存在' + _localPath);
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

  showBottom(context, Video video) {
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadiusDirectional.circular(10)),
        context: context,
        builder: (_) {
          return Container(
              height: 0.6 * screenHeight,
              child: GestureDetector(
                  onTap: () {
                    FocusScope.of(context).requestFocus(FocusNode());
                  },
                  child: ReplyFullList(pCtx: context, video: video, replies: replies,userId: video.looker.toString())
              ),
          );
        });
  }

  _getReplyList() async {
    Map<String, dynamic> map = Video.model2map(video);
    Result result = await DioRequest.dioPost(URL.VIDEO_REPLY_LIST, map);
    if(result != null) {
      replies.clear();
      for(Map<String, dynamic> map in result.data) {
        replies.add(Reply.formJson(map));
      }
      if(mounted) {
        setState(() {
          replies;
        });
      }
    }
  }
}

Future<bool> attentionUser(Video video) async {
  Attention attention = new Attention();
  attention.userId = video.authorId;
  attention.fansId = video.looker;
  Result result = await DioRequest.dioPost(URL.ATTENTION_USER_INSERT,Attention.model2map(attention));
  print(result.data);
  return result.data as bool;
}
