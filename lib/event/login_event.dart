import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/resources/until/user_info_until.dart';

class LoginEvent {
  var userName;
  var userAvatar;
  var sex;
  var area;
  var introduction;
  var age;
  var userId;

  LoginEvent(this.userId, this.userName, this.userAvatar, this.area, this.sex, this.age, this.introduction);
}