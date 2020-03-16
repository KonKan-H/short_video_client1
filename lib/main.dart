import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/pages/VideoList/video_upload.dart';
import 'file:///D:/Flutter/project/short_video_client1/lib/pages/FollowingVideo/following_video.dart';
import 'file:///D:/Flutter/project/short_video_client1/lib/pages/UserInfo/my_home_page.dart';
import 'file:///D:/Flutter/project/short_video_client1/lib/pages/VideoList/video_list.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/until/user_until.dart';

void main() {
  runApp(Home());
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
  var userName;

  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
    _getUserInfo();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      setState(() {
        if(event != null && event.userName != null) {
          userName = event.userName;
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
      home: Scaffold(
        drawer: new VideoList(),
        body: new TabBarView(
          controller: controller,
          children: <Widget>[
            new VideoList(),
            new FollowingVideo(),
            new MyHomePage(),
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
           if(userName == null) {
             //_getUserInfo();
             TsUtils.showShort("请先登录");
           } else {
             print('================');
//             Navigator.push(context, MaterialPageRoute(
//                 builder: (context) => UploadVideo()
//             ));
           }
          },
          child: Icon(Icons.videocam),
        ),
      ),
    );
  }

  _getUserInfo() {
    UserUntil.getUserInfo().then((user) {
      if(user != null && user.userName != null) {
        setState(() {
          userName = user.userName;
        });
      }
    });
  }
}