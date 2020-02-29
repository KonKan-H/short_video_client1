class Result<T> {
  final int code;
  final T data;
  final String msg;

  Result({this.code, this.data, this.msg});

  factory Result.formJson(Map<String, dynamic> json) {
    return new Result(
        code: json['code'],
        data: json['data'],
        msg: json['msg']);
  }
}