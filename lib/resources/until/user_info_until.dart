import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:short_video_client1/models/UserInfo.dart';

class UserInfoUntil{
  static const USER_INFO_ID = 'user_info_id';
  static const USER_INFO_USER_ID = 'user_info_user_id';
  static const USER_INFO_NAME = 'user_info_name';
  static const USER_INFO_MOBILE_PHONE = 'user_info_mobile_phone';
  static const USER_INFO_AVATAR = 'user_info_avatar';
  static const USER_INFO_SEX = 'user_info_sex';
  static const USER_INFO_AREA = 'user_info_area';
  static const USER_INFO_INTRODUCTION = 'user_info_introduction';
  static const USER_INFO_AGE = 'user_info_age';

  //存储userInfo
  static void saveUserInfo(UserInfo userInfo) async {
    if(userInfo != null) {
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt(USER_INFO_ID, userInfo.id);
      sharedPreferences.setInt(USER_INFO_USER_ID, userInfo.userId);
      sharedPreferences.setString(USER_INFO_NAME, userInfo.userName);
      sharedPreferences.setString(USER_INFO_MOBILE_PHONE, userInfo.mobilePhone);
      sharedPreferences.setString(USER_INFO_AVATAR, userInfo.userAvatar);
      sharedPreferences.setString(USER_INFO_SEX, userInfo.sex);
      sharedPreferences.setString(USER_INFO_AREA, userInfo.area);
      sharedPreferences.setString(USER_INFO_INTRODUCTION, userInfo.introduction);
      sharedPreferences.setString(USER_INFO_AGE, userInfo.age.toString());
    } else {
      return null;
    }
  }

  //清除用户信息
  static void cleanUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(USER_INFO_ID, null);
    sharedPreferences.setInt(USER_INFO_USER_ID, null);
    sharedPreferences.setString(USER_INFO_NAME, null);
    sharedPreferences.setString(USER_INFO_MOBILE_PHONE, null);
    sharedPreferences.setString(USER_INFO_AVATAR, null);
    sharedPreferences.setString(USER_INFO_SEX, null);
    sharedPreferences.setString(USER_INFO_AREA, null);
    sharedPreferences.setString(USER_INFO_INTRODUCTION, null);
    sharedPreferences.setString(USER_INFO_AGE, null);
    saveUserInfo(null);
  }

  //取得用户信息
  static Future<UserInfo> getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    UserInfo userInfo = new UserInfo();
    userInfo.id = sharedPreferences.getInt(USER_INFO_ID);
    userInfo.userId = sharedPreferences.getInt(USER_INFO_USER_ID);
    userInfo.userName = sharedPreferences.getString(USER_INFO_NAME);
    userInfo.mobilePhone = sharedPreferences.getString(USER_INFO_MOBILE_PHONE);
    userInfo.userAvatar = sharedPreferences.getString(USER_INFO_AVATAR);
    userInfo.sex = sharedPreferences.getString(USER_INFO_SEX);
    userInfo.area = sharedPreferences.getString(USER_INFO_AREA);
    userInfo.introduction = sharedPreferences.getString(USER_INFO_INTRODUCTION);
    userInfo.age = sharedPreferences.get(USER_INFO_AGE);
    return userInfo;
  }

  //map转UserInfo
  static Future<UserInfo> map2UserInfo(Map<String, dynamic> map)  async {
    if(map != null) {
      UserInfo userInfo = new UserInfo();
      userInfo.id = map['id'];
      userInfo.userId = map['userId'];
      userInfo.age = map['age'];
      userInfo.userName = map['userName'];
      userInfo.mobilePhone = map['userMobilePhone'];
      userInfo.userAvatar = map['user'];
      userInfo.sex = map['sex'];
      userInfo.area = map['area'];
      userInfo.introduction = map['introduction'];
      return userInfo;
    } else {
      return null;
    }
  }
}