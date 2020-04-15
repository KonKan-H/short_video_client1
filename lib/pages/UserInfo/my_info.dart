import 'package:flutter/material.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/AttentionsFans.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/pages/UserInfo/login_screen.dart';
import 'package:short_video_client1/pages/UserInfo/user_detail_info_page.dart';
import 'package:short_video_client1/pages/VideoPage/my_favorite_video.dart';
import 'package:short_video_client1/pages/VideoPage/my_video_list.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:short_video_client1/resources/util/user_until.dart';
import 'login_page.dart';
import 'my_attentions_and_fans.dart';

class MyInfoPage extends StatefulWidget {
  MyInfoPage({Key key}) : super(key: key);

  @override
  _MyInfoPageState createState() {
    return _MyInfoPageState();
  }
}

class _MyInfoPageState extends State<MyInfoPage> {
  var userId, id, userName, userAvatar, sex, area, introduction, age, mobilePhone, fans, attentions;
  var titles = ['我的点赞', '我的视频',  '我的关注', '我的粉丝', '退出登录'];

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    OsApplication.eventBus.on<LoginEvent>().listen((event) {
      if(event != null) {
          setState(() {
            userName = event.userName;
            userAvatar = event.userAvatar;
            age = event.age.toString();
            area = event.area;
            sex = event.sex;
            userId = event.userId;
            if(userId != null) {
              _getFansAndAttentions();
            }
          });
      }
    });
  }

  //取得关注数和粉丝数
  _getFansAndAttentions() async {
    Map<String, dynamic> data = {
      "userId" : userId
    };
    Result result = await DioRequest.dioPost(URL.USER_FANS_ATTENTION, data);
    AttentionsFans attentionsFans = AttentionsFans.formJson(result.data);
    setState(() {
      fans = attentionsFans.fans.toString();
      attentions = attentionsFans.attentions.toString();
    });
  }

  _getUserInfo() {
    UserInfoUntil.getUserInfo().then((userInfo) {
      if(userInfo != null && userInfo.userName != null) {
        if(mounted) {
          setState(() {
            id = userInfo.id;
            userName = userInfo.userName;
            userAvatar = userInfo.userAvatar;
            age = userInfo.age;
            area = userInfo.area;
            sex = userInfo.sex;
            userId = userInfo.userId;
            mobilePhone = userInfo.mobilePhone;
            introduction = userInfo.introduction;
            if(userId != null) {
              _getFansAndAttentions();
            }
          });
        }
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
                      image: NetworkImage(ConstantData.AVATAR_FILE_URI + userAvatar),
                      fit:BoxFit.cover
                    ),
                    border: Border.all(color: Colors.white, width: 2.0)
                  ),
                ),
                Container(
                  margin: const EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
                  alignment: Alignment.center,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          child: sex == null ? null :
                          Icon(sex == '女' ? IconData(0xe605, fontFamily: 'MyIcon',) : IconData(0xe606,  fontFamily: 'MyIcon',),
                          size: 20, color: Colors.white,),
                        ),
                        Container(
                          child: userName == null? Text('点击头像登录', style: TextStyle(color: Colors.white, fontSize: 16.0),) :
                          Text((userName == null ? null : userName) + '  ' + (age == null ? null: age.toString()),
                            style: TextStyle(color: Colors.white, fontSize: 16.0),),
                        ),
                      ],
                    )
                  )
                ),
                Container(
                  child:
                  Offstage(
                    offstage: userName == null ? true : false,
                    child: (fans == null && attentions == null) ? Text('粉丝：0  关注：0', style: TextStyle(color: Colors.white, fontSize: 16.0),):
                    Text('粉丝：${fans.toString()} 关注：${attentions.toString()}', style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  )
                ),
                Container(
                  child: area == null ? Container(child: null,) : Offstage(
                    offstage: area == null ? true : false,
                    child:  Text(area.toString(), style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  ),
                ),
                Container(
                  child: introduction == null ? Container(child: null,) : Offstage(
                    offstage: introduction == null ? true : false,
                    child:  Text(introduction, style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  ),
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
                  if(userId == null) {
                    TsUtils.showShort('请先登录');
                    return;
                  }
                  print('this is the item of $title');
                  listDetal(title);
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

  void listDetal(String title) {
    if(title == "退出登录"){
      if(mounted) {
        setState(() {
          UserUntil.cleanUserInfo();
          UserInfoUntil.cleanUserInfo();
          userName = null;
          userAvatar = null;
          sex = null;
          area = null;
          introduction = null;
        });
      }
      TsUtils.showShort("退出成功");
    } else if(title == "我的视频") {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyVideoList(userId: userId, couldDelete: true)
      ));
    } else if(title == "我的关注" || title == "我的粉丝") {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyAttentionsAndFans(title: title, userId: userId)
      ));
    } else if(title == "我的点赞") {
      Navigator.push(context, MaterialPageRoute(
        builder: (context) => MyFavoriteVideo(userId: userId)
      ));
    }
  }
}