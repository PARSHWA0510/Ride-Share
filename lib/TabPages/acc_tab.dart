import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/Screen/userdetails.dart';
import 'package:image_picker/image_picker.dart';
import '../Utills/utills.dart';
import '../Widgets/mybutton.dart';

class AccountTabScreen extends StatefulWidget {
  final name;
  final profession;
  final dob;
  final org;

  const AccountTabScreen(
      {super.key,required this.name,required this.profession, required this.dob, required this.org});

  @override
  State<AccountTabScreen> createState() => _AccountTabScreenState();
}

class _AccountTabScreenState extends State<AccountTabScreen> {

  PickedFile? imageFile;
  final ImagePicker picker = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final professionController = TextEditingController();
  final dobController = TextEditingController();
  final orgController = TextEditingController();
  bool isDefault = false;
  bool isLoading = false;
  bool isUserAdded = false;

  final databaseRef = FirebaseDatabase.instance.ref('UserInfo');
  final FirebaseAuth _auth = FirebaseAuth.instance;

  checkUser() async {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    Query query = databaseRef.orderByChild("id").equalTo(uid);
    DataSnapshot dataSnapshot = await query.get();
    // print("------------------------")
    if (dataSnapshot.value != null) {
      setState(() {
        isUserAdded = true;
      });
    }
  }

  // void signout() {
  //   setState(() {
  //     isLoading = true;
  //   });
  //   _auth.signOut().then((value) {
  //     setState(() {
  //       isLoading = false;
  //     });

  //     Utills().toastSuccessMessage("Successfully Loged out!");
  //     Navigator.of(context).pushReplacement(MaterialPageRoute(
  //         builder: (BuildContext context) => const LoginPage()));
  //   }).catchError((error) {
  //     Utills().toastFaiureMessage(error.message);
  //     setState(() {
  //       isLoading = false;
  //     });
  //   });
  // }

  void saveuserinfo() {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    setState(() {
      isLoading = true;
    });

    databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
      'id': uid,
      'name': nameController.text.toString(),
      'profession': professionController.text.toString(),
      'dob': dobController.text.toString(),
      'org': orgController.text.toString(),
    }).then((value) {
      setState(() {
        isLoading = false;
      });

      Utills().toastSuccessMessage("User Information added successfully!");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => UserDetailsScreen()));
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

  @override
  void initState() {
    // TODO: implement initState

    super.initState();
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    checkUser();
    dobController.text = widget.dob;
    nameController.text = widget.name;
    professionController.text = widget.profession;
    orgController.text = widget.org;
  }

  @override
  void dispose() {
    super.dispose();
    nameController.dispose();
    dobController.dispose();
    orgController.dispose();
    professionController.dispose();
  }

  @override
  Widget build(BuildContext context) {

        void takephoto(ImageSource source) async {
      final pickedFile = await picker.getImage(
        source: source,
      );
      setState(() {
        imageFile = pickedFile;
      });
    }

    Widget bottomsheet() {
      print("----------inside bottomsheet");
      return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            const Text(
              "Choose Profile Photo",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ElevatedButton.icon(
                  icon: Icon(Icons.camera),
                  onPressed: () {
                    takephoto(ImageSource.camera);
                  },
                  label: Text("Camera"),
                ),
                SizedBox(width: 40),
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  onPressed: () {
                    takephoto(ImageSource.gallery);
                  },
                  label: Text("Gallery"),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget imageprofile() {
      // print(context.widget);
      return Center(
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 80.0,
              //backgroundImage: imageFile==null? AssetImage("images/avtar.png") : FileImage(File(imageFile.path)),
              backgroundImage: imageFile == null
                  ? AssetImage('assets/images/accountAvatar.jpg')
                      as ImageProvider
                  : FileImage(File(imageFile!.path)),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: () {
                  showBottomSheet(
                    context: context,
                    builder: ((builder) => bottomsheet()),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 28,
                ),
              ),
            )
          ],
        ),
      );
    }


    return Scaffold(

      body: SingleChildScrollView(

        child: Form(

          key: _formKey,
          child: Container(
            child: Column(children: [
              const SizedBox(
                height: 50,
              ),
              imageprofile(),
              // Text("Display Mail id here"),
              const SizedBox(
                height: 20,
              ),
              //Image(image: NetworkImage("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSI4sNJuaust87EFcGgHqyCxo9A50Tj05UGVg&usqp=CAU"),),
              Row(
                children: const [
                  Padding(
                    padding: EdgeInsets.fromLTRB(26, 10, 0.0, 0.0),
                    child: Text(
                      "Add User Details ",
                      style: TextStyle(
                        fontFamily: "Montserrat",
                        fontSize: 30,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                  )
                ],
              ),
             SizedBox(
               height: 20,
             ),
              Container(
                padding: EdgeInsets.fromLTRB(30.0, 10.0, 30.0, 10.0),
                width: 320.0,
                height: 500.0,
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
                      controller: nameController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter name";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          prefixIcon: Icon(Icons.person),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width :2))),
                    ),

                    const SizedBox(height: 10.0),

                    TextFormField(
                      controller: professionController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter profession";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Profession',
                          prefixIcon: Icon(Icons.app_registration_rounded),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width :2))),
                    ),
                    const SizedBox(height: 10.0),
                    TextField(
                      controller: dobController,
                      //editing controller of this TextField
                      decoration: const InputDecoration(
                          // icon: Icon(Icons.calendar_today), //icon of text field
                          labelText: "Enter Date",
                          prefixIcon: Icon(Icons.calendar_today),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width :2)) //label text of field
                          ),
                      readOnly: true,

                      //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2100));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            dobController.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {}
                      },
                    ),
                    const SizedBox(height: 10.0),
                    TextFormField(
                      controller: orgController,
                      keyboardType: TextInputType.text,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter organization";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'Organization',
                          prefixIcon: Icon(Icons.app_registration_rounded),
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(
                              color: Colors.black,
                              width: 2,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.black, width :2))
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    MyElevatedButton(
                      width: 250,
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          saveuserinfo();
                        }
                      },
                      borderRadius: BorderRadius.circular(20),
                      child: const Text(
                        'SAVE DETAILS',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, letterSpacing: 1),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),

                    // MyElevatedButton(
                    //   width: 250,
                    //   onPressed: () {
                    //     if (_formKey.currentState!.validate()) {
                    //       signout();
                    //     }
                    //   },
                    //   borderRadius: BorderRadius.circular(20),
                    //   child: const Text(
                    //     'LOGOUT',
                    //     style: TextStyle(
                    //         fontWeight: FontWeight.bold, letterSpacing: 1),
                    //   ),
                    // ),
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
