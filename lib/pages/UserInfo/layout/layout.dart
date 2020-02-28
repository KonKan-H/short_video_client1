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
