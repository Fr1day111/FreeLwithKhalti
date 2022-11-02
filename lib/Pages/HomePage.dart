import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/AddPage.dart';
import 'package:projectfirst/Pages/FeedPage.dart';
import 'package:projectfirst/Pages/NotificationPage.dart';
import 'package:projectfirst/Pages/ProfilePage.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  var _screens = [];
  var _selectedIndex = 0;
  var _size = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _screens = [
      const FeedPage(),
      const AddPage(),
      const NotificationPage(),
      const ProfilePage()
    ];
  }

  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    FirebaseFirestore.instance
        .collection('User')
        .doc(auth.currentUser!.uid)
        .collection('Notification')
        .get()
        .then((value) {
      setState(() {
        _size = value.size;
      });
    });
   // print(_size);
   // print('@@@@@@@@@@@@@@@@@@@@');
    return Padding(
      padding: const EdgeInsets.only(top: 62),
      child: Scaffold(
        body: SafeArea(
          child: _screens[_selectedIndex],
        ),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            BottomNavigationBarItem(
                icon: ImageIcon(_size != 0
                    ? AssetImage('Assets/Logo/notification.png')
                    : AssetImage('Assets/Logo/nonotification.png')),
                label: 'Notifications'),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
          currentIndex: _selectedIndex,
          onTap: (index) {
            setState(() {
              _selectedIndex = index;
            });
          },
        ),
      ),
    );
  }
}
