import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/following_video.dart';
import 'package:short_video_client1/pages/user_info.dart';
import 'package:short_video_client1/pages/video_list.dart';

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
    return new MaterialApp(
      home: new Scaffold(
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
          color: Colors.white,
          child: new TabBar(
            controller: controller,
            labelColor: Colors.deepPurpleAccent,
            unselectedLabelColor: Colors.black26,
            tabs: <Widget>[
              new Tab(
                text: "首页",
                icon: new Icon(Icons.home),
              ),
              new Tab(
                text: "关注",
                icon: new Icon(Icons.unfold_less),
              ),
              new Tab(
                text: "我的",
                icon: new Icon(Icons.my_location),
              ),
            ],
          ),
        ),
      ),
    );
  }
}