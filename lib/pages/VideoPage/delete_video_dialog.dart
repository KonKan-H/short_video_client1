import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Video.dart';

class DeleteVideoDialog extends StatelessWidget {
  DeleteVideoDialog({Key key, this.video}) : super(key: key);
  Video video;

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return showCupertinoAlertDialog(context);
  }

  showCupertinoAlertDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return CupertinoAlertDialog(
            title: Text("是否删除该视频"),
            content: Column(
              children: <Widget>[
                SizedBox(
                  height: 10,
                ),
                Align(
                  child: Text(video.comments, maxLines: 1, overflow: TextOverflow.ellipsis,),
                  alignment: Alignment(0, 0),
                ),
              ],
            ),
            actions: <Widget>[
              CupertinoDialogAction(
                child: Text("取消"),
                onPressed: () {
                  Navigator.pop(context);
                  print("取消");
                },
              ),
              CupertinoDialogAction(
                child: Text("确定"),
                onPressed: () {
                  print("确定");
                },
              ),
            ],
          );
        });
  }
}
