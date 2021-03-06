import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/resources/net/Interceptors.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:short_video_client1/resources/util/user_util.dart';

class DioRequest {

  static Dio getDio() {
    Dio dio = new Dio();
//    dio.options.connectTimeout = 5000;
//    dio.options.receiveTimeout = 3000;
//    dio.options.responseType = ResponseType.plain;
    dio.interceptors.add(RequestInterceptors());
    return dio;
  }

  //post请求
  static Future<Result> dioPost(String url, Map<String, dynamic> data) async {
    TsUtils.logInfo('POST: $url $data');
    Response response;
    Dio dio = getDio();
    try{
      response = await dio.post(url, data: data);
    } on DioError catch (e) {
      _dioErrorDeal(e);
    }
    Result result = Result.formJson(response.data);
    TsUtils.logInfo(result.toString());
    return result;
  }

  //put请求
  static Future<Result> dioPut(String url, Map<String, dynamic> data) async {
    TsUtils.logInfo('Put: $url $data');
    Response response;
    Dio dio = getDio();
    try{
      response = await dio.put(url, data: data);
    } on DioError catch (e) {
      _dioErrorDeal(e);
    }
    Result result = Result.formJson(response.data);
    TsUtils.logInfo(result.toString());
    return result;
  }

  //put请求
  static Future<Result> dioDelete(String url, Map<String, dynamic> data) async {
    TsUtils.logInfo('Delete: $url $data');
    Response response;
    Dio dio = getDio();
    try{
      response = await dio.delete(url, data: data);
    } on DioError catch (e) {
      _dioErrorDeal(e);
    }
    Result result = Result.formJson(response.data);
    TsUtils.logInfo(result.toString());
    return result;
  }


  //get请求
  static Future<Result> dioGet(String url) async {
    TsUtils.logInfo('Get: $url');
    Response response;
    Dio dio = getDio();
    try{
      response = await dio.get(url);
    } on DioError catch (e) {
      _dioErrorDeal(e);
    }
    Result result = Result.formJson(response.data);
    TsUtils.logInfo(result.toString());
    return result;
  }

  //post 上传文件
  static Future<Result> uploadFile(String url, FormData formData) async {
    Response response;
    Dio dio = getDio();
    try{
      response = await dio.post(url, data: formData);
    } on DioError catch(e)  {
      _dioErrorDeal(e);
    }
    Result result = Result.formJson(json.decode(response.data));
    TsUtils.logInfo(result.toString());
    return result;
  }

   static _dioErrorDeal(DioError e) {
    if(e.message.contains("403")) {
      UserUntil.cleanUserInfo();
      UserInfoUtil.cleanUserInfo();
      TsUtils.showShort("token错误，强制退出");
    }
   }
}