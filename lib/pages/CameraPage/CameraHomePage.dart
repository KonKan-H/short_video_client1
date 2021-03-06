import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/pages/common/process_Indicator.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:uuid/uuid.dart';
import 'package:video_player/video_player.dart';

class MakeVideo extends StatefulWidget {
  MakeVideo({Key key}) : super(key: key);

  @override
  _MakeVideoState createState() {
    return _MakeVideoState();
  }
}

class _MakeVideoState extends State<MakeVideo> {
  var userId;
  File _video, _cover;
  double screenWidth, screenHeight;
  VideoPlayerController _videoPlayerController;
  var _controller = new TextEditingController();

  @override
  void initState() {
    _getUserInfo();
    super.initState();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      if(event != null) {
        userId = event.userId;
      }
    });
  }

  _getUserInfo() {
    UserInfoUtil.getUserInfo().then((userInfo) {
      if(userInfo != null && userInfo.userName != null) {
        setState(() {
          userId = userInfo.userId;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery.of(context).size.height;
    screenWidth = MediaQuery.of(context).size.width;
    if(_video != null) {
      _videoPlayerController = VideoPlayerController.file(_video);
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload Video'),
        centerTitle: true,
        backgroundColor: ConstantData.MAIN_COLOR,
      ),
      body: Card(
        margin: EdgeInsets.all(4),
        child: Container(
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
                            Text('选择视频上传(小于15MB) ', style: TextStyle(fontSize: 16),),
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
                              if(userId == null) {
                                TsUtils.showShort('请先登录');
                                return;
                              }
                              showVideoDialog();
                            },
                            child: _video == null ? Container(
                              height: 150,
                              width: 100,
                              decoration: BoxDecoration(
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
                Divider(),
                Container(
                  child: Column(
                    children: <Widget>[
                      Container(
                        alignment: Alignment.topLeft,
                        child: Text('选择封面上传(小于15MB) ', style: TextStyle(fontSize: 16),),
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
                Divider(),
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
                Divider(),
                Container(
                  width: 0.7 * screenWidth,
                  child: RaisedButton(
                    color: ConstantData.MAIN_COLOR,
                    child: new Text(
                      '发 布',
                      style: new TextStyle(color: Colors.white, fontSize: 14.0),
                    ),
                    onPressed: () async {
                      if(_video == null) {
                        TsUtils.showShort("选择上传视频");
                        return;
                      }
                      _video.length().then((value) async {
                        if(value <= ConstantData.VIDEO_SIZE) {
                          ProgressDialog pr = TsUtils.showProgressDiolog(context, "视频上传中....");
                          await pr.show();
                          _uploadVideoInfo().then((result) {
                            pr.hide();
                          });
                          TsUtils.showShort("上传成功");
                          Navigator.pop(context);
                        } else {
                          TsUtils.showShort("视频文件过大");
                        }
                        if(mounted) {
                          setState(() {
                            _video = null;
                            _cover = null;
                            _controller.text = null;
                          });
                        }
                      });
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<Result> _uploadVideoInfo() async {
    String videoName = Uuid().v1();
    String videoSuffix = _video.path.substring(_video.path.length - 4, _video.path.length);
    FormData formData = FormData.from({
      "video" : UploadFileInfo(_video, videoName + videoSuffix),
      "description" : _controller.text,
      "userId" : userId
    });
    String coverName;
    String coverSuffix;
    Result result;
    if(_cover != null) {
      coverName = Uuid().v1();
      coverSuffix = _cover.path.substring(_cover.path.length - 4, _cover.path.length);
      formData.add("cover" , UploadFileInfo(_cover, coverName + coverSuffix));
      result = await DioRequest.uploadFile(URL.UPLOAD_VIDEO_INFO_COVER, formData);
    } else {
      result = await DioRequest.uploadFile(URL.UPLOAD_VIDEO_INFO, formData);
    }
    return result;
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
            new InkWell(
              child: Container(
                child: new Text(
                  '取消',
                  style: new TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                height: 40.0,
                alignment: Alignment.center,
              ),
              onTap: () {
                Navigator.pop(context);
              },
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
            new InkWell(
              child: Container(
                child: new Text(
                  '取消',
                  style: new TextStyle(color: Colors.black, fontSize: 15.0),
                ),
                height: 40.0,
                alignment: Alignment.center,
              ),
              onTap: () {
                Navigator.pop(context);
              },
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
