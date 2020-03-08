import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/resources/until/user_info_until.dart';

class LoginEvent {
  String userName;
  String userAvatar;
  String sex;
  String area;
  String introduction;
  int age;
  int userId;

  LoginEvent(this.userId, this.userName, this.userAvatar, this.age, this.sex, this.area, this.introduction);
}