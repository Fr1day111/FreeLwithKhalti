import 'dart:async';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/OtherPfPage.dart';

import 'Main_page.dart';

class DetailPage extends StatefulWidget {
  final String postid;

  const DetailPage({Key? key, required this.postid}) : super(key: key);

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  //void regProject(userID) async{
    //CollectionReference Notification = FirebaseFirestore.instance.collection('Users').doc(userID).collection('Notification');

    //Notification.doc().set({});
  //}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: SafeArea(
                child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
      future: FirebaseFirestore.instance
          .collection("Posts")
          .doc(widget.postid)
          .get(),
      builder: (_, snapshot) {
        // if(snapshot.hasError){}
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
        else {
          var data = snapshot.data!.data();
          var title = data!['Title'];
          var description = data['Description'];
          var amount = data['Budget'];
          var deadline = data['Deadline'];
          var userid = data['UserId'].toString();
          var type=data['Type'];

          return  Padding(
            padding: const EdgeInsets.only(top: 20, left: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontSize: 50,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold),
                ),

                Text(
                  type,
                  style: const TextStyle(
                    fontSize: 15,
                    fontFamily: 'OpenSans',
                    color: Colors.grey
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                SizedBox(
                  width: 350,
                  child: Text(
                    description,
                    style: const TextStyle(
                        fontSize: 20,
                        fontFamily: 'OpenSans',
                        color: Colors.grey),
                  ),
                ),
                const SizedBox(
                  height: 30,
                ),
                const Text(
                  "Budget:",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold),
                ),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 30,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const Text(
                  "Deadline:",
                  style: TextStyle(
                      fontSize: 25,
                      fontFamily: 'OpenSans',
                      fontWeight: FontWeight.bold),
                ),
                Text(deadline,
                  style: const TextStyle(
                    fontSize: 30,
                    fontFamily: 'OpenSans',
                  ),
                ),
                const SizedBox(height: 10),
                GestureDetector(
                    onTap:(){
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>OtherPfPage(UserId: userid)),
                      );
                    },
                    child: const Text("Visit Profile of Client",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: 'OpenSans',
                      fontSize: 20,
                      color: Colors.lightBlueAccent,
                      decoration: TextDecoration.underline,
                    ),)),
                const SizedBox(height: 30,),
                Center(
                  child: GestureDetector(
                    onTap: (){
                      CollectionReference Notification = FirebaseFirestore.instance.collection('Users').doc(userid).collection('Notification');

                      Notification.doc().set({
                        'UserId': auth.currentUser!.uid,
                        'PostId' : widget.postid,
                        'Type' : 'Requests',
                        'Title':title,
                        'Timestamp':Timestamp.now()
                      }).then((value) {
                       // print("@@@@@@@@@@@@@@");
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) =>
                            AlertDialog(
                          title: const Text('Done!!'),
                          content:Text("You Have Register the job!!\nWait for response..."),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const MainPage()),
                                );
                                },
                              child: const Text('Return to home'),
                            ),
                          ],
                        ));
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
                    },
                    child: Container(
                      height: 70,
                      width: 250,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.lightBlueAccent,
                      ),
                      child: const Center(
                          child: Text(
                        'Register',
                        style: TextStyle(
                            fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                      )),
                    ),
                  ),
                ),
              ],
            ),
          );
        }
      },
    ))));
  }
}
