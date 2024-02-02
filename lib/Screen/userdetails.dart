import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import '../Auth/loginscreen.dart';
import '../TabPages/acc_tab.dart';
import '../Utills/utills.dart';
import '../Widgets/mybutton.dart';

class UserDetailsScreen extends StatefulWidget {
  const UserDetailsScreen({super.key});

  @override
  State<UserDetailsScreen> createState() => _UserDetailsScreenState();
}

class _UserDetailsScreenState extends State<UserDetailsScreen> {
  DatabaseReference ref = FirebaseDatabase.instance.ref("UserInfo");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool isLoading = false;
  var name;
  var profession;
  var org;
  var dob;

  Future<void> getUserData() async {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    Query query = ref.orderByChild("id").equalTo(uid);
    DataSnapshot dataSnapshot = await query.get();
    (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
      setState(() {
        name = value['name'];
        profession = value['profession'];
        org = value['org'];
        dob = value['dob'];
      });

      print("------------------------");
      print(name);
    });
  }

  void signout() {
    FirebaseAuth.instance.signOut();
    GoogleSignIn().signOut();
    setState(() {
      isLoading = true;
    });
    _auth.signOut().then((value) {
      setState(() {
        isLoading = false;
      });

      Utills().toastSuccessMessage("Successfully Loged out!");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage()));
    }).catchError((error) {
      Utills().toastFaiureMessage(error.message);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.topRight,
                colors: <Color>[
                  Color.fromARGB(255, 100, 145, 236),
                  Color.fromARGB(255, 69, 204, 231),
                ]),
          ),
        ),
        leading: GestureDetector(
          child: const Icon(
            Icons.arrow_back_ios,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: const Text("User Details"),
      ),
      body: Form(
        child: Column(
          children: [
            TextFormField(
                style: const TextStyle(fontSize: 14),
                readOnly: true,
                enabled: false,
                decoration: InputDecoration(
                  hintText: name,
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 203, 202, 202)),
                  prefixIcon: const Icon(
                    Icons.circle,
                    color: Colors.lightBlue,
                    size: 15,
                  ),
                )),
            TextFormField(
                style: const TextStyle(fontSize: 14, color: Colors.black),
                readOnly: true,
                // enabled: false,
                decoration: InputDecoration(
                  hintText: profession,
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 203, 202, 202)),
                  prefixIcon: const Icon(
                    Icons.circle,
                    color: Colors.lightBlue,
                    size: 15,
                  ),
                )),
            TextFormField(
                style: const TextStyle(fontSize: 14),
                readOnly: true,
                // enabled: false,
                decoration: InputDecoration(
                  hintText: dob,
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 203, 202, 202)),
                  prefixIcon: const Icon(
                    Icons.circle,
                    color: Colors.lightBlue,
                    size: 15,
                  ),
                )),
            TextFormField(
                style: const TextStyle(fontSize: 14),
                readOnly: true,
                // enabled: true,
                decoration: InputDecoration(
                  hintText: org,
                  labelStyle: const TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 203, 202, 202)),
                  prefixIcon: const Icon(
                    Icons.circle,
                    color: Colors.lightBlue,
                    size: 15,
                  ),
                )),
            SizedBox(
              height: 20,
            ),
            MyElevatedButton(
              width: 250,
              onPressed: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (BuildContext context) => AccountTabScreen(
                          name: name,
                          profession: profession,
                          dob: dob,
                          org: org,
                        )));
              },
              borderRadius: BorderRadius.circular(20),
              child: const Text(
                'UPDATE DETAILS',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            MyElevatedButton(
              width: 250,
              onPressed: () {
                signout();
              },
              borderRadius: BorderRadius.circular(20),
              child: const Text(
                'LOGOUT',
                style: TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
