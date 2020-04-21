import 'package:flutter/material.dart';

class ConstantData{
//  static const String URL_BASE = 'http://10.20.8.155';
//  static const String URL_BASE = 'http://192.168.43.93';
  static const String URL_BASE = 'http://112.126.82.137';

  static const String URL_HEADER_PORT = URL_BASE + ":8080/";

  //主色调
  static const Color MAIN_COLOR = Colors.orange;

  static const String VIDEO_LOCALHOST = '/storage/emulated/0/DCIM/Camera';

  //视频长度
  static const double VIDEO_HEIGHT = 348;

  static const String VIDEO_URL_HEADER = "";

  //上传视频背景图
  static const String VIDEO_UPLOAD_PNG = 'https://timgsa.baidu.com/timg?image&quality=80&'
      'size=b9999_10000&sec=1586170924039&di=d3c12660ac06f99a740445ba23212766&'
      'imgtype=0&src=http%3A%2F%2Fwww.herocoming.com%2Fimg%2Fplus2_.png';

  //文件地址前缀
  static const String VIDEO_FILE_URI = URL_HEADER_PORT + "video/";
  static const String COVER_FILE_URI = URL_HEADER_PORT + "cover/";
  static const String AVATAR_FILE_URI = URL_HEADER_PORT + "avatar/";

  static const String appName = 'SV HUB';
  static const String logoTag = 'near.huscarl.loginsample.logo';
  static const String titleTag = 'near.huscarl.loginsample.title';
}