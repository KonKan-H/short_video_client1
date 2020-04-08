import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class selectVideo extends StatefulWidget {
  selectVideo({Key key, this.userId}) : super(key: key);
  final userId;

  @override
  _selectVideoState createState() {
    return _selectVideoState();
  }
}

class _selectVideoState extends State<selectVideo> {
  var userId;
  File _video, _cover;
  double screenWidth, screenHeight;
  VideoPlayerController _videoPlayerController;
  var _controller = new TextEditingController();

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
    userId = widget.userId;
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if(_video != null) {
      _videoPlayerController = VideoPlayerController.file(_video);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('上传视频'),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: 500,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Row(
                        children: <Widget>[
                          Text('选择视频上传 ', style: TextStyle(fontSize: 16),),
                          Text('*', style: TextStyle(color: Colors.red),)
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            showVideoDialog();
                          },
                          child: _video == null ? Container(
                            height: 150,
                            width: 100,
                            decoration: BoxDecoration(
                                color: Colors.grey[100],
                                image: DecorationImage(
                                  image: NetworkImage(ConstantData.VIDEO_UPLOAD_PNG, scale: 4)
                                )
                            ),
                          )
                              : Container(
                            height: 150,
                            width: 100,
                            alignment: Alignment.center,
                            decoration: BoxDecoration(color: Colors.black),
                            child: Center(
                              child: Image.asset('images/ic_arrow_play.png', color: Colors.white, scale: 4,),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text('选择封面上传 ', style: TextStyle(fontSize: 16),),
                    ),
                    Container(
                      padding: EdgeInsets.all(10),
                      alignment: Alignment.centerLeft,
                      child: Material(
                        child: InkWell(
                          onTap: () {
                            showImageDialog();
                          },
                          child: Container(
                            height: 150,
                            width: 100,
                            decoration: _cover == null ? BoxDecoration(
                                color: Colors.grey[100],
                                image: DecorationImage(
                                  image: NetworkImage(ConstantData.VIDEO_UPLOAD_PNG, scale: 4)
//                                  image: FileImage(File('images/ic_arrow_add.png'))
                                )
                            ) : BoxDecoration(
                                color: Colors.transparent,
                                image: new DecorationImage(
                                    image: FileImage(_cover), fit: BoxFit.cover),
                                border: new Border.all(color: Colors.white, width: 2.0)),
                          )
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: Column(
                  children: <Widget>[
                    Container(
                      alignment: Alignment.topLeft,
                      child: Text('添加视频描述'),
                    ),
                    Container(
                      child: Padding(
                        padding: new EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
                        child: new TextField(
                          style: TextStyle(fontSize: 15.0, color: Color(0xff969696)),
                          maxLines: 5,
                          textAlign: TextAlign.start,
                          controller: _controller,
                          decoration: InputDecoration.collapsed(hintText: '最多50个字符'),
                          obscureText: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 0.7 * screenWidth,
                child: RaisedButton(
                  color: Colors.blueAccent,
                  child: new Text(
                    '发 布',
                    style: new TextStyle(color: Colors.white, fontSize: 14.0),
                  ),
                  onPressed: () {
                    if(_video == null) {
                      TsUtils.showShort("选择上传视频");
                      return;
                    }
                    TsUtils.showShort(_controller.text);
                    _uploadVideoInfo();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _uploadVideoInfo() async {
    String videoName = Uuid().v1();
    String videoSuffix = _video.path.substring(_video.path.length - 4, _video.path.length);
    String coverName = Uuid().v1();
    String coverSuffix = _cover.path.substring(_cover.path.length - 4, _cover.path.length);
    FormData formData = FormData.from({
//      'file' : MultipartFile.fromFile(_image.path, filename: name),
      "video" : UploadFileInfo(_video, videoName + videoSuffix),
      "cover" : UploadFileInfo(_cover, coverName + coverSuffix),
      "description" : _controller.text,
      "userId" : userId
    });
    Result result = await DioRequest.uploadFile(URL.UPLOAD_VIDEO_INFO, formData);
    print("==");
  }

  // 显示弹窗
  showVideoDialog() {
    showModalBottomSheet(context: context, builder: _bottomVideoPick);
  }
  showImageDialog() {
    showModalBottomSheet(context: context, builder: _bottomImagePick);
  }

  // 构建弹窗
  Widget _bottomVideoPick(BuildContext context) {
    return initVideoPick();
  }
  Widget _bottomImagePick(BuildContext context) {
    return initImagePick();
  }

  Widget initVideoPick() {
    return new Container(
        height: 170.0,
        child: new Column(
          children: <Widget>[
            new InkWell(
              child: new Container(
                child: new Text(
                  '拍视频',
                  style: new TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                height: 60.0,
                alignment: Alignment.center,
              ),
              onTap: (() {
                Navigator.of(context).pop();
                getVideoPick(ImageSource.camera);
              }),
            ),
            new Divider(height: 1.0,),
            new InkWell(
              onTap: (() {
                Navigator.of(context).pop();
                getVideoPick(ImageSource.gallery);
              }),
              child: new Container(
                child: new Text(
                  '从手机相册选择',
                  style: new TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                height: 60.0,
                alignment: Alignment.center,
              ),
            ),
            new Container(
              height: 5.0,
              color: new Color(0xfff2f2f2),
            ),
            new Container(
              child: new Text(
                '取消',
                style: new TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              height: 40.0,
              alignment: Alignment.center,
            )
          ],
        ));
  }
  Widget initImagePick() {
    return new Container(
        height: 170.0,
        child: new Column(
          children: <Widget>[
            new InkWell(
              child: new Container(
                child: new Text(
                  '拍照',
                  style: new TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                height: 60.0,
                alignment: Alignment.center,
              ),
              onTap: (() {
                Navigator.of(context).pop();
                getImgPick(ImageSource.camera);
              }),
            ),
            new Divider(height: 1.0,),
            new InkWell(
              onTap: (() {
                Navigator.of(context).pop();
                getImgPick(ImageSource.gallery);
              }),
              child: new Container(
                child: new Text(
                  '从手机相册选择',
                  style: new TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                height: 60.0,
                alignment: Alignment.center,
              ),
            ),
            new Container(
              height: 5.0,
              color: new Color(0xfff2f2f2),
            ),
            new Container(
              child: new Text(
                '取消',
                style: new TextStyle(color: Colors.black, fontSize: 15.0),
              ),
              height: 40.0,
              alignment: Alignment.center,
            )
          ],
        ));
  }

  Future<String> getImgPick(ImageSource source) async {
    var tempImg = await ImagePicker.pickImage(source: source);
    setState(() {
      _cover = tempImg;
    });
  }
  Future<String> getVideoPick(ImageSource source) async {
    var tempImg = await ImagePicker.pickVideo(source: source);
    setState(() {
      _video = tempImg;
    });
  }
}
