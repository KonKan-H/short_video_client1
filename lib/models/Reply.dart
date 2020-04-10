class Reply {
  String id;
  String replyId;
  String replyVideoId;
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
      });

  factory Reply.formJson(Map<String, dynamic> map) {
    return new Reply(
      ifFaved: map['ifFaved'],
      afterReplies: map['afterReplies'],
      replyContent: map['replyContent'],
      replyMakerAvatar: map['replyMakerAvatar'],
      replyMakerName: map['replyMakerName'],
      replyTime: map['replyTime'],
      replyVideoId: map['replyVideoId'].toString(),
      replyMakerId: map['replyMakerId'].toString(),
      id: map['id'].toString(),
      replyId: map['replyId'].toString(),
    );
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
    };
    return map;
  }
}
