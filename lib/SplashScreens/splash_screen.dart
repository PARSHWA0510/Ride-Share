import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/Auth/loginscreen.dart';
import 'package:rideshare/MainScreen/main_screen.dart';

class MySplashScreen extends StatefulWidget {
  const MySplashScreen({super.key});

  @override
  State<MySplashScreen> createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  void isUserLogin() {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;

    if (user == null) {
      startTimer();
    } else {
      Timer(const Duration(seconds: 3), () async {
        //send user to home screen
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (c) => MainScreen()));
      });
    }
  }

  startTimer() {
    Timer(const Duration(seconds: 3), () async {
      //send user to home screen
      Navigator.push(context, MaterialPageRoute(builder: (c) => LoginPage()));
    });
  }

  @override
  void initState() {
    super.initState();
    isUserLogin();
    // startTimer();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset("assets/images/carlogo.png"),
          const SizedBox(
            height: 10,
          ),
        ]),
      ),
    );
  }
}
