import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:short_video_client1/models/Result.dart';

class DioRequest {
  //post请求
  static Future<Result> dioPost(String url, Map<String, dynamic> data) async {
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.post(url, data: data);
    Result result = Result.formJson(json.decode(response.data));
    return result;
  }

  //put请求
  static Future<Result> dioPut(String url, Map<String, dynamic> data) async {
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.put(url, data: data);
    Result result = Result.formJson(json.decode(response.data));
    return result;
  }

  //post 上传文件
  static Future<Result> uploadFile(String url, FormData formData) async {
    Response response;
    Dio dio = new Dio();
    dio.options.responseType = ResponseType.plain;
    response = await dio.post(url, data: formData);
    Result result = Result.formJson(json.decode(response.data));
    return result;
  }
}