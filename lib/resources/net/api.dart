import 'package:short_video_client1/resources/strings.dart';

class URL{
  //10.20.8.155为服务端 IP地址
  //static const String BASE_URL = 'http://10.20.8.155:9250/v3';
  //dev uat
//  static const String BASE_URL = ConstantData.URL_BASE + ':9250/v3';
  //prod
  static const String BASE_URL = ConstantData.URL_BASE + ':9025/v3';

  //注册
  static const String USER_REGISTER = BASE_URL + '/v1/registration/api';

  //登录
  static const String USER_LOGIN = BASE_URL + '/v1/login/api';

  //更新信息
  static const String USER_INFO_UPDATE = BASE_URL + '/v1/userInfo/api';

  //上传文件
  static const String UPLOAD_FILE = BASE_URL + '/v1/file/api';

  //获取视频
  static const String GET_VIDEO_LIST = BASE_URL + '/v1/video/init/api';

  //点赞
  static const String VIDEO_LIKE = BASE_URL + '/v1/like/api';

  //下载视频
  static const String VIDEO_DOWNLOAD = BASE_URL + '/v1/video/api';

  //更新密码
  static const String UPDATE_PASSWORD = BASE_URL + '/v1/password/api';

  //判断喜欢
  static const String VIDEO_LIKE_OR_NOT = BASE_URL + '/v1/like/api';

  //判断关注
  static const String USER_ATTENTION_OR_NOT = BASE_URL + '/v1/attention/api';

  //取得用户信息
  static const String GET_USER_INFO = BASE_URL + '/v1/userInfo/id/api';

  //关注用户
  static const String ATTENTION_USER_INSERT = BASE_URL + '/v1/attention/user/insert/api';

  //取消关注
  static const String ATTENTION_USER_CANCEL = BASE_URL + '/v1/attention/user/cancel/api';

  //取得关注数和粉丝数
  static const String USER_FANS_ATTENTION = BASE_URL + '/v1/fans/attention/api';

  //删除视频
  static const String VIDEO_DELETE = BASE_URL + '/v1/video/delete/api';

  //取得粉丝列表
  static const String FANS_LIST_VIEW = BASE_URL + '/v1/fans/list/api';

  //取得关注列表
  static const String ATTENTIONS_LIST_VIEW = BASE_URL + '/v1/attentions/list/api';

  //取得用户点赞的视频
  static const String MY_FAVORITE_VIDEO_LIST = BASE_URL + '/v1/favorite/video/api';

  //取得用户关注用户的视频
  static const String MY_FOLLOWING_VIDEO_LIST = BASE_URL + '/v1/following/video/api';

  //上传视频信息 带封面
  static const String UPLOAD_VIDEO_INFO_COVER = BASE_URL + '/v1/videoInfo/cover/api';

  //上传视频信息 不带封面
  static const String UPLOAD_VIDEO_INFO = BASE_URL + '/v1/videoInfo/api';

  //根据视频取得评论列表
  static const String VIDEO_REPLY_LIST = BASE_URL + '/v1/reply/api';

  //评论视频
  static const String COMMENT_VIDEO = BASE_URL + '/v1/reply/api';

  //删除评论
  static const String REPLY_DELETE = BASE_URL + '/v1/reply/delete/api';

  //点赞评论
  static const String LIKE_REPLY = BASE_URL + '/v1/reply/like/api';

  //取消点赞评论
  static const String CANCEL_LIKE_REPLY = BASE_URL + '/v1/reply/cancel/api';

  //取得热门视频
  static const String HOT_VIDEO = BASE_URL + '/v1/hot/video/api';
}