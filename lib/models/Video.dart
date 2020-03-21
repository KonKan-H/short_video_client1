import 'package:camera/camera.dart';

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
        downloads:json['downloads']
    );
  }
//  factory Video.formJson(Map<String, dynamic> json) {
//    Video video;
//    video.id = json['id'];
//    video.url = json['url'];
//    video.authorName = json['authorName'];
//    video.authorAvatar = json['authorAvatar'];
//    video.createTime = json['createTime'];
//    video.authorId = json['authorId'];
//    video.cover = json['cover'];
//    video.description = json['description'];
//    video.duration = json['duration'];
//    video.likes = json['likes'];
//    video.downloads = json['downloads'];
//    return video;
//  }

}