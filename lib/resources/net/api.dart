class URL{
  //192.168.31.81为服务端 IP地址
  static const String BASE_URL = 'http://192.168.31.81:9250/v3';

  //注册
  static const String USER_REGISTER = BASE_URL + '/v1/registration/api';

  //登录
  static const String USER_LOGIN = BASE_URL + '/v1/login/api';

  //更新信息
  static const String USER_INFO_UPDATE = BASE_URL + '/v1/userInfo/api';

  //上传文件
  static const String UPLOAD_FILE = BASE_URL + '/v1/file/api';

  //获取视频
  static const String GET_VIDEO_LIST = BASE_URL + '/v1/video/api';

  //点赞
  static const String VIDEO_LIKE = BASE_URL + '/v1/like/api';

  //下载视频
  static const String VIDEO_DOWNLOAD = BASE_URL + '/v1/video/api';

  //更新密码
  static const String UPDATE_PASSWORD = BASE_URL + '/v1/password/api';

  //判断喜欢
  static const String VIDEO_LIKE_OR_NOT = BASE_URL + '/v1/like/api';

  //判断关注
  static const String USER_ATTENTION = BASE_URL + '/v1/attention/api';
}