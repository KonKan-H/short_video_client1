import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
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

  int _selectedIndex = 0;

  static List<Widget> _widgetOptions = <Widget>[
    new VideoList(),
    new FollowingVideo(),
    new MakeVideo(),
    new MyInfoHomePage(),
  ];

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
      home: Scaffold(
        body: Center(
          child: _widgetOptions.elementAt(_selectedIndex),
        ),
        bottomNavigationBar: Container(
          decoration: BoxDecoration(color: Colors.white, boxShadow: [
            BoxShadow(blurRadius: 20, color: Colors.black.withOpacity(.1))
          ]),
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0, vertical: 8),
              child: GNav(
                  gap: 8,
                  activeColor: Colors.white,
                  iconSize: 24,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                  duration: Duration(milliseconds: 800),
                  tabBackgroundColor:ConstantData.MAIN_COLOR,
                  tabs: [
                    GButton(
                      icon: LineIcons.home,
                      text: 'Home',
                    ),
                    GButton(
                      icon: LineIcons.heart_o,
                      text: 'Likes',
                    ),
                    GButton(
                      icon: LineIcons.edit,
                      text: 'Make',
                    ),
                    GButton(
                      icon: LineIcons.user,
                      text: 'Profile',
                    ),
                  ],
                  selectedIndex: _selectedIndex,
                  onTabChange: (index) {
                    setState(() {
                      _selectedIndex = index;
                    });
                  }),
            ),
          ),
        ),
      ),
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
