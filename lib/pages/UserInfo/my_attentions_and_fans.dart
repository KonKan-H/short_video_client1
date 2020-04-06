import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/pages/common/user_info_page.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';

class MyAttentionsAndFans extends StatefulWidget {
  MyAttentionsAndFans({Key key, this.title, this.userId}) : super(key: key);
  final title;
  final userId;

  @override
  _MyAttentionsAndFansState createState() {
    return _MyAttentionsAndFansState();
  }
}

class _MyAttentionsAndFansState extends State<MyAttentionsAndFans> {
  List<UserInfo> userInfoList = new List();
  double height, width;
  String userId, title;
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
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    userId = widget.userId.toString();
    title = widget.title.toString();
    Map<String, dynamic> data = {
      "userId": userId
    };
    if(title == "我的粉丝") {
      List<UserInfo> l = new List();
      DioRequest.dioPost(URL.FANS_LIST_VIEW, data).then((result) {
        UserInfo userInfo;
        for(Map<String, dynamic> map in result.data) {
          userInfo = UserInfo.formJson(map);
          l.add(userInfo);
        }
        setState(() {
          l;
        });
        userInfoList = l;
      });
    } else if(title == "我的关注") {
      List<UserInfo> l = new List();
      DioRequest.dioPost(URL.ATTENTIONS_LIST_VIEW, data).then((result) {
        UserInfo userInfo;
        for(Map<String, dynamic> map in result.data) {
          userInfo = UserInfo.formJson(map);
          l.add(userInfo);
          setState(() {
            l;
          });
          userInfoList = l;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(title: Text(widget.title), centerTitle: true,),
      body: (userInfoList == null || userInfoList.length == 0) ? Center(
        child: Center(
          child: Text('没有数据'),
        ),
      ) : ListView.separated(
        itemCount: userInfoList.length,
        itemBuilder: (context, index) {
          return userInfoDiv(userInfoList[index], context);
        },
        separatorBuilder: (context, index) => Divider(height: .0),
      )
    );
  }

  Widget userInfoDiv(UserInfo userInfo, BuildContext context) {
    return Container(
      //decoration: BoxDecoration(border: ),
      height: 80,
      child: InkWell(
        child:  Row(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(10),
              child: userInfo.userAvatar == null ?  Image.asset('images/ic_avatar_default.png', width: 60.0, height: 60.0,)
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
            ),
            Container(
              height: 80,
              width: 0.6 * width,
              child: Column(
                children: <Widget>[
                  Container(
                    alignment: Alignment.topLeft,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      verticalDirection: VerticalDirection.up,
                      children: <Widget>[
                        Container(
                          alignment: Alignment.topLeft,
                          padding: EdgeInsets.fromLTRB(0, 14, 0, 0),
                          child: (userInfo == null || userInfo.sex == null) ? Container(child: Icon(IconData(0xe605, fontFamily: 'MyIcon',)),) :
                          Icon(userInfo.sex == '女' ? IconData(0xe605, fontFamily: 'MyIcon',) : IconData(0xe606, fontFamily: 'MyIcon',),
                            size: 20, color: userInfo.sex == '女' ? Colors.pink : Colors.blueAccent,),
                        ),
                        Container(
                          padding: EdgeInsets.fromLTRB(0, 14, 0, 0),
                          child: userInfo == null? null : Text((userInfo.userName == null ? null : userInfo.userName) +
                              '  ' + (userInfo.age == null ? null: userInfo.age.toString()),
                            style: TextStyle(color: Colors.black, fontSize: 16.0),),
                        ),
                      ],
                    ),
                  ),
                  userInfo.introduction == null ? Container(child: null,) :
                  Container(
                    alignment: Alignment.topLeft,
                    padding: EdgeInsets.fromLTRB(5, 10, 0, 0),
                    child: Text(userInfo.introduction, style: TextStyle(color: Colors.grey, fontSize: 14,),
                      maxLines: 1, overflow: TextOverflow.ellipsis,),
                  )
                ],
              ),
            )
          ],
        ),
        onTap: () {
          Navigator.push(context, MaterialPageRoute(
            builder: (context) => UserInfoPage(authorId: userInfo.userId, looker: userId,)
          ));
        },
      )
    );
  }
}