import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'Main_page.dart';

class AddPage extends StatefulWidget {
  const AddPage({Key? key}) : super(key: key);

  @override
  State<AddPage> createState() => _AddPageState();
}

class _AddPageState extends State<AddPage> {
  final _signupform = GlobalKey<FormState>();
  final TextEditingController dateController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController budgetController = TextEditingController();
  final TextEditingController RequirementController = TextEditingController();
  CollectionReference Posts = FirebaseFirestore.instance.collection('Posts');
  final FirebaseAuth auth = FirebaseAuth.instance;
  String _chosenValue ='Mobile App';
  final List Projecttype = ['Mobile App', 'Website', 'Java Application'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: null,
      //backgroundColor: Colors.lightBlue,
      body: Container(
        decoration: const BoxDecoration(
            //  image: DecorationImage(
            //     image: AssetImage("Assets/Photos/bg.png"), fit: BoxFit.fill),
            ),
        child: Form(
          key: _signupform,
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Register Your Job!!!',
                    style: TextStyle(
                        fontSize: 30,
                        fontFamily: 'OpenSans',
                        color: Colors.lightBlueAccent),
                  ),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: TextFormField(
                            controller: titleController,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field cant be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              label: const Text(
                                'Project Title',
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
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: TextFormField(
                            controller: budgetController,
                            keyboardType: TextInputType.number,
                            validator: (value) {
                              if (value!.isEmpty) {
                                return 'This field cant be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.grey[200],
                              label: const Text(
                                'Budget',
                                style: TextStyle(fontFamily: 'OpenSans'),
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Center(
                            child: TextFormField(
                              controller: descriptionController,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field can\'t be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                label: const Text(
                                  'Description of project',
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25,top: 10),
                          child: Center(
                            child: TextFormField(
                              controller: RequirementController,
                              keyboardType: TextInputType.multiline,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field can\'t be empty';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                label: const Text(
                                  'Minimum Requirement for project',
                                  style: TextStyle(fontFamily: 'OpenSans'),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              minLines: 3,
                              maxLines: 5,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 25, right: 25),
                          child: Center(
                            child: TextFormField(
                              controller: dateController,
                              //editing controller of this TextField
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: Colors.grey[200],
                                icon: const Icon(Icons.calendar_today),
                                //icon of text field
                                labelText: "Enter Deadline",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                              ),
                              readOnly: true,
                              // when true user cannot edit text
                              onTap: () async {
                                DateTime? pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  //get today's date
                                  firstDate: DateTime(2000),
                                  //DateTime.now() - not to allow to choose before today.
                                  lastDate: DateTime(2101),
                                );
                                if (pickedDate != null) {
                                  String formattedDate = DateFormat.yMMMd().format(
                                      pickedDate); // format date in required form here we use yyyy-MM-dd that means time is removed
                                  setState(() {
                                    dateController.text = formattedDate;
                                  });
                                }
                              },
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'This field can\'t be empty';
                                }
                                return null;
                              },
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text('Project Type:'),
                            DropdownButton(
                              hint: Text('Choose Your Project Type'),
                                value: _chosenValue,
                                items: Projecttype.map((valueItem) {
                                  return DropdownMenuItem(
                                    child: Text(valueItem),
                                    value: valueItem,
                                  );
                                }).toList(),
                                onChanged: (newValue){
                                  setState(() {
                                    _chosenValue=newValue.toString();
                                  });
                                }),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),
                        GestureDetector(
                          onTap: () async {
                            if (_signupform.currentState!.validate()) {
                              _signupform.currentState!.save();
                              Posts.add({
                                'UserId': auth.currentUser!.uid,
                                'Title': titleController.text.trim(),
                                'Budget': budgetController.text.trim(),
                                'Description':
                                    descriptionController.text.trim(),
                                'Requirement':RequirementController.text,
                                'Deadline': dateController.text.trim(),
                                'Type':_chosenValue,
                                'RequestStatus':'Waiting',
                                'Submission':'Not Done',
                                'ProjectUrl':" ",
                                'TimeStamp': Timestamp.now()
                              }).then((value) {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Done'),
                                          content: Text("Your Job Request has been posted\nWe will notify you once you have any request.."),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () {
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => const MainPage()),
                                                );

                                                },

                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ));

                              }).onError((error, stackTrace) async {
                                showDialog<String>(
                                    context: context,
                                    builder: (BuildContext context) =>
                                        AlertDialog(
                                          title: const Text('Error'),
                                          content: Text(error.toString()),
                                          actions: <Widget>[
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, 'OK'),
                                              child: const Text('OK'),
                                            ),
                                          ],
                                        ));
                              });
                            }
                          },
                          child: Container(
                            height: 70,
                            width: 350,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(15),
                              color: Colors.lightBlueAccent,
                            ),
                            child: const Center(
                                child: Text(
                              'Register',
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
          ),
        ),
      ),
    );
  }
}
