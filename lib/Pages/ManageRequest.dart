import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'Main_page.dart';
import 'OtherPfPage.dart';

class ManageRequest extends StatefulWidget {
  final reqID;

  const ManageRequest({Key? key, required this.reqID}) : super(key: key);

  @override
  State<ManageRequest> createState() => _ManageRequestState();
}

class _ManageRequestState extends State<ManageRequest> {
  FirebaseAuth auth = FirebaseAuth.instance;
  final List UserDetail = [];
  final List PostDetail = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
            future: FirebaseFirestore.instance
                .collection('Users')
                .doc(auth.currentUser?.uid)
                .collection('Notification')
                .doc(widget.reqID)
                .get(),
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Text("Error!!!!");
              }
              // if (snapshot.connectionState == ConnectionState.waiting) {
              // return const Center(
              // child: CircularProgressIndicator(),
              // );
              //}
              var data = snapshot.data?.data();
              var postID = data!['PostId'];
              var userID = data['UserId'];
              FirebaseFirestore.instance
                  .collection("Posts")
                  .doc(postID)
                  .get()
                  .then((value) async {
                Map Post = value.data() as Map<String, dynamic>;
                setState(() {
                  PostDetail.add(Post);
                });
                PostDetail.toList();
              });

              FirebaseFirestore.instance
                  .collection("Users")
                  .doc(userID)
                  .get()
                  .then((value) async {
                Map User = value.data() as Map<String, dynamic>;
                setState(() {
                  UserDetail.add(User);
                });
                UserDetail.toList();
              });
              var title = PostDetail[0]['Title'];
              var description = PostDetail[0]['Description'];
              var amount = PostDetail[0]['Budget'];
              var deadline = PostDetail[0]['Deadline'];
              // print(PostDetail);
              // print(UserDetail);
              // print("************************");

              return PostDetail.isNotEmpty && UserDetail.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                                fontSize: 50,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 30,
                          ),
                          SizedBox(
                            width: 350,
                            child: Center(
                              child: Text(
                                description,
                                style: const TextStyle(
                                    fontSize: 20,
                                    fontFamily: 'OpenSans',
                                    color: Colors.grey),
                              ),
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
                          Text(
                            deadline,
                            style: const TextStyle(
                              fontSize: 30,
                              fontFamily: 'OpenSans',
                            ),
                          ),
                          const Text(
                            "Requested By:",
                            style: TextStyle(
                                fontSize: 25,
                                fontFamily: 'OpenSans',
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 10),
                          GestureDetector(
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          OtherPfPage(UserId: userID)),
                                );
                              },
                              child: Text(
                                UserDetail[0]['UserName'],
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'OpenSans',
                                  fontSize: 20,
                                  color: Colors.lightBlueAccent,
                                  decoration: TextDecoration.underline,
                                ),
                              )),
                          const SizedBox(
                            height: 30,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Accept'),
                                            content: const Text(
                                                'Accept the request??'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  CollectionReference
                                                      Notification =
                                                      FirebaseFirestore.instance
                                                          .collection('Users')
                                                          .doc(userID)
                                                          .collection(
                                                              'Notification');

                                                  Notification.doc().set({
                                                    'PostId': postID,
                                                    'Title':title,
                                                    'Type': "Confirmation",
                                                    'Status': 'Accepted',
                                                    'Timestamp':Timestamp.now()
                                                  }).then((value) {
                                                    FirebaseFirestore.instance
                                                        .collection('Users')
                                                        .doc(userID)
                                                        .collection(
                                                        'PendingJobs')
                                                        .doc(postID)
                                                        .set({
                                                      'PostId': postID,
                                                    });
                                                  }).then((value) {
                                                    FirebaseFirestore.instance
                                                        .collection('Users')
                                                        .doc(auth
                                                            .currentUser!.uid)
                                                        .collection(
                                                            'Notification')
                                                        .doc(widget.reqID)
                                                        .delete()
                                                        .then((value) {
                                                      FirebaseFirestore.instance
                                                          .collection('Posts')
                                                          .doc(postID)
                                                          .update({
                                                        'RequestStatus':
                                                            'Requested'
                                                      });
                                                    }).then((value) {
                                                      showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    'Done!!'),
                                                                content: const Text(
                                                                    "The FreeLancer has been notified....."),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const MainPage()),
                                                                      );
                                                                    },
                                                                    child: const Text(
                                                                        'Return to home'),
                                                                  ),
                                                                ],
                                                              ));
                                                    });
                                                  });
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ));
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.lightBlueAccent,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Accept',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  showDialog<String>(
                                      context: context,
                                      builder: (BuildContext context) =>
                                          AlertDialog(
                                            title: const Text('Reject'),
                                            content: const Text(
                                                'Reject the request??'),
                                            actions: <Widget>[
                                              TextButton(
                                                onPressed: () => Navigator.pop(
                                                    context, 'OK'),
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  CollectionReference
                                                      Notification =
                                                      FirebaseFirestore.instance
                                                          .collection('Users')
                                                          .doc(userID)
                                                          .collection(
                                                              'Notification');

                                                  Notification.doc().set({
                                                    'PostId': postID,
                                                    'Type': "Confirmation",
                                                    'Status': 'Rejected',
                                                    'Timestamp':Timestamp.now()
                                                  }).then((value) {
                                                    FirebaseFirestore.instance
                                                        .collection('Users')
                                                        .doc(auth
                                                            .currentUser!.uid)
                                                        .collection(
                                                            'Notification')
                                                        .doc(widget.reqID)
                                                        .delete()
                                                        .then((value) {
                                                      showDialog<String>(
                                                          context: context,
                                                          builder: (BuildContext
                                                                  context) =>
                                                              AlertDialog(
                                                                title: const Text(
                                                                    'Done!!'),
                                                                content: const Text(
                                                                    "The FreeLancer has been notified....."),
                                                                actions: <
                                                                    Widget>[
                                                                  TextButton(
                                                                    onPressed:
                                                                        () {
                                                                      Navigator
                                                                          .push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                const MainPage()),
                                                                      );
                                                                    },
                                                                    child: const Text(
                                                                        'Return to home'),
                                                                  ),
                                                                ],
                                                              ));
                                                    });
                                                  });
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ));
                                },
                                child: Container(
                                  height: 40,
                                  width: 100,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.redAccent,
                                  ),
                                  child: const Center(
                                    child: Text(
                                      'Reject',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    );
            }));
  }
}
