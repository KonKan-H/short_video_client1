class Video{
  var id;
  var url;
  var authorName;
  var authorAvatar;
  var createTime;
  var authorId;
  var cover;
  var description;
  var duration;
  var likes;
  var downloads;
  var comments;
  var looker;

  Video({
    this.id,
    this.url,
    this.authorName,
    this.authorAvatar,
    this.createTime,
    this.authorId,
    this.cover,
    this.description,
    this.duration,
    this.likes,
    this.downloads,
    this.comments,
    this.looker
  });

  factory Video.formJson(Map<String, dynamic> json) {
    return new Video(
        id:json['id'],
        url:json['url'],
        authorName:json['authorName'],
        authorAvatar:json['authorAvatar'],
        createTime:json['createTime'],
        authorId:json['authorId'],
        cover:json['cover'],
        description:json['description'],
        duration:json['duration'],
        likes:json['likes'],
        downloads:json['downloads'],
        comments:json['comments'],
        looker:json['looker']
    );
  }

  static Map<String, dynamic> model2map(Video video) {
      Map<String, dynamic> map = {
      'id' : video.id,
      'authorId' : video.authorId,
      'url' : video.url,
      'authorName' : video.authorName,
      'authorAvatar' : video.authorAvatar,
      'createTime' : video.createTime,
      'authorId' : video.authorId,
      'cover' : video.cover,
      'description' : video.description,
      'duration' : video.duration,
      'likes' : video.likes,
      'downloads' : video.downloads,
      'commentss': video.comments,
      'looker' : video.looker
      };
      return map;
  }
}