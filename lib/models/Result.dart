class Result<T> {
  int code;
  T data;
  String msg;

  Result({this.code, this.data, this.msg});

  factory Result.formJson(Map<String, dynamic> json) {
    return new Result(
        code: json['code'],
        data: json['data'],
        msg: json['msg']);
  }
}