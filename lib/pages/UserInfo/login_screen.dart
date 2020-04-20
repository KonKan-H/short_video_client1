import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:short_video_client1/app/OsApplication.dart';
import 'package:short_video_client1/event/login_event.dart';
import 'package:short_video_client1/models/Result.dart';
import 'package:short_video_client1/models/User.dart';
import 'package:short_video_client1/models/UserInfo.dart';
import 'package:short_video_client1/resources/net/api.dart';
import 'package:short_video_client1/resources/net/request.dart';
import 'package:short_video_client1/resources/strings.dart';
import 'package:short_video_client1/resources/tools.dart';
import 'package:short_video_client1/resources/util/user_info_until.dart';
import 'package:short_video_client1/resources/util/user_util.dart';

class LoginScreen extends StatelessWidget {
  LoginScreen({Key key, this.context}) : super(key: key);
  final BuildContext context;

  static const routeName = '/auth';

  Duration get loginTime => Duration(milliseconds: timeDilation.ceil() * 2000);

  Future<String> _loginUser(LoginData loginData) async {
    Map<String, dynamic> data = {
      "mobilePhone": loginData.name,
      "password": TsUtils.generateMd5(loginData.password)
    };
    Result result = await DioRequest.dioPost(URL.USER_LOGIN, data);
    return Future.delayed(loginTime).then((_) async {
      if (result.code == 1) {
        UserInfo userInfo = await UserInfoUntil.map2UserInfo(result.data);
        Map<String, dynamic> data = {
          "access_token": userInfo.accessToken
        };
        UserUntil.saveToke(data);
        User user = User(userInfo.userId, userInfo.userName,
            userInfo.userAvatar, userInfo.mobilePhone);
        OsApplication.eventBus.fire(LoginEvent(
            userInfo.userId,
            user.userName,
            user.userAvatar,
            userInfo.age,
            userInfo.sex,
            userInfo.area,
            userInfo.introduction,));
        UserUntil.saveUserInfo(user);
        UserInfoUntil.saveUserInfo(userInfo);
        TsUtils.showShort("登录成功");
        Navigator.pop(context);
        return null;
      } else {
        return 'Username or password is incorrect';
      }
    });
  }

  Future<String> _signupUser(LoginData loginData) async {
    Map<String, dynamic> data = {
      "mobilePhone": loginData.name,
      "password": TsUtils.generateMd5(loginData.password)
    };
    Result result = await DioRequest.dioPost(URL.USER_REGISTER, data);
    return Future.delayed(loginTime).then((_) async {
      if(result.code == 1) {
        TsUtils.showShort("注册成功,请登录");
//        Navigator.of(context).pushReplacement(MaterialPageRoute(
//          builder: (context) => LoginScreen(),
//        ));
        return null;
      } else {
        return 'Phone number has been registered';
      }
    });
  }

  Future<String> _recoverPassword(String name) {
    return Future.delayed(loginTime).then((_) {
//      if (!mockUsers.containsKey(name)) {
//        return 'Username not exists';
//      }
      return null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final inputBorder = BorderRadius.vertical(
      bottom: Radius.circular(10.0),
      top: Radius.circular(20.0),
    );

    return FlutterLogin(
      title: ConstantData.appName,
      logo: 'assets/images/ecorp.png',
      logoTag: ConstantData.logoTag,
      titleTag: ConstantData.titleTag,
      messages: LoginMessages(
        usernameHint: 'Username',
        passwordHint: 'Pass',
        confirmPasswordHint: 'Confirm',
        loginButton: 'LOG IN',
        signupButton: 'REGISTER',
        forgotPasswordButton: 'Forgot pass?',
        recoverPasswordButton: 'HELP ME',
        goBackButton: 'GO BACK',
        confirmPasswordError: 'Not match!',
        recoverPasswordIntro: 'Don\'t feel bad. Happens all the time.',
        recoverPasswordDescription:
            'Lorem Ipsum is simply dummy text of the printing and typesetting industry',
        recoverPasswordSuccess: 'Password rescued successfully',
      ),
      theme: LoginTheme(
        primaryColor: ConstantData.MAIN_COLOR,
        accentColor: ConstantData.MAIN_COLOR,
        errorColor: ConstantData.MAIN_COLOR,
        pageColorLight: ConstantData.MAIN_COLOR,
        pageColorDark: ConstantData.MAIN_COLOR,
        titleStyle: TextStyle(
          color: Colors.white,
          fontFamily: 'Quicksand',
          letterSpacing: 4,
        ),
        // beforeHeroFontSize: 50,
        // afterHeroFontSize: 20,
//         bodyStyle: TextStyle(
//           fontStyle: FontStyle.italic,
//           decoration: TextDecoration.underline,
//         ),
//         textFieldStyle: TextStyle(
//           color: Colors.orange,
//           shadows: [Shadow(color: Colors.yellow, blurRadius: 2)],
//         ),
//         buttonStyle: TextStyle(
//           fontWeight: FontWeight.w800,
//           color: Colors.yellow,
//         ),
//         cardTheme: CardTheme(
//           color: Colors.yellow.shade100,
//           elevation: 5,
//           margin: EdgeInsets.only(top: 15),
//           shape: ContinuousRectangleBorder(
//               borderRadius: BorderRadius.circular(100.0)),
//         ),
//         inputTheme: InputDecorationTheme(
//           filled: true,
//           fillColor: Colors.purple.withOpacity(.1),
//           contentPadding: EdgeInsets.zero,
//           errorStyle: TextStyle(
//             backgroundColor: Colors.orange,
//             color: Colors.white,
//           ),
//           labelStyle: TextStyle(fontSize: 12),
//           enabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue.shade700, width: 4),
//             borderRadius: inputBorder,
//           ),
//           focusedBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.blue.shade400, width: 5),
//             borderRadius: inputBorder,
//           ),
//           errorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.red.shade700, width: 7),
//             borderRadius: inputBorder,
//           ),
//           focusedErrorBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.red.shade400, width: 8),
//             borderRadius: inputBorder,
//           ),
//           disabledBorder: UnderlineInputBorder(
//             borderSide: BorderSide(color: Colors.grey, width: 5),
//             borderRadius: inputBorder,
//           ),
//         ),
//         buttonTheme: LoginButtonTheme(
//           splashColor: Colors.purple,
//           backgroundColor: Colors.pinkAccent,
//           highlightColor: Colors.lightGreen,
//           elevation: 9.0,
//           highlightElevation: 6.0,
//           shape: BeveledRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
//           // shape: CircleBorder(side: BorderSide(color: Colors.green)),
//           // shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(55.0)),
//         ),
      ),
      emailValidator: (value) {
        var phoneReg = RegExp(
            r"^((13[0-9])|(14[0-9])|(15[0-9])|(16[0-9])|(17[0-9])|(18[0-9])|(19[0-9]))\d{8}$");
        if (!phoneReg.hasMatch(value)) {
          return 'Please enter the correct phone number';
        }
        return null;
      },
      passwordValidator: (value) {
        if (value.isEmpty) {
          return 'Password is empty';
        }
        if(value.length < 6 || value.length > 18) {
          return 'Greater than 6 characters and less than 18 characters';
        }
        return null;
      },
      onLogin: (loginData) {
        print('Login info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _loginUser(loginData);
      },
      onSignup: (loginData) {
        print('Signup info');
        print('Name: ${loginData.name}');
        print('Password: ${loginData.password}');
        return _signupUser(loginData);
      },
      onSubmitAnimationCompleted: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => LoginScreen(),
        ));
      },
      onRecoverPassword: (name) {
        print('Recover password info');
        print('Name: $name');
        return _recoverPassword(name);
        // Show new password dialog
      },
      showDebugButtons: false,
    );
  }
}