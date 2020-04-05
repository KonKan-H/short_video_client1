import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

void main() => runApp(selectImag());

class selectImag extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
            body: Container(
              child: Center(
                child: Column(
                  children: <Widget>[
                    RaisedButton(
                      onPressed: _getVideo,
                      child: Text("选取视频"),
                    ),
                    RaisedButton(
                      onPressed: _takeVideo,
                      child: Text("拍摄视频"),
                    ),
                  ],
                ),
              ),
            )));
  }

  /*选取视频*/
  _getVideo() async {
    var image = await ImagePicker.pickVideo(source: ImageSource.gallery);
    print('选取视频：' + image.toString() + '================');
  }
  /*拍摄视频*/
  _takeVideo() async {
    var image = await ImagePicker.pickVideo(source: ImageSource.camera);
    print('拍摄视频：' + image.toString() + '================');
  }

}

