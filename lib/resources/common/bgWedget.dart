import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/FollowingVideo/following_bj.dart';

Widget bgWidget(String msg) {
  return Stack(
    fit: StackFit.expand,
    children: <Widget>[
      Image.asset('images/bj.png', fit: BoxFit.cover,),
      Center(
        child: BlurRectWidget(
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                msg,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
//                Padding(
//                  padding: const EdgeInsets.only(top: 5.0),
//                  child: Text(
//                    "请先登录",
//                    style: TextStyle(fontSize: 14, color: Colors.black87),
//                    textAlign: TextAlign.justify,
//                  ),
//                ),
            ],
          ),
        ),
      ),
    ],
  );
}