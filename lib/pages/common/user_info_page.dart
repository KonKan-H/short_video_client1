import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/pages/common/video_list.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';

class UserInfoPage extends StatefulWidget {
  UserInfoPage({Key key, @required this.userId}) : super(key: key);
  final userId;

  @override
  _UserInfoPageState createState() {
    return _UserInfoPageState(userId: userId);
  }
}

class _UserInfoPageState extends State<UserInfoPage> {
  _UserInfoPageState({Key key, @required this.userId});
  var userId;
  UserInfo userInfo;
  bool isMyself = false, isAttention;

  @override
  void initState() {
    _getUserInfo();
    super.initState();
  }

  _getUserInfo() async {
    Map<String, dynamic> data = {
      "userId" : userId
    };
    Result result = await DioRequest.dioPost(URL.GET_USER_INFO, data);
    userInfo = await UserInfoUntil.map2UserInfo(result.data);
    isMyself = userId == userInfo.userId;
    setState(() {
      userInfo;
      isMyself;
    });
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          Offstage(
            offstage: isMyself,
            child: IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.search),
            ),
          )
        ],
      ),
      body: Center(
        child:  CustomScrollView(reverse: false, shrinkWrap: false,slivers: <Widget>[
          SliverAppBar(
            pinned: false,
            backgroundColor: ConstantData.MAIN_COLOR,
            expandedHeight: 200.0,
            iconTheme: IconThemeData(color: Colors.transparent),
            flexibleSpace: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                (userInfo == null || userInfo.userAvatar == null) ?
                Image.asset('images/ic_avatar_default.png', width: 60.0, height: 60.0,)
                    : Container(
                  width: 60.0,
                  height: 60.0,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.transparent,
                      image: DecorationImage(
                          image: NetworkImage(userInfo.userAvatar),
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
                              child: (userInfo == null || userInfo.sex == null) ? Container(child: Icon(IconData(0xe605, fontFamily: 'MyIcon',)),) :
                              Icon(userInfo.sex == '女' ? IconData(0xe605, fontFamily: 'MyIcon',) : IconData(0xe606,  fontFamily: 'MyIcon',),
                                size: 20, color: Colors.white,),
                            ),
                            Container(
                              child: userInfo == null? null : Text((userInfo.userName == null ? null : userInfo.userName) +
                                  '  ' + (userInfo.age == null ? null: userInfo.age.toString()),
                                style: TextStyle(color: Colors.white, fontSize: 16.0),),
                            ),
                          ],
                        )
                    )
                ),
                Container(
                    child: Offstage(
                      offstage: (userInfo == null || userInfo.userName == null) ? true : false,
                      child: Text('粉丝：0  关注：0', style: TextStyle(color: Colors.white, fontSize: 16.0),),
                    )
                ),
                Container(
                  child: (userInfo == null || userInfo.area == null) ? Container(child: null,) : Offstage(
                    offstage: userInfo.area == null ? true : false,
                    child:  Text(userInfo.area, style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  ),
                ),
                Container(
                  child: (userInfo == null || userInfo.introduction == null) ? Container(child: null,) : Offstage(
                    offstage: userInfo.introduction == null ? true : false,
                    child:  Text(userInfo.introduction, style: TextStyle(color: Colors.white, fontSize: 16.0),),
                  ),
                ),
              ],
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(8.0),
            sliver: new SliverGrid( //Grid
              gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, //Grid按两列显示
                mainAxisSpacing: 10.0,
                crossAxisSpacing: 10.0,
                childAspectRatio: 4.0,
              ),
              delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建子widget
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.cyan[100 * (index % 9)],
                    child: new Text('grid item $index'),
                  );
                },
                childCount: 20,
              ),
            ),
          ),
          //List
          new SliverFixedExtentList(
            itemExtent: 50.0,
            delegate: new SliverChildBuilderDelegate(
                    (BuildContext context, int index) {
                  //创建列表项
                  return new Container(
                    alignment: Alignment.center,
                    color: Colors.lightBlue[100 * (index % 9)],
                    child: new Text('list item $index'),
                  );
                },
                childCount: 50 //50个列表项
            ),
          ),
        ],
        ),
      ),
    );
  }

}