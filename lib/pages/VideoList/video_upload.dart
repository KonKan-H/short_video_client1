import 'package:flutter/material.dart';

class UploadVideo extends StatefulWidget {
  UploadVideo({Key key}) : super(key: key);

  @override
  _UploadVideoState createState() {
    return _UploadVideoState();
  }
}

class _UploadVideoState extends State<UploadVideo> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(title: Text('上传视频'),),
      body: new Center(
        child: Text('视频上传'),
      ),
    );
  }
}