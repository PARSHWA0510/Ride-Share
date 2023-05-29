import 'dart:developer';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rideshare/Auth/forgetpassword.dart';
import 'package:rideshare/Auth/signupscreen.dart';
import 'package:rideshare/MainScreen/main_screen.dart';

import 'package:rideshare/helpers/Dialogs.dart';
import '../Utills/utills.dart';
import '../api/apis.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool isLoading = false;

  final _auth = FirebaseAuth.instance;

  void login() {
    setState(() {
      isLoading = true;
    });
    _auth
        .signInWithEmailAndPassword(
            email: emailController.text.toString(),
            password: passwordController.text.toString())
        .then((value) {
      setState(() {
        isLoading = false;
      });

      Utills().toastSuccessMessage("Login is successful!");

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
    }).catchError((error) {
      Utills().toastFaiureMessage(error.message);
      setState(() {
        isLoading = false;
      });
    });
  }

  handleGoogleBtnlick(){
    Dialogs.showProgressBar(context);
    _signInWithGoogle().then((user) async => {
      Navigator.pop(context),
      if(user!=null)
        {
          log('\nUser: ${user.user}'),
          log('\nUserAdditionalInfo: ${user.additionalUserInfo}'),

          if((await APIs.userExists()))
            {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (_) => MainScreen())),
            }else{
            APIs.createUser().then((value) => Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => MainScreen())),)
          }


        }

    });
  }

  Future<UserCredential?> _signInWithGoogle() async {
    try{
      await InternetAddress.lookup("google.com");
      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

      // Obtain the auth details from the request
      final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken,
        idToken: googleAuth?.idToken,
      );

      // Once signed in, return the UserCredential
      return await APIs.auth.signInWithCredential(credential);
    }
    catch(e){
      log('\n_signInWithGoogle : $e');
    }
    Dialogs.showSnackbar(context, 'Something Went wrong, Check your Internet Connection');
    return null;
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: false,
      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Container(
            child: Column(children: [
              const SizedBox(
                height: 100,
              ),

              Image(
                //
                height: 250,

                image: AssetImage("assets/images/signUp.jpg"),
              ),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 10, 0.0, 0.0),
                    child: Text(
                      "Hello There 😃",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.indigo,
                      ),
                    ),
                  )
                ],
              ),
              SizedBox(height: 20),
              Container(
                //padding: const EdgeInsets.only(top: 35.0, left: 20.0, right: 20.0),
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                width: 320.0,
                height: 600.0,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, 15.0),
                        blurRadius: 15.0),
                    BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0.0, -10.0),
                        blurRadius: 10.0)
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter email";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'EMAIL',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          prefixIcon: Icon(Icons.alternate_email),
                          // hintText: 'EMAIL',
                          // hintStyle: ,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: passwordController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter password";
                        } else {
                          return null;
                        }
                      },
                      obscureText: true,
                      decoration: const InputDecoration(
                          labelText: 'PASSWORD ',
                          prefixIcon: Icon(Icons.lock),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),

                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ForgetPassword()));
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 8),
                              child: Text(
                                "Forgot Password?",
                                //style: simpleTextStyle(),
                              )),
                        )
                      ],
                    ),

                    const SizedBox(height: 100.0),

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
                            login();
                          }
                        },
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                )
                              : const Text(
                                  'LOGIN',
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
                          // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          //     content: Text('This is a Sign In With Google functionality')));
                          handleGoogleBtnlick();
                        },

                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                            strokeWidth: 3,
                            color: Colors.white,
                          )
                              : const Text(
                            'Sign In With Google ',
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
                        const Text("Don't have an account?"),
                        TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          const SignUpPage()));
                            },
                            child: const Text("Create"))
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
