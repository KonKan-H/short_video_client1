import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
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

  @override
  void initState() {
    _getUserInfo();
    super.initState();
    print(userId + "=====================");
  }

  _getUserInfo() async {
    Map<String, dynamic> data = {
      "userId" : userId
    };
    Result result = await DioRequest.dioPost(URL.GET_USER_INFO, data);
    userInfo = await UserInfoUntil.map2UserInfo(result.data);
    print("======");
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Scaffold(
        appBar: AppBar(

        ),
      ),
    );
  }

}