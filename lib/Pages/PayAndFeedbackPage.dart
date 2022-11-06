import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:projectfirst/Pages/HomePage.dart';
import 'package:projectfirst/Payment/KhaltiScope.dart';
import 'package:rating_bar/rating_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class PayAndFeedbackPage extends StatefulWidget {
  final payid;
  const PayAndFeedbackPage({Key? key,required this.payid}) : super(key: key);

  @override
  State<PayAndFeedbackPage> createState() => _PayAndFeedbackPageState();
}

class _PayAndFeedbackPageState extends State<PayAndFeedbackPage> {
  final _feedbackform = GlobalKey<FormState>();
  final TextEditingController _feedbackController=new TextEditingController();
  var _rating=null;
  List postinfo=[];
  List userinfo=[];
  FirebaseAuth auth =FirebaseAuth.instance;
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        future: FirebaseFirestore.instance
        .collection("Users").doc(auth.currentUser!.uid).collection('PendingPayment')
        .doc(widget.payid)
        .get(),
    builder: (_, snapshot) {
    // if(snapshot.hasError){}
    //if (snapshot.connectionState == ConnectionState.waiting) {
    //return const Center(
    //child: CircularProgressIndicator(),
    //);
   // }
    var data = snapshot.data!.data();
    var userid=data!['UserId'];
    var amount=data['PayAmount'];
    var postid=data['PostId'];
    FirebaseFirestore.instance
        .collection("FreeLancer")
        .doc(userid)
        .get()
        .then((value) async {
      if (value.exists) {
        Map c = value.data() as Map<String, dynamic>;
        setState(() {
          userinfo.add(c);
        });
        //print(postinfo);
      }
      userinfo.toList(growable: true);
    }).onError((error, stackTrace) {
      print(error.toString());
    });
    FirebaseFirestore.instance
        .collection("Posts")
        .doc(postid)
        .get()
        .then((value) async {
      if (value.exists) {
        Map c = value.data() as Map<String, dynamic>;
        setState(() {
          postinfo.add(c);
        });
        //print(postinfo);
      }
      postinfo.toList(growable: true);
    }).onError((error, stackTrace) {
      print(error.toString());
    });
        return Scaffold(
            appBar: AppBar(title: const Text('Pay Now'),),
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text("Project Title:"+postinfo[0]['Title'],
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),),
                    Text("Pay to:"+userinfo[0]['UserName'],
                    style: const TextStyle(
                      fontSize: 25,
                      fontWeight: FontWeight.bold
                    ),),
                    Text("Amount: Rs"+amount,
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                      ),),
                    const Text("Project Location:",
                      style: TextStyle(
                          fontSize: 15,
                          //fontWeight: FontWeight.bold
                      ),),
                    GestureDetector(
                      onTap: () async{
                        final url=Uri.parse(postinfo[0]['ProjectUrl']);
                        print(url);
                        print('**********************apple***');
                        if(await canLaunchUrl(url)){
                          await launchUrl(url);
                        }
                        else{

                          showDialog<String>(
                              context: context,
                              builder:
                                  (BuildContext context) =>
                                  AlertDialog(
                                    title: const Text(
                                        'Error!!'),
                                    content: const Text(
                                        'Cant Open the Project'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context,'ok');
                                        },
                                        child:
                                        const Text(
                                            'OK'),
                                      ),
                                    ],
                                  ));

                        }
                      },
                      child: Text(postinfo[0]['ProjectUrl'],
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          color: Colors.lightBlueAccent,
                          fontSize: 25,
                          fontWeight: FontWeight.bold
                        ),),
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>KhaltiPaymentApp(PhoneNo: userinfo[0]['PhoneNo'],Amt:amount ,)));
                      },
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
                              'Khalti',
                              style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold),
                            ),
                            trailing: Icon(Icons.arrow_forward_ios),
                            leading: ImageIcon(AssetImage('Assets/Logo/KhaltiLogo.png'),size: 35,),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20,),
                    Container(
                      //height: 250,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.shade600,
                                spreadRadius: 1,
                                blurRadius: 15,
                                offset: const Offset(0, 15))
                          ],
                          color: Colors.grey[350],
                          borderRadius: BorderRadius.circular(10)),
                      child: Form(
                        key: _feedbackform,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            children: [
                              const Text('Rate Your Experience:',style: TextStyle(
                                  fontFamily: 'OpenSans',
                                  fontWeight: FontWeight.bold,
                              fontSize: 20),),
                              const SizedBox(height: 15,),
                              RatingBar(
                                onRatingChanged: (rating) {setState(() => _rating = rating);},
                                filledIcon: Icons.star,
                                emptyIcon: Icons.star_border,
                                halfFilledIcon: Icons.star_half,
                                isHalfAllowed: true,
                                filledColor: Colors.lightBlueAccent,
                                emptyColor: Colors.lightBlueAccent,
                                halfFilledColor: Colors.lightBlueAccent,
                                size: 48,
                              ),
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: TextFormField(
                                  controller: _feedbackController,
                                 // controller: descriptionController,
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
                                      'Feedback',
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
                            ],
                          ),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: (){
                        if(_feedbackform.currentState!.validate()){
                          _feedbackform.currentState!.save();
                          if(_rating==null){
                            showDialog<String>(
                                context: context,
                                builder: (BuildContext context) => AlertDialog(
                                  title: const Text(''),
                                  content:const Text('Please rate your expericence...'),
                                  actions: <Widget>[
                                    TextButton(
                                      onPressed: () => Navigator.pop(context, 'OK'),
                                      child: const Text('OK'),
                                    ),
                                  ],
                                )
                            );
                          }
                            FirebaseFirestore.instance.collection('FreeLancer').doc(userid).collection('Feedback').doc().set({
                              'Rating':_rating,
                              'Feedback':_feedbackController.text,
                              'UserId': auth.currentUser!.uid
                            }).then((value) {
                              FirebaseFirestore.instance.collection('Users').doc(auth.currentUser!.uid).collection('PendingPayment').doc(widget.payid).delete();
                            }).then((value) {
                              //var feedback=FirebaseFirestore.instance.collection('Users').doc(userid).collection('Feedback').get();
                              //var length=feedback.;
                              showDialog<String>(
                                  context: context,
                                  builder: (BuildContext context) => AlertDialog(
                                    title: const Text('Payment Successful!!'),
                                    content:const Text('Thank You for your feedback!!'),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.push(context, MaterialPageRoute(builder: (context)=>const HomePage()));
                                        },
                                        child: const Text('Return to HomePage'),
                                      ),
                                    ],
                                  )
                              );
                              //
                            });
                        }
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 19.0),
                        child: Container(
                          height: 70,
                          width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            color: Colors.lightBlueAccent,
                          ),
                          child: const Center(
                              child: Text(
                                'Register',
                                style: TextStyle(
                                    fontFamily: 'OpenSans', fontWeight: FontWeight.bold),
                              )),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ));});
  }
}
