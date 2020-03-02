import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/UserInfo/user_detail_info_page.dart';
import 'package:short_video_client1/resources/strings.dart';

import 'login_page.dart';

class MyInfoPage extends StatefulWidget {
  MyInfoPage({Key key}) : super(key: key);

  @override
  _MyInfoPageState createState() {
    return _MyInfoPageState();
  }
}

class _MyInfoPageState extends State<MyInfoPage> {
  //用户头像
  String userAvatar;
  String userName;

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
    return CustomScrollView(reverse: false, shrinkWrap: false,slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          backgroundColor: ConstantData.MAIN_COLOR,
          expandedHeight: 200.0,
          iconTheme: IconThemeData(color: Colors.transparent),
          flexibleSpace: InkWell(
            onTap: () {
              userAvatar == null ? _loginPage(): _userDetail();
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                userAvatar == null ?
                  Image.asset('images/ic_avatar_default.png', width: 60.0, height: 60.0,)
                    : Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.transparent,
                    image: DecorationImage(
                      image: NetworkImage(userAvatar),
                      fit:BoxFit.cover
                    ),
                    border: Border.all(color: Colors.white, width: 2.0)
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  child: Text(userAvatar == null ?
                  '点击头像登录' : userName, style: TextStyle(color: Colors.white, fontSize: 16.0),),
                )
              ],
            ),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {

          }),
        ),
      ],
    );
  }

  _loginPage() {
    final result = Navigator.push(context, MaterialPageRoute(
      builder: (context) => LoginPage(),
    ));
  }

  _userDetail() {
    Navigator.push(context, MaterialPageRoute(
      builder: (context) => UserInfoPage()
    ));
  }
}