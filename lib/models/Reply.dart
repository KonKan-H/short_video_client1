import 'dart:convert';

class Reply {
  String id;
  String replyId;
  String replyVideoId;
  String videoAuthorId;
  String replyMakerId;
  String replyMakerName;
  String replyMakerAvatar;
  String replyContent;
  String replyTime;
  String ifFaved;
  List<Reply> afterReplies;

  Reply({this.ifFaved,
        this.afterReplies,
        this.replyContent,
        this.replyMakerAvatar,
        this.replyMakerName,
        this.replyTime,
        this.replyVideoId,
        this.replyMakerId,
        this.id,
        this.replyId,
        this.videoAuthorId,
      });

  factory Reply.formJson(Map<String, dynamic> map) {
    Reply reply = new Reply(
      ifFaved: map['ifFaved'],
      afterReplies: null,
      replyContent: map['replyContent'],
      replyMakerAvatar: map['replyMakerAvatar'],
      replyMakerName: map['replyMakerName'],
      replyTime: map['replyTime'],
      videoAuthorId: map['videoAuthorId'].toString(),
      replyVideoId: map['replyVideoId'].toString(),
      replyMakerId: map['replyMakerId'].toString(),
      id: map['id'].toString(),
      replyId: map['replyId'].toString(),
    );
    print(map['afterReplies']);
    reply.afterReplies = map['afterReplies'] != null ? map2list(map['afterReplies']) : null;
    return reply;
  }

  static List<Reply> map2list(List l) {
    List<Reply> list = l.map((m) => new Reply.formJson(m)).toList();
    return list;
  }

  static Map<String, dynamic> model2map(Reply reply) {
    Map<String, dynamic> map = {
      'ifFaved':reply.ifFaved,
      'afterReplies':reply.afterReplies,
      'replyContent':reply.replyContent,
      'replyMakerAvatar':reply.replyMakerAvatar,
      'replyMakerName':reply.replyMakerName,
      'replyTime':reply.replyTime,
      'replyVideoId':reply.replyVideoId,
      'replyMakerId':reply.replyMakerId,
      'id':reply.id,
      'replyId':reply.replyId,
      'videoAuthorId':reply.videoAuthorId,
    };
    return map;
  }
}
