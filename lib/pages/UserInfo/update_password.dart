import 'package:flutter/material.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'layout/layout.dart';

class UpdatePassword extends StatefulWidget {
  UpdatePassword({Key key}) : super(key: key);

  @override
  _UpdatePasswordState createState() {
    return _UpdatePasswordState();
  }
}

class _UpdatePasswordState extends State<UpdatePassword> {
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
    return Scaffold(
      appBar: AppBar(
        title: Text('修改密码'),
        backgroundColor: ConstantData.MAIN_COLOR,
      ),
      body: Form(
          key: _formKey,
          child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle('password'),
                buildTitleLine(100.0),
                SizedBox(height: 70.0),
                buildPhoneTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                SizedBox(height: 30.0),
                buildPasswordTextFieldAgain(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
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
        if(value.length < 6 || value.length > 18) {
          return '密码不能小于6个字符或大于18个字符';
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
        width: 230.0,
        child: RaisedButton(
          child: Text(
            'update',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: ConstantData.MAIN_COLOR,
          onPressed: () async {
            print("mobilePhone: $_mobilePhone, password: $_password1");
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              try {
                Map<String, dynamic> data = {
                  "mobilePhone": _mobilePhone,
                  "password": TsUtils.generateMd5(_password1)
                };
                Result result = await DioRequest.dioPut(URL.UPDATE_PASSWORD, data);
                print(result.msg);
                TsUtils.showShort(result.msg);
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