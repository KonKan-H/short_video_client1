import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Reply.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/Video.dart';
import 'package:short_video_client1/pages/VideoPage/my_video_list.dart';
import 'package:short_video_client1/pages/common/user_info_page.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';

class ReplyFullList extends StatelessWidget {
  ReplyFullList({Key key,this.pCtx, this.video, this.replies, this.userId}) : super(key: key);
  final BuildContext pCtx;
  final Video video;
  final userId;
  List<Reply> replies = List();

  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
//    RecommendProvider provider = Provider.of<RecommendProvider>(pCtx);
//    Reply reply = provider.reply;
//    replies.add(reply);
//    replies.add(reply);
//    replies.add(reply);
    ScrollController controller = ScrollController();
    return Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(80*rpx),
          child: AppBar(
            leading: Container(),
            elevation:0,
            backgroundColor: Colors.grey[50],
            actions: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.close,
                  color: Colors.black,
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
              )
            ],
            title: Text(
                ((video.comments == null || video.comments == 0) ? '0' : video.comments.toString()) + "条评论",
              style: TextStyle(color: Colors.grey[700], fontSize: 25 * rpx, fontWeight: FontWeight.w700),
            ),
            centerTitle: true,
            // elevation: 1,
          )
        ),
        bottomNavigationBar: SafeArea(
          child: BottomReplyBar(pCtx: pCtx,),
        ),
        body: SingleChildScrollView(
            controller: controller,
            child: Container(
              child: genReplyList(replies, controller, video, userId),
            )));
  }
}

class ReplyList extends StatelessWidget {
  const ReplyList({Key key, this.reply, this.controller, this.video, this.userId}) : super(key: key);
  final Reply reply;
  final Video video;
  final userId;
  final ScrollController controller;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    List<Reply> replies = List<Reply>();
    replies.add(reply);
    replies.add(reply);
    replies.add(reply);
    // RecommendProvider provider=Provider.of<RecommendProvider>(context);
    return Container(
      height: rpx * 750,
      //decoration: BoxDecoration(color: Colors.cyanAccent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Material(
                child: InkWell(
                  child: Container(
                    width: 100 * rpx,
                    height: 100 * rpx,
                    padding: EdgeInsets.all(10 * rpx),
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(ConstantData.AVATAR_FILE_URI + "${reply.replyMakerAvatar}"),
                    ),
                  ),
                  onTap: () {
                    if(reply.replyMakerId == video.looker) {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => MyVideoList(userId: video.looker, couldDelete: true)
                      ));
                    } else {
                      Navigator.push(context, MaterialPageRoute(
                          builder: (context) => UserInfoPage(authorId : reply.replyMakerId, looker: video.looker,)
                      ));
                    }
                  },
                ),
              ),
              Container(
                width: 480 * rpx,
                child: ListTile(
                  title: Text("${reply.replyMakerName}", style: TextStyle(color: Colors.grey[500]),),
                  subtitle: RichText(
                    text: TextSpan(
                        text: "${reply.replyContent}",
                        style: TextStyle(color: Colors.black, fontSize: 14),
                        children: [
                          //TextSpan(text: , style: TextStyle(color: Colors.grey[500]),)
                        ]),
                  ),

                  // Text(
                  //   "${afterReply.replyContent}",
                  //   maxLines: 2,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                ),
              ),
              Container(
                width: 100 * rpx,
                alignment: Alignment.topRight,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.grey[300],
                  ),
                ),
              )
            ],
          ),
          genAfterReplyList(replies, controller)
        ],
      ),
    );
  }
}

class AfterReply extends StatelessWidget {
  const AfterReply({Key key, this.afterReply}) : super(key: key);
  final Reply afterReply;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 100 * rpx,
              ),
              Container(
                width: 550 * rpx,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 70 * rpx,
                      height: 70 * rpx,
                      margin: EdgeInsets.only(top: 15 * rpx),
                      padding: EdgeInsets.all(10 * rpx),
                      child: CircleAvatar(
                        backgroundImage:
                            NetworkImage(ConstantData.AVATAR_FILE_URI + "${afterReply.replyMakerAvatar}"),
                      ),
                    ),
                    Container(
                      width: 480 * rpx,
                      child: ListTile(
                        title: Text("${afterReply.replyMakerName}"),
                        subtitle: RichText(
                          text: TextSpan(
                              text: "${afterReply.replyContent}",
                              style: TextStyle(color: Colors.grey[500]),
                              children: [
                                //TextSpan(text: TsUtils.dateDeal(afterReply.replyTime))
                              ]),
                        ),

                        // Text(
                        //   "${afterReply.replyContent}",
                        //   maxLines: 2,
                        //   overflow: TextOverflow.ellipsis,
                        // ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                width: 100 * rpx,
                child: IconButton(
                  onPressed: () {},
                  icon: Icon(
                    Icons.favorite,
                    color: Colors.grey[300],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}

genReplyList(List<Reply> replies, ScrollController controller, Video video, String userId) {
  return ListView.builder(
    shrinkWrap: true,
    controller: controller,
    itemCount: replies.length,
    itemBuilder: (context, index) {
      return ReplyList(
        reply: replies[index],
        controller: controller,
        video: video,
        userId: userId
      );
    },
  );
}

genAfterReplyList(List<Reply> replies, ScrollController controller) {
  return ListView.builder(
    shrinkWrap: true,
    controller: controller,
    itemCount: replies.length <= 2 ? replies.length : 2,
    itemBuilder: (context, index) {
      return AfterReply(
        afterReply: replies[index],
      );
    },
  );
}

class BottomReplyBar extends StatelessWidget {
  const BottomReplyBar({Key key,this.pCtx}) : super(key: key);
  final BuildContext pCtx;
  @override
  Widget build(BuildContext context) {
    TextEditingController _controller=TextEditingController();
    double toBottom=MediaQuery.of(context).viewInsets.bottom;
    double rpx=MediaQuery.of(context).size.width/750;
    return Container(
      padding: EdgeInsets.only(bottom: toBottom),
      decoration: BoxDecoration(border: Border(top: BorderSide(color: Colors.grey[200],width: 1))),
      child: Row(children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.only(left: 30*rpx),
            // width: 600*rspx,
            child: TextField(
              controller: _controller,
              decoration: InputDecoration(hintText: "留下你的精彩评论",border: InputBorder.none),
              obscureText: false,
            ),
          )
        ),
        //IconButton(icon: Icon(Icons.email,color: Colors.grey[500],size: 50*rpx,),onPressed: (){showAtFriendPage(pCtx);},),
        IconButton(icon: Icon(Icons.face,color: Colors.grey[500],size: 50*rpx),
          onPressed: (){
          TsUtils.showShort(_controller.text);
        },),
        SizedBox(width: 20*rpx,)
      ],),
    );
  }
}

//showAtFriendPage(BuildContext context){
//  Navigator.of(context).push(new MaterialPageRoute(
//      builder: (BuildContext context) {
//        return  MultiProvider(
//          providers: [ChangeNotifierProvider(builder:(context)=>AtUserProvider())],
//          child: AtFriendPage()
//        );
//      },
//    fullscreenDialog: true
//  ));
//}
