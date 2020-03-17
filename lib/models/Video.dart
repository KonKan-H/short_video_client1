import 'package:camera/camera.dart';

class Video{
  var id;
  var url;
  var author;

  Video(this.id, this.url, this.author);

  static var path = '';
  static var name = '';
  static var useMediumResolution = false;
  static List<CameraDescription> cameras;
}