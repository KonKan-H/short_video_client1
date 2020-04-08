import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/pages/CameraPage/CameraHomePage.dart';
import 'package:short_video_client1/pages/FollowingVideo/following_video.dart';
import 'package:short_video_client1/pages/UserInfo/my_home_page.dart';
import 'package:short_video_client1/pages/VideoPage/video_list_page.dart';
import 'package:short_video_client1/pages/VideoPage/video_upload.dart';

import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:short_video_client1/resources/util/user_until.dart';

void main() {
//  runApp(Home());
  runApp(Home());
}

class MyApp extends StatelessWidget {
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  Home({Key key}) : super(key: key);

  @override
  _HomeState createState() {
    return _HomeState();
  }
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  TabController controller;
  DateTime lastPopTime;
  var userName, userId;

  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
    _getUserInfo();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        if(event != null && event.userName != null) {
          userName = event.userName;
          userId = event.userId;
        } else {
          userName = null;
        }
      });
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: bodyLayout(controller: controller, userName: userName, userId: userId),
    );
  }

  _getUserInfo() {
    UserInfoUntil.getUserInfo().then((user) {
      if(user != null && user.userName != null) {
        setState(() {
          userName = user.userName;
          userId = user.userId;
        });
      }
    });
  }
}

class bodyLayout extends StatelessWidget {
  bodyLayout({Key key, this.controller, this.userName, this.userId}): super(key: key);

  final TabController controller;
  final userName, userId;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      body: new TabBarView(
        controller: controller,
        children: <Widget>[
          new VideoList(),
          new FollowingVideo(),
          new MyInfoHomePage(),
        ],
      ),
      bottomNavigationBar: new Material(
        child: new TabBar(
          controller: controller,
          labelColor: ConstantData.MAIN_COLOR,
          unselectedLabelColor: Colors.black26,
          tabs: <Widget>[
            new Tab(
              text: "首页",
              icon: new Icon(Icons.home),
            ),
            new Tab(
              text: "关注",
              icon: new Icon(Icons.favorite_border),
            ),
            new Tab(
              text: "我的",
              icon: new Icon(Icons.person),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(userId == null) {
            //_getUserInfo();
            TsUtils.showShort("请先登录");
          } else {
             Navigator.push(context, MaterialPageRoute(
                 builder: (context) => selectVideo(userId: userId,)
             ));
//            Navigator.pushNamed(context, '/');
          }
        },
        child: Icon(Icons.videocam),
      ),
    );
  }
}
