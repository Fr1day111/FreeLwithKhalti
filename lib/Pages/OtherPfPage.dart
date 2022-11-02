import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rating_bar/rating_bar.dart';

import 'ProfilePage.dart';

class OtherPfPage extends StatefulWidget {
  final UserId;
  const OtherPfPage({Key? key,required this.UserId}) : super(key: key);

  @override
  State<OtherPfPage> createState() => _OtherPfPageState();
}

class _OtherPfPageState extends State<OtherPfPage> {
  List userinfo=[];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection('Users')
                  .doc(widget.UserId)
                  .get(),
              builder: (_, snapshot) {
               // if (snapshot.connectionState == ConnectionState.waiting) {
                 // return const Center(
                   // child: CircularProgressIndicator(),
                  //);
               // }
                var data = snapshot.data!.data();
                var name = data!['UserName'];
                var bio = data['Bio'].toString();
                var mail =data['Email'];
                var pfpUrl = data['pfpUrl'].toString();
                var cvUrl = data['cvUrl'].toString();
                return SafeArea(
                  child: Container(
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Column(
                          children: [
                            pfpUrl==' '? Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(200),
                                  image: const DecorationImage(
                                      fit: BoxFit.fill,
                                      image:
                                      AssetImage('Assets/Logo/logomain.png')
                                  )),
                              //  child: CircleAvatar(
                              //  radius: 80.0,
                              // backgroundColor: Colors.transparent,
                              //child: pfpUrl == " "
                              //  ? const ImageIcon(
                              //    AssetImage('Assets/Logo/logomain.png'),
                              //  size: 110,
                              // )
                              // : Image.network(pfpUrl),
                              //),
                            ):Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                  color: Colors.blueAccent,
                                  borderRadius: BorderRadius.circular(200),
                                  image: DecorationImage(
                                    fit: BoxFit.fill,
                                    image:
                                    NetworkImage(pfpUrl),
                                  )),
                              //  child: CircleAvatar(
                              //  radius: 80.0,
                              // backgroundColor: Colors.transparent,
                              //child: pfpUrl == " "
                              //  ? const ImageIcon(
                              //    AssetImage('Assets/Logo/logomain.png'),
                              //  size: 110,
                              // )
                              // : Image.network(pfpUrl),
                              //),
                            ),
                            const SizedBox(
                              height: 12,
                            ),
                            Text(
                              name,
                              style: const TextStyle(
                                  fontSize: 40, fontFamily: 'OpenSans'),
                            ),
                            bio == "null"
                                ? Text(""):
                            Text(bio,
                              style: const TextStyle(
                                  fontSize: 30,
                                  fontFamily: 'OpenSans',
                                  color: Colors.grey),
                            ),

                            const SizedBox(
                              height: 40,
                            ),
                            cvUrl!=" "?GestureDetector(
                              onTap: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        cvView(pdfUrl:cvUrl)),
                              );},
                              child: Card(
                                elevation: 8,
                                child: Container(
                                  //height: 70,
                                  width: double.infinity,
                                  color: Colors.lightBlueAccent,
                                  child: const ListTile(
                                    contentPadding:
                                    EdgeInsets.symmetric(horizontal: 20.0),
                                    title: Text(
                                      'User CV',
                                      style: TextStyle(
                                          fontFamily: 'OpenSans',
                                          fontWeight: FontWeight.bold),
                                    ),
                                    trailing: Icon(Icons.arrow_forward_ios),
                                    leading: Icon(Icons.file_present_sharp),
                                  ),
                                ),
                              ),
                            ):const Text(" "),
                            const SizedBox(
                              height: 5,
                            ),
                            const Text("Contact Info:",style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
                            Text(mail,style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),),
                            const Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text('Feedbacks:',
                                style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'
                                ),),
                            ),
                            const Divider(color: Colors.black87,
                              thickness: 10,),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('Users')
                                    .doc(widget.UserId)
                                    .collection('Feedback')
                                    .snapshots(),
                                builder: (BuildContext context,
                                    AsyncSnapshot<QuerySnapshot> snapshot) {
                                  final List storedocs = [];
                                  snapshot.data?.docs.map((DocumentSnapshot document) {
                                    Map a = document.data() as Map<String, dynamic>;
                                    a['id'] = document.id;
                                    storedocs.add(a);
                                  }).toList();
                                  // for (var i = 0; i < storedocs.length; i++) {
                                  // sum=num.parse(storedocs[i]['Rating'].toString()).toDouble()+ sum;
                                  //}
                                  //double newrating=sum/(storedocs.length+1);
                                  //FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.uid).update({
                                  //'Rating':newrating.toString(),
                                  //});
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
                                  }
                                  return storedocs.isNotEmpty?
                                  Column(
                                    children: [
                                      for (var i = 0; i < storedocs.length; i++) ...[
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Card(
                                            elevation: 8,
                                            child: Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Column(
                                                children: [
                                                  Text(userinfo[i]['UserName'],style: TextStyle(
                                                      fontSize: 20,
                                                      fontFamily: 'OpenSans'
                                                  ),),
                                                  RatingBar.readOnly(
                                                    initialRating: num.parse(storedocs[i]['Rating'].toString()).toDouble(),
                                                    isHalfAllowed: true,
                                                    halfFilledIcon: Icons.star_half,
                                                    filledIcon: Icons.star,
                                                    emptyIcon: Icons.star_border,
                                                    size: 40,
                                                  ),
                                                  Text(storedocs[i]['Feedback'],style: TextStyle(
                                                      fontWeight: FontWeight.bold,
                                                      fontSize: 15
                                                  ),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        )
                                      ]
                                    ],

                                  ):const Center(child: Text('No Feedback'));
                                })
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              })),
    );
  }
}
