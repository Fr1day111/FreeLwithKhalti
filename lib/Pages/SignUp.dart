import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/SignUpFreeLancer.dart';
import 'package:projectfirst/Pages/SignUpPage.dart';


class SignUp extends StatefulWidget {
  final Function() onClickedSignIn;
  const SignUp({Key? key,required this.onClickedSignIn}) : super(key: key);

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("Assets/Photos/bg.png"), fit: BoxFit.cover),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const SignUpFreeLancer()),
                    );

                  },
                  child: Container(
                    height: 70,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.red,
                    ),
                    child: const Center(
                        child: Text(
                          'FreeLancer',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                SizedBox(height: 50,),
                GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                          const signuppage()),
                    );
                  },
                  child: Container(
                    height: 70,
                    width: 300,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      color: Colors.lightBlueAccent,
                    ),
                    child: const Center(
                        child: Text(
                          'Client',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        )),
                  ),
                ),
                RichText(text: TextSpan(
                    text: 'Already Have an account? ',
                    style: const TextStyle(fontFamily: 'OpenSans',color: Colors.black,
                        fontWeight: FontWeight.bold),
                    children: [
                      TextSpan(
                        recognizer: TapGestureRecognizer()
                          ..onTap=widget.onClickedSignIn,
                        text: 'Log In',
                        style: const TextStyle(
                            fontStyle: FontStyle.italic,
                            fontFamily: 'OpenSans',
                            fontWeight: FontWeight.bold,
                            color: Colors.lightBlueAccent),

                      )
                    ]
                )),
              ],
            ),
          ),
        ),
      ),

    );
  }
}
