import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/AuthPage.dart';
import 'package:projectfirst/Pages/HomePage.dart';
import 'package:projectfirst/Pages/SignInPage.dart';
import 'package:projectfirst/Pages/SignUpPage.dart';
import 'package:projectfirst/Pages/VerifyMail.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context,snapshot){
          if(snapshot.hasData){
            return const VerifyMailPage();
          }
          else{
            return const AuthPage();
          }
        },
      ),
    );
  }
}
