import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/models/User.dart';

class UserUntil{
  static const USER_ID = 'user_id';
  static const USER_NAME = 'user_name';
  static const USER_AVATAR = 'user_avatar';
  static const USER_MOBILEPHONE = 'user_mobile_phone';
  static const USER_TOKEN_TYPE = 'user_token_type';
  static const USER_EXPIRES_IN = 'user_expires_in';
  static const USER_COOKIE = 'user_cookie';

  //保存用户信息
  static void saveUserInfo(UserInfo user) async {
    if(user != null){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt(USER_ID, user.id);
      sharedPreferences.setString(USER_NAME, user.userName);
      sharedPreferences.setString(USER_MOBILEPHONE, user.mobilePhone);
      sharedPreferences.setString(USER_AVATAR, user.userAvatar);
    }
  }

  //清楚用户信息
  static Future<void> cleanUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(USER_ID, null);
    sharedPreferences.setString(USER_NAME, null);
    sharedPreferences.setString(USER_MOBILEPHONE, null);
    sharedPreferences.setString(USER_AVATAR, null);
    saveUserInfo(null);
    OsApplication.cookie = null;
  }

  //获取用户信息
  static Future<UserInfo> getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int id = sharedPreferences.getInt(USER_ID);
    String userName = sharedPreferences.getString(USER_NAME);
    String userAvatar = sharedPreferences.getString(USER_AVATAR);
    String mobilePhone = sharedPreferences.getString(USER_MOBILEPHONE);
    return UserInfo(id, userName, userAvatar, mobilePhone);
  }

  //把map转为User
  static Future<UserInfo> map2User(Map<String, dynamic> map) async {
    if(map != null) {
      int id = map['id'];
      String userName = map['userName'];
      String mobilePhone = map['mobilePhone'];
      String userAvatar = map['userAvatar'];
      return UserInfo(id, userName, userAvatar, mobilePhone);
    } else {
      return null;
    }
  }

  //保存token
  static Future<void> saveToke(Map<String, dynamic> map) async {
    if(map != null) {
      String tokeType = map['token_type'];
      String expiresIn = map['expires_in'];
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(USER_TOKEN_TYPE, tokeType);
      sharedPreferences.setString(USER_EXPIRES_IN, expiresIn);
    }
 }

  //保存cookie
  static void saveCookie(String cookie) async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString(USER_COOKIE, cookie);
  }

  //取得cookie
  static Future<String> getCookie() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String cookie = sharedPreferences.getString(USER_COOKIE);
    return cookie;
  }
}