import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rideshare/Screens/shareride.dart';
import '../Utills/utills.dart';

class CarDetailScreen extends StatefulWidget {
  const CarDetailScreen({super.key});

  @override
  State<CarDetailScreen> createState() => _CarDetailScreenState();
}

class _CarDetailScreenState extends State<CarDetailScreen> {
  final _formKey = GlobalKey<FormState>();
  final carTypeController = TextEditingController();
  final carNumberController = TextEditingController();
  final seatController = TextEditingController();
  bool isDefault = false;
  bool isLoading = false;

  final databaseRef = FirebaseDatabase.instance.ref('CarInfo');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  void addCarDetail() {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    setState(() {
      isLoading = true;
    });

    databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
      'id': uid,
      'carModel': carTypeController.text.toString(),
      'carNumber': carNumberController.text.toString(),
      'Seats': seatController.text.toString(),
      'isDefault': isDefault,
    }).then((value) {
      setState(() {
        isLoading = false;
      });

      // Navigator.pushNamed(context, "/editScreen").then((value) {
      //   if (value) // if true and you have come back to your Settings screen
      //     yourSharedPreferenceCode();
      // });

      Utills().toastSuccessMessage("Car Information added successfully!");
      Navigator.pop(context);
      // Navigator.of(context)
      //     .pushReplacement(MaterialPageRoute(
      //         builder: (BuildContext context) => const ShareRide()))
      //     .then(onGoBack);
    }).catchError((error) {
      Utills().toastFaiureMessage(error.message);
      setState(() {
        isLoading = false;
      });
    });
  }

  FutureOr onGoBack(dynamic value) {
    // refreshData();
    initState();
    // setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
    carTypeController.dispose();
    carNumberController.dispose();
    seatController.dispose();
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
                height: 100,
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 10, 0.0, 0.0),
                    child: Text(
                      "Add Car",
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
                    padding: EdgeInsets.fromLTRB(26, 0.0, 8.0, 0.0),
                    child: Text(
                      "Details !",
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
                    const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: carTypeController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Car model";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Car Model',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          prefixIcon: Icon(Icons.directions_car),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: carNumberController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter car number";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Car Number ',
                          prefixIcon: Icon(Icons.app_registration_rounded),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: seatController,
                      keyboardType: TextInputType.number,
                      inputFormatters: <TextInputFormatter>[
                        FilteringTextInputFormatter.digitsOnly
                      ],
                      validator: (value) {
                        var numValue = int.tryParse(value!);

                        if (value.isEmpty) {
                          return "Please enter no of seats";
                        } else if (numValue! >= 7 && numValue < 0) {
                          return "Enter number between 1 to 6";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Number of seats  ',
                          prefixIcon:
                              Icon(Icons.airline_seat_recline_normal_sharp),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Checkbox(
                          value: isDefault,
                          onChanged: (bool? value) {
                            setState(() {
                              isDefault = value!;
                            });
                          },
                        ),
                        const Text(
                          'Make Defalut',
                          style: TextStyle(
                              fontSize: 14.0,
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 50,
                    ),
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
                            addCarDetail();
                          }
                        },
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Save Details',
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
