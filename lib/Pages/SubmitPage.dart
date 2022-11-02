import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/HomePage.dart';

class SubmitPage extends StatefulWidget {
  final postid;
  final jobid;

  const SubmitPage({Key? key, required this.postid,required this.jobid}) : super(key: key);

  @override
  State<SubmitPage> createState() => _SubmitPageState();
}

class _SubmitPageState extends State<SubmitPage> {
  final _submitform = GlobalKey<FormState>();
  final TextEditingController _link = new TextEditingController();
  FirebaseAuth auth = FirebaseAuth.instance;

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
        } else {
          var data = snapshot.data!.data();
          var title = data!['Title'];
          var description = data['Description'];
          var amount = data['Budget'];
          var deadline = data['Deadline'];
          var userid = data['UserId'].toString();
          var type = data['Type'];

          return Form(
            key: _submitform,
            child: Padding(
              padding: const EdgeInsets.only(top: 20, left: 10),
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

                  Text(
                    type,
                    style: const TextStyle(
                        fontSize: 15,
                        fontFamily: 'OpenSans',
                        color: Colors.grey),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    width: double.infinity,
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
                  const SizedBox(height: 10),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text(
                      "Push Your Final project on Github or GoogleDrive and link here",
                      style: TextStyle(
                          fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: TextFormField(
                      controller: _link,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return 'This field cant be empty';
                        }
                        return null;
                      },
                      decoration: InputDecoration(
                        label: const Text(
                          'Project Link',
                          style: TextStyle(fontFamily: 'OpenSans'),
                        ),
                        filled: true,
                        fillColor: Colors.grey[200],
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  GestureDetector(
                    onTap: () {
                      if (_submitform.currentState!.validate()) {
                        _submitform.currentState!.save();
                        showDialog<String>(
                            context: context,
                            builder: (BuildContext context) => AlertDialog(
                                  title: const Text('Are you sure?'),
                                  content: Text(
                                      'You cant change it after submission..'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () {
                                        CollectionReference Notification =
                                            FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(userid)
                                                .collection('Notification');
                                        Notification.doc().set({
                                          'PostId': widget.postid,
                                          'UserId': auth.currentUser!.uid,
                                          'Type': 'Submitted',
                                          'Timestamp': Timestamp.now()
                                        }).then((value) {
                                          FirebaseFirestore.instance
                                              .collection('Posts')
                                              .doc(widget.postid)
                                              .update({
                                            'Submission': 'Done',
                                            'ProjectUrl': _link.text
                                          }).then((value) {
                                            FirebaseFirestore.instance
                                                .collection('Users')
                                                .doc(userid)
                                                .collection('PendingPayment')
                                                .doc()
                                                .set({
                                              'UserId': auth.currentUser!.uid,
                                              'PayAmount': amount,
                                              'PostId': widget.postid,
                                              'Status': 'Not Paid'
                                            }).then((value) {
                                             FirebaseFirestore.instance
                                                  .collection('Users')
                                                  .doc(auth.currentUser!.uid)
                                                  .collection('PendingJobs')
                                                  .doc(widget.jobid).delete().then((value) {
                                              showDialog<String>(
                                                  context: context,
                                                  builder:
                                                      (BuildContext context) =>
                                                          AlertDialog(
                                                            title: const Text(
                                                                'Done!!'),
                                                            content: const Text(
                                                                'Submission Sucessfull'),
                                                            actions: <Widget>[
                                                              TextButton(
                                                                onPressed: () => Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (context) =>
                                                                                HomePage())),
                                                                child:
                                                                    const Text(
                                                                        'OK'),
                                                              ),
                                                            ],
                                                          ));}).onError((error, stackTrace) {
                                                            //print(error.toString());
                                                            //print("****************");
                                             });
                                            });
                                          });
                                        });
                                      },
                                      child: const Text('Submit'),
                                    ),
                                    TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, 'cancel'),
                                      child: const Text('Cancel'),
                                    ),
                                  ],
                                ));
                      }
                    },
                    child: Container(
                        height: 70,
                        width: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.lightBlueAccent,
                        ),
                        child: const Center(
                            child: Text(
                          'Submit',
                          style: TextStyle(
                              fontFamily: 'OpenSans',
                              fontWeight: FontWeight.bold),
                        ))),
                  ),
                  //     ),
                  //   ),
                  //),
                ],
              ),
            ),
          );
        }
      },
    ))));
  }
}
