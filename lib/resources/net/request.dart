import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/resources/tools.dart';

class DioRequest {
  //post请求
  static Future<Result> dioPost(String url, Map<String, dynamic> data) async {
    TsUtils.logInfo('POST: $url $data');
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.post(url, data: data);
    Result result = Result.formJson(json.decode(response.data));
    TsUtils.logInfo(result.toString());
    return result;
  }

  //put请求
  static Future<Result> dioPut(String url, Map<String, dynamic> data) async {
    TsUtils.logInfo('Put: $url $data');
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.put(url, data: data);
    Result result = Result.formJson(json.decode(response.data));
    TsUtils.logInfo(result.toString());
    return result;
  }

  //put请求
  static Future<Result> dioDelete(String url, Map<String, dynamic> data) async {
    TsUtils.logInfo('Delete: $url $data');
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.delete(url, data: data);
    Result result = Result.formJson(json.decode(response.data));
    TsUtils.logInfo(result.toString());
    return result;
  }


  //get请求
  static Future<Result> dioGet(String url) async {
    TsUtils.logInfo('Get: $url');
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.get(url);
    Result result = Result.formJson(json.decode(response.data));
    TsUtils.logInfo(result.toString());
    return result;
  }

  //post 上传文件
  static Future<Result> uploadFile(String url, FormData formData) async {
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.post(url, data: formData);
    Result result = Result.formJson(json.decode(response.data));
    TsUtils.logInfo(result.toString());
    return result;
  }
}