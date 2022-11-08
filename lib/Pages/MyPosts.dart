import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MyPostPage extends StatefulWidget {
  const MyPostPage({Key? key}) : super(key: key);

  @override
  State<MyPostPage> createState() => _MyPostPageState();
}

class _MyPostPageState extends State<MyPostPage> {
  FirebaseAuth auth=FirebaseAuth.instance;
  final Stream<QuerySnapshot> postsStream =
  FirebaseFirestore.instance.collection("Posts").orderBy('TimeStamp').snapshots();
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
                      if(storedocs[i]['UserId'] == auth.currentUser!.uid )...[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Card(
                            elevation: 15,
                            borderOnForeground: true,
                            shadowColor: Colors.lightBlueAccent,
                            child: Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children:[ Container(
                                  width: 300,
                                  child: Column(
                                    children: [
                                      Text(
                                        'Job Title:'+storedocs[i]['Title'],
                                        style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                            fontSize:15),
                                      ),
                                      const Text(
                                        'Job Description:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                            fontSize:15),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                          //height: 100,
                                          width: double.infinity,
                                          color: Colors.lightBlueAccent,
                                          child: Text(
                                            storedocs[i]['Description'],
                                            style: const TextStyle(
                                                fontFamily: 'OpenSans'),
                                          ),
                                        ),
                                      ),
                                      const Text(
                                        'Requirement for Job:',
                                        style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'OpenSans',
                                            fontSize:15),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Container(
                                         // height: 100,
                                          width: double.infinity,
                                          color: Colors.lightBlueAccent,
                                          child: Text(
                                            storedocs[i]['Requirement'],
                                            style: const TextStyle(
                                                fontFamily: 'OpenSans'),
                                          ),
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
                                              text: 'Budget: ',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'OpenSans',
                                                  color: Colors.black,
                                                  fontSize: 15),
                                              children: <TextSpan>[
                                                TextSpan(
                                                    text:'Rs.'+ storedocs[i]['Budget']
                                                        .toString(),
                                                    style: const TextStyle(
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color:
                                                        Colors.lightBlueAccent)),
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
                                              text: 'DeadLine: ',
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
                                                        fontWeight:
                                                        FontWeight.bold,
                                                        color:
                                                        Colors.lightBlueAccent)),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            'Catagory:${storedocs[i]['Type']}',
                                            style: const TextStyle(
                                                fontFamily: 'OpenSans',
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text('Status:${storedocs[i]['RequestStatus']}',
                                            style: const TextStyle(
                                                fontFamily: 'OpenSans', fontSize: 15,fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                      ),
                                      if(storedocs[i]['Submission']=='Done')...[
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Expanded(
                                          flex: 4,
                                          child: Align(
                                            alignment: Alignment.centerLeft,
                                            child: Text('Project Location:${storedocs[i]['ProjectUrl']}',
                                              style: const TextStyle(
                                                  fontFamily: 'OpenSans', fontSize: 15,fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),],
                                      SizedBox(height: 10,)
                                    ],
                                  ),
                                ),
                              //  Divider(height:20,thickness: 20,color: Colors.black87,),
                                GestureDetector(
                                    onTap: (){
                                      if(storedocs[i]['RequestStatus']!='Requested'){
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Delete'),
                                              content:Text('Are you sure to delete the post??'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'Cancel'),
                                                  child: const Text('Cancel'),
                                                ),
                                                TextButton(
                                                  onPressed: (){
                                                    FirebaseFirestore.instance.collection('Posts').doc(storedocs[i]['id']).delete().then((value){
                                                      Navigator.pop(context,'Deleted');
                                                    });
                                                  },
                                                  child: const Text('Yes'),
                                                ),
                                              ],
                                            )
                                        );
                                      }
                                      else{
                                        showDialog<String>(
                                            context: context,
                                            builder: (BuildContext context) => AlertDialog(
                                              title: const Text('Error'),
                                              content:Text('Cant Be Deleted'),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            )
                                        );
                                      }

                                    },
                                    child: Icon(Icons.delete))
                                ]
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
