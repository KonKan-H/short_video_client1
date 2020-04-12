import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class TsUtils{
  // md5 加密
  static String generateMd5(String data) {
    var content = new Utf8Encoder().convert(data);
    var digest = md5.convert(content);
    // 这里其实就是 digest.toString()
    return hex.encode(digest.bytes);
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

  static void logError(String code, [String message = ""]) =>
      print('Error: $code\nError Message: $message');

  static void logInfo(String message) =>
      print('Info: {Infor Message: $message }');

  static String dataDeal(int data) {
    if(data == null) {
      return 0.toString();
    }
    if(data > 9999) {
      return (data/1000).toString().substring(0, (data/1000).toString().length-2) + 'w';
    }
    return data.toString();
  }

  static String dateDeal(String dateString) {
    DateTime dateTime = DateTime.parse(dateString);
//    String date = dateTime.toString();
    var format = new DateFormat("MM-dd HH:mm:ss");
    return format.format(dateTime);
  }


}
