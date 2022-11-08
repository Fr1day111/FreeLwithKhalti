import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/EditProfile.dart';
import 'package:projectfirst/Pages/Main_page.dart';
import 'package:projectfirst/Pages/MyPosts.dart';
import 'package:projectfirst/Pages/PendingJobPage.dart';
import 'package:projectfirst/Pages/SignInPage.dart';
import 'package:projectfirst/main.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:rating_bar/rating_bar.dart';

import 'PendingPaymentPage.dart';

class ProfilePage extends StatefulWidget {
  final String UserType;
  const ProfilePage({Key? key,required this.UserType}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  double sum=0;
  List userinfo = [];
  final FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      body: SingleChildScrollView(
          child: auth.currentUser!.uid == null
              ? Center(
                  child: ElevatedButton(
                      onPressed: () {
                        auth.signOut();
                      },
                      child: const Text('Back')),
                )
              : FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  future: FirebaseFirestore.instance
                      .collection(widget.UserType.toString())
                      .doc(auth.currentUser?.uid)
                      .get(),
                  builder: (_, snapshot) {
                    if (snapshot.hasError) {
                      auth.signOut();
                    }
                //    if (snapshot.connectionState == ConnectionState.waiting) {
                  //    return const Center(
                    //    child: CircularProgressIndicator(),
                      //);
                    //}
                   // snapshot.data!.data()!=null?
                  // if(snapshot.connectionState==ConnectionState.done){
                    var data = snapshot.data!.data();
                    var name = data!['UserName'];
                    var bio = data['Bio'].toString();
                    var pfpUrl = data['pfpUrl'].toString();
                    var cvUrl = data['cvUrl'].toString();
                    var speciality=data['Speciality'].toString();
                    var highedu=data['HighEdu'].toString();
                    var Achievement=data['Achievement'].toString();
                    var Training=data['Training'].toString();
                    return snapshot.data!.data()!=null?SafeArea(
                      child: Container(
                        child: Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Column(
                            children: [
                              pfpUrl == ' '
                                  ? Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          image: const DecorationImage(
                                              fit: BoxFit.fill,
                                              image: AssetImage(
                                                  'Assets/Logo/logomain.png'))),
                                    )
                                  : Container(
                                      height: 150,
                                      width: 150,
                                      decoration: BoxDecoration(
                                          color: Colors.blueAccent,
                                          borderRadius:
                                              BorderRadius.circular(200),
                                          image: DecorationImage(
                                            fit: BoxFit.fill,
                                            image: NetworkImage(pfpUrl),
                                          )),
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
                                  ? const Text("Add Bio First")
                                  : Text(
                                      bio,
                                      style: const TextStyle(
                                          fontSize: 30,
                                          fontFamily: 'OpenSans',
                                          color: Colors.grey),
                                    ),
                              const SizedBox(
                                height: 20,
                              ),
                              if (widget.UserType=='FreeLancer') Column(
                                children: [
                                  const Divider(thickness: 5,color: Colors.lightBlueAccent,),
                                  const Text('Speciality:',style: TextStyle(
                                      fontSize: 20, fontFamily: 'OpenSans'),),
                                  //Divider(thickness: 5,color: Colors.lightBlueAccent,),
                                  Text(speciality,style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'OpenSans'
                                  ),),
                                  const Divider(thickness: 5,color: Colors.lightBlueAccent,),
                                  const Text('Achievement:',style: TextStyle(
                                      fontSize: 20, fontFamily: 'OpenSans'),),
                                 // Divider(thickness: 5,color: Colors.lightBlueAccent,),
                                  Text(Achievement,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans'
                                  ),),
                                  const Divider(thickness: 5,color: Colors.lightBlueAccent,),
                                  const Text('Highest Education:',style: TextStyle(
                                      fontSize: 20, fontFamily: 'OpenSans'),),
                                 // Divider(thickness: 5,color: Colors.lightBlueAccent,),
                                  Text(highedu,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans'
                                  ),),
                                  const Divider(thickness: 5,color: Colors.lightBlueAccent,),
                                  const Text('Trainings:',style: TextStyle(
                                      fontSize: 20, fontFamily: 'OpenSans'),),
                                  // Divider(thickness: 5,color: Colors.lightBlueAccent,),
                                  Text(Training,style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans'
                                  ),),

                                ],
                              ) else Container(),

                              const SizedBox(
                                height: 20,
                              ),
                              widget.UserType=='FreeLancer'?GestureDetector(
                                onTap: () {
                                  cvUrl != " "
                                      ? Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  cvView(pdfUrl: cvUrl)),
                                        )
                                      : AlertDialog(
                                          title: const Text('Error'),
                                          content: const Text(
                                              "Upload Your CV first"),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        );
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Container(
                                    //height: 70,
                                    width: double.infinity,
                                    color: Colors.lightBlueAccent,
                                    child: const ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      title: Text(
                                        'My CV',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      leading: Icon(Icons.file_present_sharp),
                                    ),
                                  ),
                                ),
                              ):Container(),
                              // SizedBox(
                              // height: 5,
                              //),
                              GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                             EditProfile(UserType: widget.UserType,)),
                                  );
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Container(
                                    //height: 70,
                                    width: double.infinity,
                                    color: Colors.lightBlueAccent,
                                    child: const ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      title: Text(
                                        'Edit Profile',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      leading: Icon(Icons.edit),
                                    ),
                                  ),
                                ),
                              ),
                              widget.UserType=='Users'?GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                        const MyPostPage()),
                                  );
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Container(
                                    //height: 70,
                                    width: double.infinity,
                                    color: Colors.lightBlueAccent,
                                    child: const ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      title: Text(
                                        'My Posts',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      leading: Icon(Icons.account_circle_sharp),
                                    ),
                                  ),
                                ),
                              ):Container(),
                              widget.UserType=='FreeLancer'?GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PendinJobPage()),
                                  );
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Container(
                                    //height: 70,
                                    width: double.infinity,
                                    color: Colors.lightBlueAccent,
                                    child: const ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      title: Text(
                                        'Pending Jobs',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      leading: Icon(Icons.pending_actions),
                                    ),
                                  ),
                                ),
                              ):Container(),
                              widget.UserType=='Users'?GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const PendingPaymentPage()),
                                  );
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Container(
                                    //height: 70,
                                    width: double.infinity,
                                    color: Colors.lightBlueAccent,
                                    child: const ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      title: Text(
                                        'Pending Payments',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      leading: Icon(Icons.payment_sharp),
                                    ),
                                  ),
                                ),
                              ):Container(),

                              GestureDetector(
                                onTap: () {
                                  FirebaseAuth.instance.signOut().then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const MyHomePage(title: 'Ntg')),
                                    );
                                  });
                                },
                                child: Card(
                                  elevation: 8,
                                  child: Container(
                                    //height: 70,
                                    width: double.infinity,
                                    color: Colors.lightBlueAccent,
                                    child: const ListTile(
                                      contentPadding: EdgeInsets.symmetric(
                                          horizontal: 20.0),
                                      title: Text(
                                        'Log Out',
                                        style: TextStyle(
                                            fontFamily: 'OpenSans',
                                            fontWeight: FontWeight.bold),
                                      ),
                                      trailing: Icon(Icons.arrow_forward_ios),
                                      leading: Icon(Icons.logout),
                                    ),
                                  ),
                                ),
                              ),
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
                                      .collection('FreeLancer')
                                      .doc(auth.currentUser!.uid)
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
                                                  Text(userinfo[i]['UserName'],style: const TextStyle(
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
                                                  Text(storedocs[i]['Feedback'],style: const TextStyle(
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
                    ):CircularProgressIndicator();

                  })),
    );
  }
}

class cvView extends StatelessWidget {
  PdfViewerController _pdfViewerController = PdfViewerController();
  final pdfUrl;

  cvView({this.pdfUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("User's CV")),
      body: pdfUrl == null
          ? const Center(
              child: Text("No CV found"),
            )
          : SfPdfViewer.network(
              pdfUrl,
              controller: _pdfViewerController,
            ),
    );
  }
}
