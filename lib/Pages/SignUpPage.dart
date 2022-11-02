import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/Main_page.dart';

import 'SignInPage.dart';

class signuppage extends StatefulWidget {
  final Function() onClickedSignIn;

  const signuppage({Key? key,required this.onClickedSignIn}) : super(key: key);

  @override
  State<signuppage> createState() => _signuppageState();
}

class _signuppageState extends State<signuppage> {
  final _signupform = GlobalKey<FormState>();
  bool _isSPassHidden = true;
  bool _isCPassHidden = true;
  final TextEditingController _UserNameController = TextEditingController();
  final TextEditingController _EmailController = TextEditingController();
  final TextEditingController _PhoneNoController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _cpassController = TextEditingController();
  CollectionReference Users = FirebaseFirestore.instance.collection('Users');

  @override
  void dispose() {
    _UserNameController.dispose();
    _passController.dispose();
    _cpassController.dispose();
    _EmailController.dispose();
    _PhoneNoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.lightBlue,
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
                image: AssetImage("Assets/Photos/bg.png"), fit: BoxFit.cover),
          ),
          child: Form(
            key: _signupform,
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 110),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Center(
                      child: Container(
                        width: 370,
                        // height: 700,
                        decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.grey.shade600,
                                  spreadRadius: 1,
                                  blurRadius: 15,
                                  offset: const Offset(0, 15))
                            ],
                            color: Colors.grey[350],
                            borderRadius: BorderRadius.circular(30)),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 90,
                              width: 90,
                              child: Image.asset('Assets/Logo/logomain.png'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: TextFormField(
                                controller: _UserNameController,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field cant be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'User Name',
                                  hintStyle:
                                      const TextStyle(fontFamily: 'OpenSans'),
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
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: TextFormField(
                                controller: _EmailController,
                                keyboardType: TextInputType.emailAddress,
                                validator: (value) {
                                  bool emailValid = RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value!);
                                  if (emailValid != true) {
                                    return 'Email Format not matched';
                                  }
                                  if (value.isEmpty) {
                                    return 'This field cant be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Email',
                                  hintStyle:
                                      const TextStyle(fontFamily: 'OpenSans'),
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
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: TextFormField(
                                controller: _PhoneNoController,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field can\'t be empty';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  filled: true,
                                  fillColor: Colors.grey[200],
                                  hintText: 'Phone Number',
                                  hintStyle:
                                      const TextStyle(fontFamily: 'OpenSans'),
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
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: TextFormField(
                                controller: _passController,
                                obscureText: _isSPassHidden,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field cant be empty';
                                  }
                                  else if (value.length < 6){
                                    return'Password must be at least 6 digit';
                                  }
                                  return null;
                                },
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
                                      icon: Icon(_isSPassHidden
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                      onPressed: () {
                                        setState(() {
                                          _isSPassHidden = !_isSPassHidden;
                                        });
                                      },
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 25, right: 25),
                              child: TextFormField(
                                controller: _cpassController,
                                obscureText: _isCPassHidden,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return 'This field cant be empty';
                                  }
                                  if (value != _passController.text) {
                                    return 'Password Doesn\'t match';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    hintText: 'Confirm Password',
                                    hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    suffixIcon: IconButton(
                                      icon: Icon(_isCPassHidden
                                          ? Icons.visibility_outlined
                                          : Icons.visibility_off_outlined),
                                      onPressed: () {
                                        setState(() {
                                          _isCPassHidden = !_isCPassHidden;
                                        });
                                      },
                                    )),
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            GestureDetector(
                              onTap: () async {
                                if (_signupform.currentState!.validate()) {
                                  _signupform.currentState!.save();
                                  FirebaseAuth.instance
                                      .createUserWithEmailAndPassword(
                                          email: _EmailController.text.trim(),
                                          password: _passController.text.trim())
                                      .then((value) {
                                    Users.doc(value.user?.uid).set({
                                      'UserName': _UserNameController.text.trim(),
                                      'Email': _EmailController.text.trim(),
                                      'PhoneNo': _PhoneNoController.text.trim(),
                                      'pfpUrl':" ",
                                      'cvUrl' : " ",
                                      'Bio' : ' ',
                                      'Finished':'0',
                                      'Rating':'5'
                                    }).onError((error, stackTrace) {
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
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                const MainPage()),
                                      );
                                    }).onError((error, stackTrace) async {
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
                                  });
                                }
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
                                  'Sign Up',
                                  style: TextStyle(
                                      fontFamily: 'OpenSans',
                                      fontWeight: FontWeight.bold),
                                )),
                              ),
                            ),
                            const SizedBox(height:10),
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
                            const SizedBox(height: 30)
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
