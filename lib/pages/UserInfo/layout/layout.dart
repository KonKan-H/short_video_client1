import 'package:flutter/material.dart';

//标题
Padding buildTitleLine(double len) {
  return Padding(
    padding: EdgeInsets.only(left: 12.0, top: 4.0),
    child: Align(
      alignment: Alignment.bottomLeft,
      child: Container(
        color: Colors.black,
        width: len,
        height: 2.0,
      ),
    ),
  );
}

//下划线
Padding buildTitle(String title) {
  return Padding(
    padding: EdgeInsets.all(8.0),
    child: Text(
      title,
      style: TextStyle(fontSize: 42.0),
    ),
  );
}

//手机号输入框
TextFormField buildPhoneTextField(String _mobilePhone) {
  return TextFormField(
    decoration: InputDecoration(
      labelText: 'MobilePhone',
    ),
    validator: (String value) {
      var phoneReg = RegExp(
          r"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$");
      if (!phoneReg.hasMatch(value)) {
        return '请输入正确的手机号';
      }
    },
    onSaved: (String value) => _mobilePhone = value,
  );
}