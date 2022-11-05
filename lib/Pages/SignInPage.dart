import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/ForgetPassword.dart';
import 'package:projectfirst/Pages/HomePage.dart';
import 'package:projectfirst/Pages/Main_page.dart';

import 'SignUpPage.dart';

class signinpage extends StatefulWidget {
  final Function() onClickedSignUp;
  const signinpage({Key? key,required this.onClickedSignUp}) : super(key: key);

  @override
  State<signinpage> createState() => _signinpageState();
}

class _signinpageState extends State<signinpage> {
  bool _isPassHidden = true;

  final TextEditingController _mController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: _mController.text.trim(),
            password: _passwordController.text.trim())
        .then((value) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const MainPage()),
              );
            })
        .onError((error, stackTrace) async {
      showDialog<String>(
          context: context,
          builder: (BuildContext context) => AlertDialog(
        title: const Text('Error'),
        content:Text(error.toString()),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.pop(context, 'OK'),
            child: const Text('OK'),
          ),
        ],
      )
      );
    });
  }

  @override
  void dispose() {
    _mController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("Assets/Photos/bg.png"), fit: BoxFit.cover),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Container(
                  width: 370,
                  height: 400,
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                            color: Colors.grey.shade600,
                            spreadRadius: 1,
                            blurRadius: 15)
                      ],
                      color: Colors.grey[350],
                      borderRadius: BorderRadius.circular(30)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        height: 70,
                        width: 70,
                        child: Image.asset('Assets/Logo/logomain.png'),
                      ),
                      const Text(
                        'Let\'s get Started!!!',
                        style: TextStyle(
                            fontFamily: 'OpenSans',
                            fontSize: 24,
                            fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextFormField(
                          controller: _mController,
                          decoration: InputDecoration(
                            filled: true,
                            fillColor: Colors.grey[200],
                            hintText: 'Email',
                            hintStyle: const TextStyle(fontFamily: 'OpenSans'),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                        child: TextFormField(
                          controller: _passwordController,
                          obscureText: _isPassHidden,
                          decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              hintText: 'Password',
                              hintStyle:
                                  const TextStyle(fontFamily: 'OpenSans'),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(_isPassHidden
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined),
                                onPressed: () {
                                  setState(() {
                                    _isPassHidden = !_isPassHidden;
                                  });
                                },
                              )),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 24.0),
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassword()));
                            },
                            child: RichText(text: const TextSpan(
                                text: "",
                                style: TextStyle(fontFamily: 'OpenSans',
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold),
                                children: [
                                  TextSpan(
                                    text: 'Forget Password?',
                                    style: TextStyle(
                                      //fontStyle: FontStyle.italic,
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlueAccent),

                                  )
                                ]
                            )),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      GestureDetector(
                        onTap: () {
                          signIn();
                        },
                        child: Container(
                          height: 50,
                          width: 300,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.lightBlueAccent,
                          ),
                          child: const Center(
                              child: Text(
                            'Sign In',
                            style: TextStyle(
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          )),
                        ),
                      ),
                 const    SizedBox(height: 12,),
                      RichText(text: TextSpan(
                          text: "Don't Have an Account? ",
                          style: const TextStyle(fontFamily: 'OpenSans',
                          color: Colors.black,
                          fontWeight: FontWeight.bold),
                          children: [
                            TextSpan(
                              recognizer: TapGestureRecognizer()
                                ..onTap=widget.onClickedSignUp,
                              text: 'Sign Up',
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold,
                                  color: Colors.lightBlueAccent),

                            )
                          ]
                      )),
                      const    SizedBox(height: 12,),


                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
