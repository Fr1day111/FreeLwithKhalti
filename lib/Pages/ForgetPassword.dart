import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class ForgetPassword extends StatefulWidget {
  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _mController = TextEditingController();
  //final AuthService _auth = AuthService();

  //text field state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        elevation: 0.0,
        title: Text('Forgot Password'),
      ),
      body: SingleChildScrollView(
        child: Container(
            padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 25.0),
            child: Form(
              key: _formKey,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    const Text(
                        "We'll send the password reset link if you're registered with the given email address"),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: _mController,
                      decoration: const InputDecoration(
                          hintText: 'Enter your email address',
                          labelText: 'Email',
                          floatingLabelStyle: TextStyle(color: Colors.lightBlueAccent),
                          border: OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.lightBlueAccent))),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Please enter your email address';
                        }
                        // Check if the entered email has the right format
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Please enter a valid email address';
                        }
                        // Return null if the entered email is valid
                        return null;
                      },
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    SizedBox(
                      height: 50.0,
                      width: 150.0,
                      child: ElevatedButton(
                        //color: Colors.red,
                        child: Text("Send Code".toUpperCase(),
                            style: TextStyle(fontSize: 14)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.lightBlueAccent,
                          elevation: 3,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(32.0),
                          ),
                        ),
                        onPressed: () async {
                          if (_formKey.currentState!.validate()) {
                            await FirebaseAuth.instance.sendPasswordResetEmail(email:_mController.text).onError((error, stackTrace) async {
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
                            }).then((value) {
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Confirmation Code sent!!!'),
                                    content:Text('Check your mail...'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: (){
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                const MyHomePage(title: 'Ntg')),
                                          );
                                        },
                                        child: const Text('OK'),
                                      ),
                                    ],
                                  )
                              );

                            });
                            //Navigator.pop(context);
                          }
                        },
                      ),
                    ),
                  ]),
            )),
      ),
    );
  }
}