import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/VideoList/layout/video_layout.dart';
import 'package:short_video_client1/pages/VideoList/likebutton/like_button.dart';
import 'package:short_video_client1/pages/VideoList/likebutton/model.dart';
import 'package:video_player/video_player.dart';
import 'package:short_video_client1/models/Video.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key key, @required this.video}): super(key: key);
  final Video video;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState(
      video: video);
//        video: Video(Random().nextInt(100000000), AppString.VIDEO_URL_HEADER + "/hls/v4.m3u8"));
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  _VideoPlayerPageState({Key key, @required this.video});
  final Video video;

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
              title: Text('视频：${video.id}'),
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
              print(_videoPlayerController.value);
            },
            child: Icon(_videoPlayerController.value.isPlaying
            ? Icons.pause
                : Icons.play_arrow),
          ),
        ),
        Positioned(
          right: 0,
          width: 0.20 * screenWidth,
          height: 0.45 * screenHeight,
          top: 0.32 * screenHeight,
          child: Container(
//            decoration: BoxDecoration(color: Colors.orange),
            child: _getButtonList(),),
        ),
        Positioned(
          bottom: 0,
          width: 0.7 * screenWidth,
          height: 0.2 * screenHeight,
          child: Container(
//            decoration: BoxDecoration(color: Colors.redAccent),
            child: Container(
              child: Container(
                child: titleSection,
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

  _getButtonList() {
    return Column(
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
              child: CircleAvatar(backgroundImage: NetworkImage("https:"
                  "//dss2.bdstatic.com/70cFvnSh_Q1YnxGkpoWK1HF6hhy/it/"
                  "u=612723378,2699755568&fm=111&gp=0.jpg"),),
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
        Column(
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
                    //circleStartColor: Colors.white,
                  ),
                ],
              ),
            ),
            Container(
              alignment: Alignment.center,
              child: Text('23', style: TextStyle(color: Colors.white,fontSize: 13.0, decoration: TextDecoration.none), ),
            ),
          ],
        ),
        IconText(text: "评论", icon: Icon(Icons.comment, size: 30, color: Colors.white,),),
        IconText(text: "分享", icon: Icon(Icons.reply, size: 30, color: Colors.white,),),
      ],
    );
  }

  Widget titleSection = Column(
    children: <Widget>[
      Container(
        alignment: Alignment.topLeft,
        padding: const EdgeInsets.all(4),
        child: Text('@人民日报', style: TextStyle(color: Colors.white, fontSize: 17, decoration: TextDecoration.none),),
      ),
      Container(
        padding: const EdgeInsets.fromLTRB(4, 0,  0, 0),
        alignment: Alignment.topLeft,
        child: Text('自从武汉决定迅速建设火神山医院和雷神山医院以来，'
            '自从武汉决定迅速建设火神山医院和雷神山医院以来中联重科第一时间响应。',
          style: TextStyle(color: Colors.white, fontSize: 14, decoration: TextDecoration.none),
          maxLines: 4, overflow: TextOverflow.ellipsis,),
      ),
    ],
  );
}
