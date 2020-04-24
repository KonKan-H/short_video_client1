import 'dart:convert';
import 'package:convert/convert.dart';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:progress_dialog/progress_dialog.dart';

class TsUtils{
  /// md5 加密
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

  ///数字处理
  static String dataDeal(int data) {
    if(data == null) {
      return 0.toString();
    }
    if(data > 9999) {
      return (data/1000).toString().substring(0, (data/1000).toString().length-2) + 'w';
    }
    return data.toString();
  }

  ///日期处理
  static String dateDeal(String dateString) {
    DateTime dateTime = DateTime.parse(dateString).toLocal();
    var format = new DateFormat("MM-dd HH:mm:ss");
    return format.format(dateTime);
  }

  ///小弹窗
  static ProgressDialog showProgressDiolog(BuildContext context, String text) {
    ProgressDialog pr;
    pr = new ProgressDialog(context);
    pr = ProgressDialog(context,type: ProgressDialogType.Normal, isDismissible: false, showLogs: true);
    pr.style(
        message: text,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        progress: 0.0,
        maxProgress: 100.0,
        progressTextStyle: TextStyle(
            color: Colors.black, fontSize: 13.0, fontWeight: FontWeight.w400),
        messageTextStyle: TextStyle(
            color: Colors.black, fontSize: 19.0, fontWeight: FontWeight.w600)
    );
    return pr;
  }

}
