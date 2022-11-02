import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/HomePage.dart';
import 'package:projectfirst/Pages/ManageRequest.dart';
import 'package:projectfirst/Pages/PendingJobPage.dart';
import 'package:projectfirst/Pages/PendingPaymentPage.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
 // final List postinfo = [];
  final List userinfo = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  //final Stream<QuerySnapshot> postsStream =
  //FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.uid).collection('Notification').snapshots();
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('Users')
            .doc(auth.currentUser!.uid)
            .collection('Notification').orderBy('Timestamp')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Text("Error!! Something went wrong");
          }
          // if (snapshot.connectionState == ConnectionState.waiting) {
          // return const Center(
          // child: CircularProgressIndicator(),
          // );
          //}
          final List storedocs = [];
          snapshot.data?.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            a['id'] = document.id;
            storedocs.add(a);
          }).toList();
          print(storedocs);
          print('***********************');

          // for (var i = 0; i < storedocs.length; i++) {
          //   FirebaseFirestore.instance
          //       .collection("Posts")
          //       .doc(storedocs[i]['PostId'])
          //       .get()
          //       .then((value) async {
          //     if (value.exists) {
          //       Map b = value.data() as Map<String, dynamic>;
          //       setState(() {
          //         postinfo.add(b);
          //       });
          //     }
          //     postinfo.toList(growable: true);
          //   }).onError((error, stackTrace) {
          //     print(error.toString());
          //     print('llllllllllllllllllll');
          //   });
          //   print(postinfo);
          //   print("&&&&&&&&&&&&&");
          //   //Map a = post.data() as Map<String, dynamic>;
          // }
          for (var i = 0; i < storedocs.length; i++) {
            FirebaseFirestore.instance
                .collection("Users")
                .doc(storedocs[i]['UserId'])
                .get()
                .then((value) async {
              if (value.exists) {
                Map c = value.data() as Map<String, dynamic>;
                setState(() {
                  userinfo.add(c);
                });
              }
              else {
                userinfo[i] = null;
              }
              userinfo.toList(growable: true);
            }).onError((error, stackTrace) {
              print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
            });
            // print(userinfo);
            //print('@@@@@@@@@@@@@@@@@@@@@');
            //Map a = post.data() as Map<String, dynamic>;
          }
          return storedocs.isNotEmpty ? Scaffold(
            body: SafeArea(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    const Text('Notifications', style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontFamily: 'OpenSans',
                        fontSize: 30
                    ),),
                    for (var i = 0; i < storedocs.length; i++) ...[
                      storedocs[i]['Type'] == 'Confirmation' ?
                      GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance.collection('Users').doc(
                              auth.currentUser!.uid).collection('Notification')
                              .doc(storedocs[i]['id']).delete()
                              .then((value) {
                                storedocs[i]['Status']=='Accepted'?
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const PendinJobPage()),
                            ):showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) => AlertDialog(
                                      title: const Text('Sorry!!!'),
                                      content:Text('Your Request has been rejected!!!'),
                                      actions: <Widget>[
                                        TextButton(
                                          onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context)=>HomePage())),
                                          child: const Text('OK'),
                                        ),
                                      ],
                                    )
                                );
                                
                          });
                        },
                        child: Card(
                          borderOnForeground: true,
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Your request for your project ',
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      TextSpan(
                                         text: storedocs[i]['Title'],
                                       style: const TextStyle(
                                         fontWeight: FontWeight.bold,
                                       fontFamily: 'OpenSans')),
                                      const TextSpan(text: 'has '),
                                      TextSpan(
                                          text: storedocs[i]['Status'],
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans')),
                                    ],
                                  ),
                                )

                              //Text('You got a request for your project ${postinfo[i]['Title']} by ${userinfo[i]['UserName']} '),
                            ),
                          ),
                        ),
                      )
                          :storedocs[i]['Type'] == 'Requests'? GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ManageRequest(reqID: storedocs[i]['id'])),
                          );
                        },
                        child: Card(
                          borderOnForeground: true,
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'You got a request for your project ',
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.black),
                                    children: <TextSpan>[
                                       TextSpan(
                                        text: '${storedocs[i]['Title']}',
                                       style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                       fontFamily: 'OpenSans')),
                                      const TextSpan(text: ' by '),
                                      TextSpan(
                                          text: '${userinfo[i]['UserName']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans')),
                                    ],
                                  ),
                                )

                              //Text('You got a request for your project ${postinfo[i]['Title']} by ${userinfo[i]['UserName']} '),
                            ),
                          ),
                        ),
                      ):GestureDetector(
                        onTap: () {
                          FirebaseFirestore.instance.collection('Users').doc(
                              auth.currentUser!.uid).collection('Notification')
                              .doc(storedocs[i]['id']).delete().then((value) {
                           Navigator.push(
                             context,
                             MaterialPageRoute(
                                 builder: (context) =>
                                     const PendingPaymentPage()),);
                          });
                        },
                        child: Card(
                          borderOnForeground: true,
                          child: Container(
                            width: double.infinity,
                            child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 5),
                                child: RichText(
                                  text: TextSpan(
                                    text: 'Your Project has been submitted',
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        color: Colors.black),
                                    children: <TextSpan>[
                                      // TextSpan(
                                      //   text: '${postinfo[i]['Title']}',
                                      // style: const TextStyle(
                                      //   fontWeight: FontWeight.bold,
                                      // fontFamily: 'OpenSans')),
                                      const TextSpan(text: ' by '),
                                      TextSpan(
                                          text: '${userinfo[i]['UserName']}',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans')),
                                    ],
                                  ),
                                )

                              //Text('You got a request for your project ${postinfo[i]['Title']} by ${userinfo[i]['UserName']} '),
                            ),
                          ),
                        ),
                      )

                    ]
                  ],
                ),
              ),
            ),
          ) : Center(child: Text('No Notifications'));
        });
  }
}
