import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:video_player/video_player.dart';

class VideoScreen extends StatefulWidget {
  VideoScreen({Key key, @required this.video}) : super(key: key);
  final Video video;
  @override
  _VideoScreenState createState() {
    return _VideoScreenState(
        video: Video(video.id, 'https://www.runoob.com/try/demo_source/mov_bbb.mp4', video.author));
//        video: Video(Random().nextInt(100000000), AppString.VIDEO_URL_HEADER + "/hls/v4.m3u8"));
  }
}

class _VideoScreenState extends State<VideoScreen> {
  _VideoScreenState({Key key, @required this.video}) : super();
  final Video video;

  VideoPlayerController _controller;
  bool _isPlaying = true;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(this.video.url)
    // 播放状态
      ..addListener(() {
        final bool isPlaying = _controller.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() { _isPlaying = isPlaying; });
        }
      })
    // 在初始化完成后必须更新界面
      ..initialize().then((_) {
        setState(() {});
      });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('视频：${video.id}'),),
        body: Stack(
          children: <Widget>[
            Center(
              child: Scaffold(
                body: Container(
                  alignment: Alignment.topCenter,
                  child: _controller.value.initialized
                      ? AspectRatio(
                    aspectRatio: _controller.value.aspectRatio,
                    child: VideoPlayer(_controller),
                  ): Container(),
                ),
                floatingActionButton: FloatingActionButton(
                  onPressed: _controller.value.isPlaying
                      ? _controller.pause
                      : _controller.play,
                  child: new Icon(
                    _controller.value.isPlaying ? Icons.pause : Icons.play_arrow,
                  ),
                ),
              ),
            ),
            Container(
                child: Container(
                  child: Stack(
                    children: <Widget>[

                    ],
                  ),
                )
            ),
          ],
        )
    );
  }
}