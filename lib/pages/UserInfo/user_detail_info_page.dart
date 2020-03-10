import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/until/user_info_until.dart';

class UserDetailInfoPage extends StatefulWidget {
  UserDetailInfoPage({Key key}): super(key: key);

  @override
  _UserDetailInfoPageState createState() => _UserDetailInfoPageState();
}

class _UserDetailInfoPageState extends State<UserDetailInfoPage> {
  String userName, userAvatar, sex, area, introduction, age, mobilePhone;
  int userId, id;
  File _image;
//  WidgetsUtils widgetsUtils;

  var _userNameController = new TextEditingController();
  var _userSexController = new TextEditingController();
  var _userAgeController = new TextEditingController();
  var _userIntroController = new TextEditingController();
  var _userAreaController = new TextEditingController();

  var leftRes = new TextStyle(fontSize: 16.0, color: Colors.black);
  var hintRes = new TextStyle(fontSize: 15.0, color: Color(0xff969696));

  @override
  void initState() {
    super.initState();
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
      } else {
        userName = null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
//    widgetsUtils = new WidgetsUtils(context);
    return new Scaffold(
      appBar: new AppBar(
        title: Text('用户信息', style: new TextStyle(color: Colors.white)),
        iconTheme: new IconThemeData(color: Colors.white),
      ),
      body: initInputBody(),
    );
  }

  Widget initInputBody() {
    List<Widget> items = [];
    items.addAll(initHeaderItem(null));
    items.addAll(initInputItem('用户名', '请输入用户名', _userNameController, userName));
    items.addAll(initInputItem('性别', '请输入性别', _userSexController, sex));
    items.addAll(initInputItem('年龄', '请输入年龄', _userAgeController, age));
    items.addAll(initInputItem('地区', '请输入地区', _userAreaController, area));
    items.addAll(initInputItem('简介', '介绍下自己吧', _userIntroController, introduction, maxLines: 5));
    items.add(initSubmitBtn());
    return new Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: items,
    );
  }

  // 显示弹窗
  showPickDialog() {
    showModalBottomSheet(context: context, builder: _bottomPick);
  }

// 构建弹窗
  Widget _bottomPick(BuildContext context) {
    return initImgPick();
  }

  Future<String> getImgPick(ImageSource source) async {
    var tempImg = await ImagePicker.pickImage(source: source);
    setState(() {
      _image = tempImg;
    });
  }

  List<Widget> initHeaderItem(var userAvatar) {
    List<Widget> item = [];
    item.add(new InkWell(
      onTap: (() {
        showPickDialog();
      }),
      child: new Padding(
        padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Container(
                child: new Text(
                  '头像',
                  style: leftRes,
                ),
                alignment: Alignment.centerLeft,
                height: 80.0,
              ),
            ),
            initHeaderView(userAvatar)
          ],
        ),
      ),
    ));
    item.add(new Divider(
      height: 1.0,
    ));
    return item;
  }

  Widget initHeaderView(var userAvatar) {
    if (_image == null) {
      if (userAvatar == null) {
        return new Image.asset(
          "images/ic_avatar_default.png",
          width: 60.0,
          height: 60.0,
        );
      } else {
        return new Container(
          width: 60.0,
          height: 60.0,
          decoration: new BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.transparent,
              image: new DecorationImage(
                  image: new NetworkImage(userAvatar), fit: BoxFit.cover),
              border: new Border.all(color: Colors.white, width: 2.0)),
        );
      }
    } else {
      return new Container(
        width: 60.0,
        height: 60.0,
        decoration: new BoxDecoration(
            shape: BoxShape.circle,
            image: new DecorationImage(
                image: new FileImage(_image), fit: BoxFit.cover),
            border: new Border.all(color: Colors.white, width: 2.0)),
      );
    }
  }

//  初始化输入的item
  List<Widget> initInputItem(var leftMsg, var hintMsg, TextEditingController controller, var content,
      {var maxLines = 1}) {
    List<Widget> item = [];
    item.add(
      new Padding(
        padding: new EdgeInsets.fromLTRB(10.0, 0.0, 10.0, 0.0),
        child: new Row(
          children: <Widget>[
            new Expanded(
              child: new Container(
                child: new Text(
                  leftMsg,
                  style: leftRes,
                ),
                alignment: Alignment.centerLeft,
                height: 50.0,
              ),
            ),
            new Expanded(
                flex: 2,
                child: new Padding(
                  padding: new EdgeInsets.fromLTRB(0.0, 6.0, 0.0, 6.0),
                  child: new TextField(
                    style: hintRes,
                    maxLines: maxLines,
                    textAlign: maxLines == 1 ? TextAlign.end : TextAlign.end,
                    controller: content == null ? controller : controller = TextEditingController.fromValue(TextEditingValue(text: content)),
                    decoration: InputDecoration.collapsed(hintText: hintMsg),
                    obscureText: false,
                  ),
                ))
          ],
        ),
      ),
    );
    item.add(new Divider(
      height: 1.0,
    ));
    return item;
  }

  Widget initSubmitBtn() {
    return new Container(
      width: 360.0,
//      margin: new EdgeInsets.fromLTRB(20.0, 40.0, 20.0, 0.0),
      margin: new EdgeInsets.all(4.0),
      child: new Card(
        color: ConstantData.MAIN_COLOR,
        elevation: 2.0,
        child: new MaterialButton(
          onPressed: () async {
          if(_userSexController.text != null) {
            if(_userSexController.text != "男" && _userSexController.text != "女" ) {
              print(_userSexController.text);
              TsUtils.showShort("请输入正确格式的性别");
              return;
            }
          }
            Map<String, dynamic> data = {
              'userId': userId,
              'age': _userAgeController.text,
              'userName': _userNameController.text,
//              'userAvatar': ,
              'sex': _userSexController.text,
              'area': _userAreaController.text,
              'introducton': _userIntroController.text
            };
            Result result = await DioRequest.dioPut(URL.USER_INFO_UPDATE, data);
            print(result.msg);
            TsUtils.showShort(result.msg);
            UserInfo userInfo = new UserInfo();
            userInfo.id = id;
            userInfo.userId = userId;
            userInfo.userName = _userNameController.text;
            userInfo.mobilePhone = mobilePhone;
            userInfo.userAvatar = null;
            userInfo.sex = _userSexController.text;
            userInfo.area = _userAreaController.text;
            userInfo.introduction = _userIntroController.text;
            UserInfoUntil.saveUserInfo(userInfo);
            OsApplication.eventBus.fire(LoginEvent(userInfo.userId, userInfo.userName, userInfo.userAvatar,
                userInfo.age, userInfo.sex, userInfo.area, userInfo.introduction));
          },
          child: new Text(
            '确认修改',
            style: new TextStyle(color: Colors.white, fontSize: 14.0),
          ),
        ),
      ),
    );
  }

  Widget initImgPick() {
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
            new Divider(
              height: 1.0,
            ),
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

  _getUserInfo() {
     UserInfoUntil.getUserInfo().then((userInfo) {
       if(userInfo != null) {
         setState(() {
           id = userInfo.id;
           userName = userInfo.userName;
           userAvatar = userInfo.userAvatar;
           age = userInfo.age as String;
           area = userInfo.area;
           sex = userInfo.sex;
           userAvatar = userInfo.userAvatar;
           userId = userInfo.userId;
           mobilePhone = userInfo.mobilePhone;
         });
//         if(userName != null) {
//           _userNameController = TextEditingController.fromValue(TextEditingValue(text: userName));
//         }
       }
     });
  }
}
