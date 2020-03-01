import 'dart:convert';
import 'dart:ui';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:short_video_client1/http/url_string.dart';
import 'package:short_video_client1/models/Result.dart';
class TsUtils{
  // md5 加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
  }

  static Future<Result> dioPost(String url, Map<String, dynamic> data) async {
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.post(URL.url_base + url, data: data);
    Result result = Result.formJson(json.decode(response.data));
    return result;
  }

  static showShort(String msg){
    Fluttertoast.showToast(
        msg: msg,
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0
    );
  }
}
