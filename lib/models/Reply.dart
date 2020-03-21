class Reply {
  String replyMakerName;
  String replyMakerAvatar;
  String replyContent;
  String whenReplied;
  bool ifFaved;
  List<Reply> afterReplies;

  Reply(
      {this.ifFaved,
        this.afterReplies,
        this.replyContent,
        this.replyMakerAvatar,
        this.replyMakerName,
        this.whenReplied});
}
