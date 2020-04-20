import 'package:dio/dio.dart';
import 'package:short_video_client1/resources/util/user_util.dart';
class RequestInterceptors extends InterceptorsWrapper {
  @override
  Future onRequest(RequestOptions options) async {
    String token = await UserUntil.getToken();
    var header = {"access_token": token,
      "Content-Type":"application/json"};
    options.headers.addAll(header);
    return super.onRequest(options);
  }
}
