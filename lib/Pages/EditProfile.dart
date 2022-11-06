import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_document_picker/flutter_document_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projectfirst/Pages/Main_page.dart';
import 'dart:io';

import 'package:projectfirst/Pages/ProfilePage.dart';

class EditProfile extends StatefulWidget {
  final String UserType;
  const EditProfile({Key? key,required this.UserType}) : super(key: key);

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final FirebaseAuth auth = FirebaseAuth.instance;
  final _editform = GlobalKey<FormState>();
  TextEditingController _UserNameController = TextEditingController();
  TextEditingController _BioController = TextEditingController();
  TextEditingController _PhoneNoController = TextEditingController();
  TextEditingController _SpecialityController = TextEditingController();
  TextEditingController _HighestEduController = TextEditingController();
  TextEditingController _AchivementController = TextEditingController();
  TextEditingController _TrainingController = TextEditingController();
  String pfpUrl = " ";
  String pdfUrl=" ";
  void picUploadImage(name) async {
    final image = await ImagePicker().pickImage(
        source: ImageSource.gallery,
        maxHeight: 512,
        maxWidth: 512,
        imageQuality: 75);
    Reference ref =
    FirebaseStorage.instance.ref().child('Pfp').child(name+'.jpg');
    await ref.putFile(File(image!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        pfpUrl= value;
      });
    //  print(pfpUrl);
    //  print("**********");
    });
  }
  void pickUploadCV(name) async {
    final path = await FlutterDocumentPicker.openDocument();
    File file = File(path!);
    Reference ref =
    FirebaseStorage.instance.ref().child('CVs').child(name+'.pdf');
    await ref.putFile(File(file!.path));
    ref.getDownloadURL().then((value) {
      setState(() {
        pdfUrl= value;
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
            key: _editform,
            child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection(widget.UserType)
                  .doc(auth.currentUser!.uid)
                  .get(),
              builder: (_, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                var data = snapshot.data!.data();
                var name = data!['UserName'];
                var bio = data['Bio'];
                var number = data['PhoneNo'];
                var pfp = data['pfpUrl'].toString();
                var cvUrl = data['cvUrl'].toString();
                var speciality=data['Speciality'];
                var highedu=data['HighEdu'];
                var Achievement=data['Achievement'];
                var Training=data['Training'];
                var rating=data['Rating'];
                _UserNameController = TextEditingController(text: name);
                _BioController = TextEditingController(text: bio);
                _PhoneNoController = TextEditingController(text: number);
                _SpecialityController = TextEditingController(text: speciality);
                _AchivementController=TextEditingController(text: Achievement);
                _TrainingController=TextEditingController(text: Training);
                _HighestEduController=TextEditingController(text: highedu);
                pfp!=' '? pfpUrl=pfp:null;
                cvUrl!=' '? pdfUrl=cvUrl:null;

                //print(pfpUrl);
                //print("@@@@@@@@@@@@");

                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
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

                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () {
                                   picUploadImage(name);
                                  //print(pfpUrl);
                                 // print('@@@@@@@@@@@@@@@@');
                                },
                                child: const Text(
                                  'Change Pic',
                                  style: TextStyle(
                                      color: Colors.blueAccent,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'OpenSans',
                                      fontSize: 15),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  // initialValue: name,
                                  controller: _UserNameController,
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return 'This field cant be empty';
                                    }
                                    return null;
                                  },
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    label: const Text('UserName'),
                                    hintText: 'User Name',
                                    hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  controller: _PhoneNoController,
                                  // initialValue: number,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    label: const Text("Phone Number"),
                                    hintText: 'Phone Number',
                                    hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 25, right: 25),
                                child: TextFormField(
                                  // initialValue: bio,
                                  controller: _BioController,
                                  decoration: InputDecoration(
                                    filled: true,
                                    fillColor: Colors.grey[200],
                                    label: const Text('About Me:'),
                                    hintText: 'About Me',
                                    hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                  ),
                                ),
                              ),
                              widget.UserType=='FreeLancer'?Column(
                                children: [
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 25, right: 25,top: 10),
                                    child: TextFormField(
                                      // initialValue: bio,
                                      controller: _SpecialityController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        label: const Text('Speciality:'),
                                        hintText: 'Speciality',
                                        hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      minLines: 3,
                                      maxLines: 5,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 25, right: 25,top: 10),
                                    child: TextFormField(
                                      // initialValue: bio,
                                      controller: _HighestEduController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        label: const Text('Highest Education'),
                                        hintText: 'Highest Education',
                                        hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      minLines: 3,
                                      maxLines: 5,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 25, right: 25,top: 10),
                                    child: TextFormField(
                                      // initialValue: bio,
                                      controller:_AchivementController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        label: const Text('Achievement'),
                                        hintText: 'Achievement',
                                        hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      minLines: 3,
                                      maxLines: 5,
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                    const EdgeInsets.only(left: 25, right: 25,top: 10),
                                    child: TextFormField(
                                      // initialValue: bio,
                                      controller: _TrainingController,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.grey[200],
                                        label: const Text('Training'),
                                        hintText: 'Trainings',
                                        hintStyle:
                                        const TextStyle(fontFamily: 'OpenSans'),
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                      ),
                                      minLines: 3,
                                      maxLines: 5,
                                    ),
                                  ),
                                ],
                              ):Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              //Text(cvUrl==""?
                              //""
                              //: cvUrl),
                              widget.UserType=='FreeLancer'?Container(
                                height: 100,
                                width: 330,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.grey),
                                child:  Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      pdfUrl==" "?
                                      const Text('No File Attached'):
                                      const Text("File Attached"),
                                      GestureDetector(
                                        onTap: (){
                                          pickUploadCV(name);
                                        },
                                        child: Container(
                                          height: 40,
                                          width: 200,
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(25),
                                            color: Colors.lightBlueAccent,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              'Upload Your CV(Pdf Only)',
                                              style: TextStyle(
                                              fontFamily: 'OpenSans',
                                              fontWeight: FontWeight.bold),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ):Container(),
                              const SizedBox(
                                height: 10,
                              ),
                              GestureDetector(
                                onTap: () async {
                                 // print('************************');
                                 // print(cvUrl);
                                 // print(pfpUrl);
                                  FirebaseFirestore.instance
                                      .collection(widget.UserType)
                                      .doc(auth.currentUser!.uid)
                                      .update({
                                    'Speciality': _SpecialityController.text,
                                    'UserName': _UserNameController.text,
                                    'PhoneNo': _PhoneNoController.text,
                                    'Bio': _BioController.text,
                                    'Email': auth.currentUser!.email,
                                    'pfpUrl': pfpUrl,
                                    'cvUrl' : pdfUrl,
                                    'HighEdu':_HighestEduController.text,
                                    'Achievement':_AchivementController.text,
                                    'Training':_TrainingController.text
                                 // var highedu=data['HighEdu'];
                                 // var Achievement=data['Achievement'];
                                 // var Training=data['Training'];
                                  //var rating=data['Rating'];
                                  }).then((value) {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => const MainPage()),
                                    );
                                  }).onError((error, stackTrace) async {
                                    showDialog<String>(
                                        context: context,
                                        builder: (BuildContext context) =>
                                            AlertDialog(
                                              title: const Text('Error'),
                                              content: Text(error.toString()),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () => Navigator.pop(
                                                      context, 'OK'),
                                                  child: const Text('OK'),
                                                ),
                                              ],
                                            ));
                                  });
                                },
                                child: Container(
                                  height: 50,
                                  width: 300,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    color: Colors.lightBlueAccent,
                                  ),
                                  child: const Center(
                                      child: Text(
                                    'Confirm',
                                    style: TextStyle(
                                        fontFamily: 'OpenSans',
                                        fontWeight: FontWeight.bold),
                                  )),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
      ),
    );
  }
}
