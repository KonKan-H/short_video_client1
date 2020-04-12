import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
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
          child: BottomReplyBar(pCtx: pCtx, video: video),
        ),
        body: SingleChildScrollView(
            controller: controller,
            child: Container(
              child: genReplyList(replies, controller, video, userId, pCtx),
            )));
  }
}

class ReplyList extends StatelessWidget {
  ReplyList({Key key, this.reply, this.controller, this.video, this.userId, this.context}) : super(key: key);
  final Reply reply;
  final Video video;
  final userId;
  final ScrollController controller;
  final BuildContext context;

  bool ifDelete;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    var replies = reply.afterReplies;
    // RecommendProvider provider=Provider.of<RecommendProvider>(context);
    return Container(
      height: rpx * 750,
      //decoration: BoxDecoration(color: Colors.cyanAccent),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Material(
            child: InkWell(
              child: Row(
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
                              TextSpan(text: " " + TsUtils.dateDeal(reply.replyTime), style: TextStyle(color: Colors.grey[500], fontSize: 12),)
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
              onTap: () {

              },
              onLongPress: () {

              },
            ),
          ),
          genAfterReplyList(reply.afterReplies, controller, video)
        ],
      ),
    );
  }

//  showCupertinoAlertDialog(Video video, BuildContext context) {
//    showDialog(
//        context: context,
//        builder: (BuildContext context) {
//          return CupertinoAlertDialog(
//            title: Text("是否删除该视频"),
//            content: Column(
//              children: <Widget>[
//                SizedBox(
//                  height: 10,
//                ),
//                Align(
//                  child: Text(video.description == null ? "" : video.description.toString(), maxLines: 1,
//                    overflow: TextOverflow.ellipsis,),
//                  alignment: Alignment(0, 0),
//                ),
//              ],
//            ),
//            actions: <Widget>[
//              CupertinoDialogAction(
//                child: Text("取消"),
//                onPressed: () {
//                  Navigator.pop(context);
//                },
//              ),
//              CupertinoDialogAction(
//                child: Text("确定"),
//                onPressed: () {
//                  DioRequest.dioPost(URL.REPLY_DELETE, Video.model2map(video)).then((result) {
//                    bool flag = result.data as bool;
//                    if(flag) {
//                      ifDelete = flag;
//                    }
//                  });
//                  Navigator.pop(context);
//                },
//              ),
//            ],
//          );
//        });
//  }
}

class AfterReply extends StatelessWidget {
  const AfterReply({Key key, this.afterReply, this.video}) : super(key: key);
  final Reply afterReply;
  final Video video;
  @override
  Widget build(BuildContext context) {
    double rpx = MediaQuery.of(context).size.width / 750;
    return Container(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Material(
            child: InkWell(
              child: Row(
                children: <Widget>[
                  Container(
                    width: 100 * rpx,
                  ),
                  Container(
                    width: 550 * rpx,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Material(
                          child: InkWell(
                            child: Container(
                              width: 70 * rpx,
                              height: 70 * rpx,
                              margin: EdgeInsets.only(top: 15 * rpx),
                              padding: EdgeInsets.all(10 * rpx),
                              child: CircleAvatar(
                                backgroundImage:
                                NetworkImage(ConstantData.AVATAR_FILE_URI + "${afterReply.replyMakerAvatar}"),
                              ),
                            ),
                            onTap: () {
                              if(afterReply.replyMakerId == video.looker) {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => MyVideoList(userId: video.looker, couldDelete: true)
                                ));
                              } else {
                                Navigator.push(context, MaterialPageRoute(
                                    builder: (context) => UserInfoPage(authorId : afterReply.replyMakerId, looker: video.looker,)
                                ));
                              }
                            },
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
                                    TextSpan(text: " " + TsUtils.dateDeal(afterReply.replyTime), style: TextStyle(color: Colors.grey[500], fontSize: 12),)
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
              ),
              onLongPress: () {

              },
            ),
          )
        ],
      ),
    );
  }
}

genReplyList(List<Reply> replies, ScrollController controller, Video video, String userId, BuildContext context) {
  return ListView.builder(
    shrinkWrap: true,
    controller: controller,
    itemCount: replies.length,
    itemBuilder: (context, index) {
      return ReplyList(
        reply: replies[index],
        controller: controller,
        video: video,
        userId: userId,
        context: context,
      );
    },
  );
}

genAfterReplyList(List<Reply> replies, ScrollController controller, Video video) {
  if(replies == null || replies.length == 0) {
    return null;
  }
  return ListView.builder(
    shrinkWrap: true,
    controller: controller,
    itemCount: replies.length <= 2 ? replies.length : 2,
    itemBuilder: (context, index) {
      return AfterReply(
        afterReply: replies[index],
        video: video,
      );
    },
  );
}

class BottomReplyBar extends StatelessWidget {
  const BottomReplyBar({Key key,this.pCtx, this.video}) : super(key: key);
  final BuildContext pCtx;
  final Video video;
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
          onPressed: () async {
            if(_controller.text == null || _controller.text.length == 0) {
              TsUtils.showShort("评论内容为空");
              return;
            }
            Reply reply = Reply();
            reply.replyContent = _controller.text;
            reply.replyMakerId = video.looker.toString();
            reply.replyVideoId = video.id.toString();
            reply.videoAuthorId = video.authorId.toString();
            Result result = await DioRequest.dioPut(URL.COMMENT_VIDEO, Reply.model2map(reply));
            TsUtils.showShort("评论成功");
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
