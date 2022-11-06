import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/SubmitPage.dart';

class PendinJobPage extends StatefulWidget {
  const PendinJobPage({Key? key}) : super(key: key);

  @override
  State<PendinJobPage> createState() => _PendinJobPageState();
}

class _PendinJobPageState extends State<PendinJobPage> {
  final List postinfo=[];
  FirebaseAuth auth =FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('FreeLancer').doc(auth.currentUser!.uid).collection('PendingJobs').snapshots(),
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
        a['id']=document.id;
      }).toList();
      for (var i = 0; i < storedocs.length; i++) {
        FirebaseFirestore.instance
            .collection("Posts")
            .doc(storedocs[i]['PostId'])
            .get()
            .then((value) async{
          if (value.exists) {
            Map b = value.data() as Map<String, dynamic>;
            setState(() {
              postinfo.add(b);
            });
            //print(postinfo);
          }
          postinfo.toList(growable: true);
        }).onError((error, stackTrace) {
          print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        });
        // print(postinfo);
        //Map a = post.data() as Map<String, dynamic>;
      }

        return postinfo.isNotEmpty ?Scaffold(
          appBar: AppBar(title: const Text('Pending Jobs'),),
          body: SingleChildScrollView(
            child: Column(
              children: [
            for (var i = 0; i < storedocs.length; i++) ...[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                child: GestureDetector(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => SubmitPage(postid: storedocs[i]['PostId'], jobid: storedocs[i]['id'],)),
                    );
                  },
                  child: Card(elevation: 15,
                    borderOnForeground: true,
                    child: SizedBox(
                      //height: 50,
                      width: double.infinity,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              children: [
                                Text(postinfo[i]['Title'],style: const TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold
                                ),),
                                Text(postinfo[i]['Description'],style: const TextStyle(
                                    fontFamily: 'OpenSans',
                                    fontWeight: FontWeight.bold,
                                  color: Colors.grey
                                ),),
                                Text('Deadline:'+postinfo[i]['Deadline'],style: const TextStyle(
                                  fontFamily: 'OpenSans'
                                ),)
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
        ):const Scaffold(body: Center(child: Text('No Job Pending')));
        });
  }
}
