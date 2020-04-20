import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/models/User.dart';

class UserUntil{
  static const USER_ID = 'user_id';
  static const USER_NAME = 'user_name';
  static const USER_AVATAR = 'user_avatar';
  static const USER_MOBILE_PHONE = 'user_mobile_phone';
  static const USER_TOKEN_TYPE = 'user_token_type';
//  static const USER_EXPIRES_IN = 'user_expires_in';
  static const USER_COOKIE = 'user_cookie';

  //保存用户信息
  static void saveUserInfo(User user) async {
    if(user != null){
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setInt(USER_ID, user.id);
      sharedPreferences.setString(USER_NAME, user.userName);
      sharedPreferences.setString(USER_MOBILE_PHONE, user.mobilePhone);
      sharedPreferences.setString(USER_AVATAR, user.userAvatar);
    }
  }

  //清除用户信息
  static Future<void> cleanUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setInt(USER_ID, null);
    sharedPreferences.setString(USER_NAME, null);
    sharedPreferences.setString(USER_MOBILE_PHONE, null);
    sharedPreferences.setString(USER_AVATAR, null);
    sharedPreferences..setString(USER_TOKEN_TYPE, null);
    saveUserInfo(null);
    OsApplication.cookie = null;
  }

  //获取用户信息
  static Future<User> getUserInfo() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    int id = sharedPreferences.getInt(USER_ID);
    String userName = sharedPreferences.getString(USER_NAME);
    String userAvatar = sharedPreferences.getString(USER_AVATAR);
    String mobilePhone = sharedPreferences.getString(USER_MOBILE_PHONE);
    return User(id, userName, userAvatar, mobilePhone);
  }

  //把map转为User
  static Future<User> map2User(Map<String, dynamic> map) async {
    if(map != null) {
      int id = map['id'];
      String userName = map['userName'];
      String mobilePhone = map['mobilePhone'];
      String userAvatar = map['userAvatar'];
      return User(id, userName, userAvatar, mobilePhone);
    } else {
      return null;
    }
  }

  //保存token
  static Future<void> saveToke(Map<String, dynamic> map) async {
    if(map != null) {
      String tokeType = map['access_token'];
//      String expiresIn = map['expires_in'];
      SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
      sharedPreferences.setString(USER_TOKEN_TYPE, tokeType);
//      sharedPreferences.setString(USER_EXPIRES_IN, expiresIn);
    }
 }

 //取得token
  static Future<String> getToken() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    String token = sharedPreferences.get(USER_TOKEN_TYPE);
    return token;
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