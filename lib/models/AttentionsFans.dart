class AttentionsFans {
  var attentions;
  var fans;

  AttentionsFans({this.attentions, this.fans});

  factory AttentionsFans.formJson(Map<String, dynamic> json) {
    return AttentionsFans(
      attentions: json['attentions'],
      fans: json['fans']
    );
  }

}