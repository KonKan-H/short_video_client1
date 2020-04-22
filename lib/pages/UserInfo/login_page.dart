import 'package:flutter/material.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/User.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/pages/UserInfo/registration_page.dart';
import 'package:short_video_client1/pages/UserInfo/update_password.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:short_video_client1/resources/util/user_util.dart';
import 'layout/layout.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  String _mobilePhone, _password;
  bool _isObscure = true;
  Color _eyeColor;
//  List _loginMethod = [
//    {
//      "title": "wechat",
//      "icon": GroovinMaterialIcons.wechat,
//    },
//    {
//      "title": "facebook",
//      "icon": GroovinMaterialIcons.facebook,
//    },
//    {
//      "title": "qq",
//      "icon": GroovinMaterialIcons.qqchat,
//    },
//  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Form(
            key: _formKey,
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 22.0),
              children: <Widget>[
                SizedBox(
                  height: kToolbarHeight,
                ),
                buildTitle('Login'),
                buildTitleLine(40.0),
                SizedBox(height: 70.0),
                buildPhoneTextField(),
                SizedBox(height: 30.0),
                buildPasswordTextField(context),
                buildForgetPasswordText(context),
                SizedBox(height: 60.0),
                buildLoginButton(context),
                SizedBox(height: 30.0),
//                buildOtherLoginText(),
//                buildOtherMethod(context),
                buildRegisterText(context),
              ],
            )));
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

  Align buildRegisterText(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Padding(
        padding: EdgeInsets.only(top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('没有账号？'),
            GestureDetector(
              child: Text(
                '点击注册',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => RegistrationPage()
                ));
              },
            ),
          ],
        ),
      ),
    );
  }

  //第三方登录
//  ButtonBar buildOtherMethod(BuildContext context) {
//    return ButtonBar(
//      alignment: MainAxisAlignment.center,
//      children: _loginMethod
//          .map((item) => Builder(
//        builder: (context) {
//          return IconButton(
//              icon: Icon(item['icon'],
//                  color: Theme.of(context).iconTheme.color),
//              onPressed: () {
//                //TODO : 第三方登录方法
//                Scaffold.of(context).showSnackBar(new SnackBar(
//                  content: new Text("${item['title']}登录"),
//                  action: new SnackBarAction(
//                    label: "取消",
//                    onPressed: () {},
//                  ),
//                ));
//              });
//        },
//      ))
//          .toList(),
//    );
//  }
//
//  Align buildOtherLoginText() {
//    return Align(
//        alignment: Alignment.center,
//        child: Text(
//          '其他账号登录',
//          style: TextStyle(color: Colors.grey, fontSize: 14.0),
//        ));
//  }

  Align buildLoginButton(BuildContext context) {
    return Align(
      child: SizedBox(
        height: 45.0,
        width: 270.0,
        child: RaisedButton(
          child: Text(
            'Login',
            style: Theme.of(context).primaryTextTheme.headline,
          ),
          color: ConstantData.MAIN_COLOR,
          onPressed: () async {
            ///登录操作
            if (_formKey.currentState.validate()) {
              ///只有输入的内容符合要求通过才会到达此处
              _formKey.currentState.save();
              print('mobilePhone:$_mobilePhone , password:$_password');
              Map<String, dynamic> data = {
                "mobilePhone": _mobilePhone,
                "password": TsUtils.generateMd5(_password)
              };
              Result result = await DioRequest.dioPost(URL.USER_LOGIN, data);
              print(result.msg);
              TsUtils.showShort(result.msg);
              if(result.data != null) {
                UserInfo userInfo = await UserInfoUtil.map2UserInfo(result.data);
                User user = User(userInfo.userId, userInfo.userName, userInfo.userAvatar, userInfo.mobilePhone);
                OsApplication.eventBus.fire(
                    LoginEvent(userInfo.userId, user.userName, user.userAvatar, userInfo.age,
                        userInfo.sex, userInfo.area, userInfo.introduction));
                UserUntil.saveUserInfo(user);
                UserInfoUtil.saveUserInfo(userInfo);
                Navigator.pop(context);
              }
            }
          },
          shape: StadiumBorder(side: BorderSide()),
        ),
      ),
    );
  }

  Padding buildForgetPasswordText(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Align(
        alignment: Alignment.centerRight,
        child: FlatButton(
          child: Text(
            '修改密码 ',
            style: TextStyle(fontSize: 14.0, color: Colors.grey),
          ),
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(
              builder: (context) => UpdatePassword()
            ));
          },
        ),
      ),
    );
  }

  TextFormField buildPasswordTextField(BuildContext context) {
    return TextFormField(
      onSaved: (String value) => _password = value,
      obscureText: _isObscure,
      validator: (String value) {
        if (value.isEmpty) {
          return '请输入密码';
        }
      },
      decoration: InputDecoration(
          labelText: 'Password',
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
}
