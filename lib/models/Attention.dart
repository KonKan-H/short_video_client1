class Attention {
  var userId;
  var fansId;
  var dateTime;

  Attention({
    this.userId,
    this.fansId,
    this.dateTime
  });

  factory Attention.formJson(Map<String, dynamic> json) {
    return new Attention(
        userId: json['userId'],
        fansId: json['fansId'],
        dateTime: json['dateTime']
    );
  }

  static Map<String, dynamic> model2map(Attention attention) {
    Map<String, dynamic> map = {
      'userId': attention.userId,
      'fansId': attention.fansId,
      'dateTime': attention.dateTime
    };
    return map;
  }
}