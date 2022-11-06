import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/PayAndFeedbackPage.dart';

class PendingPaymentPage extends StatefulWidget {
  const PendingPaymentPage({Key? key}) : super(key: key);

  @override
  State<PendingPaymentPage> createState() => _PendingPaymentPageState();
}

class _PendingPaymentPageState extends State<PendingPaymentPage> {
  FirebaseAuth auth = FirebaseAuth.instance;
  List postinfo = [];
  List userinfo = [];

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("Users")
            .doc(auth.currentUser!.uid)
            .collection('PendingPayment')
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Text("Error");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            // return const Center(
            //  child: CircularProgressIndicator(),
            // );
          }
          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id'] = document.id;
          }).toList();
          // print(storedocs);
          // print('*****************');
          for (var i = 0; i < storedocs.length; i++) {
            FirebaseFirestore.instance
                .collection("Posts")
                .doc(storedocs[i]['PostId'])
                .get()
                .then((value) async {
              if (value.exists) {
                Map b = value.data() as Map<String, dynamic>;
                setState(() {
                  postinfo.add(b);
                });
                //print(postinfo);
              }
              postinfo.toList(growable: true);
            }).onError((error, stackTrace) {
              print(error.toString());
            });
          }
          for (var i = 0; i < storedocs.length; i++) {
            FirebaseFirestore.instance
                .collection("FreeLancer")
                .doc(storedocs[i]['UserId'])
                .get()
                .then((value) async {
              if (value.exists) {
                Map c = value.data() as Map<String, dynamic>;
                setState(() {
                  userinfo.add(c);
                });
                //print(postinfo);
              }
              userinfo.toList(growable: true);
            }).onError((error, stackTrace) {
              print(error.toString());
            });
          }
          return postinfo.isEmpty
              ? const Scaffold(
              body: Center(
                child: Text('No Payment Left'),
              ))
              : Scaffold(
            appBar: AppBar(
              title: const Text('Pending Payments'),
            ),
            body: SingleChildScrollView(
              child: Column(
                children: [
                  for (var i = 0; i < storedocs.length; i++) ...[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) =>PayAndFeedbackPage(payid: storedocs[i]['id'])));
                        },
                        child: Card(
                          elevation: 15,
                          borderOnForeground: true,
                          child: SizedBox(
                            //height: 50,
                            width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10),
                              child: Column(
                                children: [
                                  Text(
                                    postinfo[i]['Title'],
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.lightBlueAccent),
                                  ),
                                  Text(
                                    'To:' + userinfo[i]['UserName'],
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Text(
                                    "Rs." + storedocs[i]['PayAmount'],
                                    style: const TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                  ),

                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ]
                ],
              ),
            ),
          );
        });
  }
}
