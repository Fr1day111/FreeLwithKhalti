import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/DetailPage.dart';

class FeedPage extends StatefulWidget {
  const FeedPage({Key? key}) : super(key: key);


  @override
  State<FeedPage> createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  String Uname='';
  final FirebaseAuth auth = FirebaseAuth.instance;
  Future<void>  getUserName(id) async {
    var collection = FirebaseFirestore.instance.collection('Users');
    var docSnapshot = await collection.doc(id).get();
    if (docSnapshot.exists) {
      Map<String, dynamic>? data = docSnapshot.data();
      String value =  data!['UserName'];
      Uname=value;
    }
  }

  final Stream<QuerySnapshot> postsStream =
      FirebaseFirestore.instance.collection("Posts").orderBy('TimeStamp',descending: false).snapshots();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: postsStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {}
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          final List storedocs = [];
          snapshot.data!.docs.map((DocumentSnapshot document) {
            Map a = document.data() as Map<String, dynamic>;
            storedocs.add(a);
            a['id']=document.id;
          }).toList();


          return Scaffold(
            body: SingleChildScrollView(
              child: SafeArea(
                child: Column(
                  children: [
                    for (var i = 0; i < storedocs.length; i++) ...[
                      if(storedocs[i]['UserId'] != auth.currentUser!.uid && storedocs[i]['RequestStatus']=='Waiting')...[
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: GestureDetector(
                          onTap: (){
                            Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                 DetailPage(postid: storedocs[i]['id'],)),
                          );

                          },
                          child: Card(
                            elevation: 15,
                            borderOnForeground: true,
                            shadowColor: Colors.lightBlueAccent,
                            child: Container(
                              width: double.infinity,
                              //height: 150,
                             // decoration: BoxDecoration(
                               //   boxShadow: [
                                 //   BoxShadow(
                                   //     color: Colors.grey.shade600,
                                     //   spreadRadius: 1,
                                       // blurRadius: 10,
                                        //offset: const Offset(0, 15))
                                  //],
                                  //color: Colors.grey[350],
                                  //borderRadius: BorderRadius.circular(20)),
                              child: Column(
                                children: [
                                  Text(
                                    storedocs[i]['Title'],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontFamily: 'OpenSans',
                                        fontSize: 29),
                                  ),
                                  Padding(
                                    padding:
                                        const EdgeInsets.symmetric(horizontal: 10),
                                    child: Text(
                                      storedocs[i]['Description'],
                                      style:
                                          const TextStyle(fontFamily: 'OpenSans'),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'Budget:',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans',
                                              color: Colors.black,
                                              fontSize: 15),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: storedocs[i]['Budget']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueAccent)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10.0),
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: RichText(
                                        text: TextSpan(
                                          text: 'DeadLine:',
                                          style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'OpenSans',
                                              color: Colors.black,
                                              fontSize: 15),
                                          children: <TextSpan>[
                                            TextSpan(
                                                text: storedocs[i]['Deadline']
                                                    .toString(),
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    color: Colors.blueAccent)),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: Text('Catagory:${storedocs[i]['Type']}',
                                        style: const TextStyle(
                                            fontFamily: 'OpenSans', fontSize: 15,fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                     ]
                    ]
                  ],
                ),
              ),
            ),
          );
        });
  }
}
