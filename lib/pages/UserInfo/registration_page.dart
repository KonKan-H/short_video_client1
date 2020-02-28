
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:short_video_client1/http/url_string.dart';
import 'layout/layout.dart';

class RegistrationPage extends StatefulWidget {
  RegistrationPage({Key key}) : super(key: key);

  @override
  _RegistrationPageState createState() {
    return _RegistrationPageState();
  }
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  String _mobilePhone, _password1, _password2;
  bool _isObscure = true;
  Color _eyeColor;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: Text('注册页面'),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 22.0),
          children: <Widget>[
            SizedBox(
              height: kToolbarHeight,
            ),
            buildTitle('Registration'),
            buildTitleLine(100.0),
            SizedBox(height: 70.0),
            buildPhoneTextField(),
            SizedBox(height: 30.0),
            buildPasswordTextField(context),
            SizedBox(height: 30.0),
            buildPasswordTextFieldAgain(context),
            SizedBox(height: 60.0),
            buildLoginButton(context),
          ]
        )
      ),
    );
  }

  //手机号输入框
  TextFormField buildPhoneTextField() {
    return TextFormField(
      decoration: InputDecoration(
        labelText: 'MobilePhone',
      ),
      validator: (String value) {
        var phoneReg = RegExp(
            r"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$");
        if (!phoneReg.hasMatch(value)) {
          return '请输入正确的手机号';
        }
      },
      onSaved: (String value) => _mobilePhone = value,
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password1 = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: 'password',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  TextFormField buildPasswordTextFieldAgain(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password2 = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
        if(_password2 != _password1) {
          return '两次密码输入不一致';
        }
      },
      decoration: InputDecoration(
          labelText: 'password again',
          suffixIcon: IconButton(
              icon: Icon(
                Icons.remove_red_eye,
                color: _eyeColor,
              ),
              onPressed: () {
                setState(() {
                  _isObscure = !_isObscure;
                  _eyeColor = _isObscure
                      ? Colors.grey
                      : Theme.of(context).iconTheme.color;
                });
              })),
    );
  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'registered',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: Colors.blueAccent,
          onPressed: () async {
            print("mobilePhone: $_mobilePhone, password: $_password1");
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              //TODO 执行登录方法
             try {
               Response response;
               Dio dio = new Dio();
               dio.options.responseType = ResponseType.plain;
               //dio.options.baseUrl = URL.url_base + "/v1/registration/api";
               response = await dio.post(URL.url_base + "/v1/registration/api",
                   data: {"mobilePhone": _mobilePhone, "password": _password1});
               print(response.data.toString());
             }
             catch(e) {
                print(e);
             }
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }


}