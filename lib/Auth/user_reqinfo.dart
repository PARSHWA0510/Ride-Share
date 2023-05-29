import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/Auth/loginscreen.dart';

import '../Utills/utills.dart';

class RequiredInfoScreen extends StatefulWidget {
  const RequiredInfoScreen({super.key});

  @override
  State<RequiredInfoScreen> createState() => _RequiredInfoScreenState();
}

class _RequiredInfoScreenState extends State<RequiredInfoScreen> {
  final _formKey = GlobalKey<FormState>();
  final phoneController = TextEditingController();
  final referenceController = TextEditingController();
  final professionController = TextEditingController();
  final organizationController = TextEditingController();
  bool isCarAdded = false;
  bool isLoading = false;
  final FirebaseAuth auth = FirebaseAuth.instance;

  final databaseRef = FirebaseDatabase.instance.ref('AdditionalSignUpInfo');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void saveExtraInfo() {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    setState(() {
      isLoading = true;
    });
    databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
      'id': uid,
      'phone': phoneController.text.toString(),
      'ref_phone': referenceController.text.toString(),
      'profession': professionController.text.toString(),
      'organization': organizationController.text.toString(),
      'isCarAdded': isCarAdded,
    }).then((value) {
      setState(() {
        isLoading = false;
      });

      Utills().toastSuccessMessage("Information added successfully!");

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
  void dispose() {
    super.dispose();
    phoneController.dispose();
    referenceController.dispose();
    organizationController.dispose();
    professionController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(children: [
              const SizedBox(
                height: 90,
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 10, 0.0, 0.0),
                    child: Text(
                      "Tell Us ",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(24, 0.0, 8.0, 0.0),
                    child: Text(
                      "More !",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 60,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.only(top: 32.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: phoneController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter phone number";
                        } else if (value.length != 10) {
                          return "Please enter proper phone number";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'PHONE NUMBER',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          prefixIcon: Icon(Icons.phone),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: referenceController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Reference phone number";
                        } else if (value.length != 10) {
                          return "Please enter proper reference number";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'REFERENCE PHONE NUMBER ',
                          prefixIcon: Icon(Icons.phone),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: professionController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter yout profession";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'YOUR PROFESSION ',
                          prefixIcon: Icon(Icons.work),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: organizationController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter organization ";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'ORGANIZATION',
                          prefixIcon: Icon(Icons.location_city),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(height: 70.0),
                    SizedBox(
                      height: 50.0,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shadowColor: Colors.blueAccent,
                          backgroundColor: Colors.blue,
                          elevation: 7.0, //elevation of button
                          shape: RoundedRectangleBorder(
                              //to set border radius to button
                              borderRadius: BorderRadius.circular(20)),
                        ),
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            saveExtraInfo();
                          }
                        },
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                )
                              : const Text(
                                  'SAVE',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Row(
                              children: const [
                                Center(
                                  child: Text(
                                    "We need this information for security purpose and give",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            Row(
                              children: const [
                                Center(
                                  child: Text(
                                    "you better experience with our app",
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    )
                  ],
                ),
              )
            ]),
          ),
        ),
      ),
    );
  }
}
