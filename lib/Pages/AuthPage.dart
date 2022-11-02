import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/SignInPage.dart';
import 'package:projectfirst/Pages/SignUpPage.dart';

class AuthPage extends StatefulWidget {
  const AuthPage({Key? key}) : super(key: key);

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  bool isLogin= true;
  @override
  Widget build(BuildContext context) => isLogin
      ? signinpage(onClickedSignUp :toggle)
      : signuppage(onClickedSignIn: toggle);

  void toggle() => setState(() => isLogin = !isLogin);
}
