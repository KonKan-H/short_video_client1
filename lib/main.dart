import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'file:///D:/Flutter/project/short_video_client1/lib/pages/FollowingVideo/following_video.dart';
import 'file:///D:/Flutter/project/short_video_client1/lib/pages/UserInfo/user_info.dart';
import 'file:///D:/Flutter/project/short_video_client1/lib/pages/VideoList/video_list.dart';
import 'package:short_video_client1/resources/strings.dart';

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

  @override
  void initState() {
    controller = new TabController(length: 3, vsync: this);
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
            new UserInfo(),
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
      ),
    );
  }
}