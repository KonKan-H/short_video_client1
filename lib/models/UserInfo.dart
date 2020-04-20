import 'package:short_video_client1/models/User.dart';

class UserInfo {
  var id;
  var userId;
  var age;
  var userName;
  var userAvatar;
  var mobilePhone;
  var sex;
  var area;
  var introduction;
  var fans;
  var attentions;
  var accessToken;
  int pageSize;
  int currentPage = 1;

  UserInfo();

  factory UserInfo.formJson(Map<String, dynamic> map) {
    UserInfo userInfo = new UserInfo();
    userInfo.id = map['id'];
    userInfo.userId = map['userId'];
    userInfo.age = map['age'];
    userInfo.userName = map['userName'];
    userInfo.mobilePhone = map['userMobilePhone'];
    userInfo.userAvatar = map['userAvatar'];
    userInfo.sex = map['sex'];
    userInfo.area = map['area'];
    userInfo.introduction = map['introduction'];
    userInfo.fans = map['fans'];
    userInfo.attentions = map['attentions'];
    userInfo.accessToken = map['accessToken'];
    userInfo.pageSize = map['pageSize'];
    userInfo.currentPage = map['currentPage'];
    return userInfo;
  }
}