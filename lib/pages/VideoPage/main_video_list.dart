import 'package:flutter/material.dart';
import 'package:short_video_client1/pages/VideoPage/hot_video_list.dart';
import 'package:short_video_client1/pages/VideoPage/hot_video_list_page.dart';
import 'package:short_video_client1/pages/VideoPage/video_list_page.dart';
import 'package:short_video_client1/resources/strings.dart';

class MainVideoList extends StatelessWidget{
    @override
    Widget build(BuildContext context){
        return new DefaultTabController(//DefaultTabController
            length: 2,
            child: Scaffold(
                appBar: AppBar(
                    backgroundColor: ConstantData.MAIN_COLOR,
                    title: TabBar(
                        tabs: <Widget>[
                            Tab(child: Text('热门', style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),),),
                            Tab(child: Text('推荐', style: TextStyle(fontWeight: FontWeight.w100, fontSize: 14),),),
                        ],
                    )
                ),
            body: TabBarView(
            children: <Widget>[
                Container(
                        child: HotVideoListPage(),//TabCar对应tab_transit.dart的Class name
                ),
                Container(
                    child: VideoListPage(), //TabCar对应tab_car.dart的Class name
            )
            ],
           ),
          ),
        );
    }
}