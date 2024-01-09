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
  var _screens2= [];
  var _selectedIndex = 0;
  //var _size = 0;
  var UserType='';
  void checkUser(){
    FirebaseFirestore.instance.collection('FreeLancer').doc(FirebaseAuth.instance.currentUser!.uid).get().then((value){
      if(value.exists){
        setState(() {
          UserType='FreeLancer';
        });
      }
      else{
        setState(() {
          UserType='Users';
        });
      }
      _screens = [
        const FeedPage(),
        NotificationPage(UserType: UserType,),
        ProfilePage(UserType: UserType,)
      ];
      _screens2 = [
        const AddPage(),
        NotificationPage(UserType: UserType,),
        ProfilePage(UserType: UserType,)
      ];

    });

  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }


  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
   // checkUser();
    print(UserType);
   // print(_size);
   // print('@@@@@@@@@@@@@@@@@@@@');
    return Padding(
      padding: const EdgeInsets.only(top: 62),
      child: Scaffold(
        body: UserType!=''?SafeArea(
          child: UserType=='FreeLancer'?_screens[_selectedIndex]:_screens2[_selectedIndex],
        ): const Center(child: CircularProgressIndicator()),
        bottomNavigationBar: BottomNavigationBar(
          selectedItemColor: Colors.lightBlueAccent,
          unselectedItemColor: Colors.black,
          items: [

            UserType=='FreeLancer'?const BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'):
            const BottomNavigationBarItem(icon: Icon(Icons.add), label: 'Add'),
            const BottomNavigationBarItem(
                icon: ImageIcon(AssetImage('Assets/Logo/nonotification.png')),
                label: 'Notifications'),
            const BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
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
