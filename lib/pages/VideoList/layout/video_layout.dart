import 'package:flutter/material.dart';

class IconText extends StatelessWidget {
  IconText({Key key, this.icon, this.text}) : super(key: key);
  final Icon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          icon,
          Text(text, style: TextStyle(color: Colors.white,fontSize: 13.0, decoration: TextDecoration.none), ),
        ],),
    );
  }
}

