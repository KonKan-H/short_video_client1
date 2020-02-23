import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:short_video_client1/models/Video.dart';

class VideoPlayerPage extends StatefulWidget {
  VideoPlayerPage({Key key, @required this.video}): super(key: key);
  final Video video;

  @override
  _VideoPlayerPageState createState() => _VideoPlayerPageState(
      video: Video(video.id, video.url, video.author));
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
    return Scaffold(
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
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController.dispose();
  }
}


