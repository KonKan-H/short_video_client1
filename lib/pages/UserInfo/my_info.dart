import 'package:flutter/material.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/pages/UserInfo/user_detail_info_page.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:short_video_client1/resources/util/user_until.dart';
import 'login_page.dart';

class MyInfoPage extends StatefulWidget {
  MyInfoPage({Key key}) : super(key: key);

  @override
  _MyInfoPageState createState() {
    return _MyInfoPageState();
  }
}

class _MyInfoPageState extends State<MyInfoPage> {
  var userId, id, userName, userAvatar, sex, area, introduction, age, mobilePhone;
  var titles = ['我的消息', '我的视频',  '我的关注', '我的粉丝', '退出登录'];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      OsApplication.eventBus.on<LoginEvent>().listen((event) {
        if(event != null) {
          setState(() {
            userName = event.userName;
            userAvatar = event.userAvatar;
            age = event.age.toString();
            area = event.area;
            sex = event.sex;
            userAvatar = event.userAvatar;
            userId = event.userId;
          });
        } else {
          userName = null;
        }
      });
    });
  }

  _getUserInfo() {
    UserInfoUntil.getUserInfo().then((userInfo) {
      if(userInfo != null && userInfo.userName != null) {
        setState(() {
          id = userInfo.id;
          userName = userInfo.userName;
          userAvatar = userInfo.userAvatar;
          age = userInfo.age;
          area = userInfo.area;
          sex = userInfo.sex;
          userAvatar = userInfo.userAvatar;
          userId = userInfo.userId;
          mobilePhone = userInfo.mobilePhone;
          introduction = userInfo.introduction;
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
    // TODO: implement build
    return CustomScrollView(reverse: false, shrinkWrap: false,slivers: <Widget>[
        SliverAppBar(
          pinned: false,
          backgroundColor: ConstantData.MAIN_COLOR,
          expandedHeight: 200.0,
          iconTheme: IconThemeData(color: Colors.transparent),
          flexibleSpace: InkWell(
            onTap: () {
              userName == null ? _loginPage(): _userDetail();
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
                  child: Text(userName == null ?
                  '点击头像登录' : userName, style: TextStyle(color: Colors.white, fontSize: 16.0),),
                ),
                Container(
                  child: Offstage(
                    offstage: userName == null ? true : false,
                    child: Text('粉丝：0  关注：0', style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  )
                ),
              ],
            ),
          ),
        ),
        SliverFixedExtentList(
          delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
            String title = titles[index];
            return Container(
              alignment: Alignment.centerLeft,
              child: InkWell(
                onTap: () {
                  print('this is the item of $title');
                  if(title == "退出登录"){
                    if(userName != null) {
                      setState(() {
                        UserUntil.cleanUserInfo();
                        UserInfoUntil.cleanUserInfo();
                        userName = null;
                        userAvatar = null;
                      });
                      TsUtils.showShort("退出成功");
                    } else {
                      TsUtils.showShort("请先登录");
                    }
                  }
                },
                child: Column(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.all(10.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(title, style: TextStyle(fontSize: 16.0),),
                          ),
                          Image.asset(
                            'images/ic_arrow_right.png',
                            width: 30.0,
                            height: 16.0,
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 1.0,
                    )
                  ],
                ),
              ),
            );
          }, childCount: titles.length),
          itemExtent: 50.0,),
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
      builder: (context) => UserDetailInfoPage()
    ));
  }

}