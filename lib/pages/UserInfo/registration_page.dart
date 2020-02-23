import 'package:flutter/material.dart';
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
  String _email, _password1, _password2;
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
            buildEmailTextField(_email),
            SizedBox(height: 30.0),
            buildPasswordTextField(context),
            SizedBox(height: 30.0),
            buildPasswordTextFieldAgain(context),
          ]
        )
      ),
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
        if(_password1 != _password2) {
          return '两次密码输入不同';
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

}