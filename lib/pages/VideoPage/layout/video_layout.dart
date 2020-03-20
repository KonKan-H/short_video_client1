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

class BtnContent extends StatelessWidget {
  BtnContent({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: <Widget>[
          ListTile(title: Text("@人民日报", style: TextStyle(color: Colors.white),),
            subtitle: Text("自从武汉决定迅速建设火神山医院和雷神山医院以来，自从武汉决定迅速建设火神山医院和雷神山医院以来中联重科第一时间响应。",
              style: TextStyle(color: Colors.white), maxLines: 3, overflow: TextOverflow.ellipsis,),),
          Row(children: <Widget>[
            SizedBox(width: 10,),
            Icon(Icons.music_note),
            //Marquee(text: "一方有难 八方支援：湖南上市公司积极参与新型肺炎抗击战",)
          ],
          ),
        ],
      ),
    );
  }
}

Widget titleSection = Column(
  children: <Widget>[
    Container(
      alignment: Alignment.topLeft,
      padding: const EdgeInsets.all(4),
      child: Text('@人民日报', style: TextStyle(color: Colors.white, fontSize: 17, decoration: TextDecoration.none),),
    ),
    Container(
      padding: const EdgeInsets.fromLTRB(4, 0,  0, 0),
      alignment: Alignment.topLeft,
      child: Text('自从武汉决定迅速建设火神山医院和雷神山医院以来，'
          '自从武汉决定迅速建设火神山医院和雷神山医院以来中联重科第一时间响应。',
        style: TextStyle(color: Colors.white, fontSize: 14, decoration: TextDecoration.none),
        maxLines: 4, overflow: TextOverflow.ellipsis,),
    ),
  ],
);
