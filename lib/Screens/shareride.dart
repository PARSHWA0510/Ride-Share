import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/Screens/cardetails.dart';
import 'package:rideshare/TabPages/home_tab.dart';
import 'package:rideshare/Utills/utills.dart';
import '../MainScreen/main_screen.dart';

class ShareRide extends StatefulWidget {
  final String from;
  final String to;
  const ShareRide({super.key, required this.from, required this.to});

  @override
  State<ShareRide> createState() => _ShareRideState();
}

class _ShareRideState extends State<ShareRide> {
  final _formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  bool isLoading = false;
  bool isCarAdded = false;

  //variable for car information
  var carmodel;
  var carnumber;
  var seats;

  final _auth = FirebaseAuth.instance;
  FirebaseDatabase database = FirebaseDatabase.instance;

  DatabaseReference dbCarRef = FirebaseDatabase.instance.ref("CarInfo");
  DatabaseReference dbAddInfoRef =
      FirebaseDatabase.instance.ref("AdditionalSignUpInfo");

  DatabaseReference shareRideRef =
      FirebaseDatabase.instance.ref("ShareRideInfo");

  @override
  void initState() {
    super.initState();

    final User? user = _auth.currentUser;
    final uid = user?.uid;
    print(
        "--------------------------------inside initstate---------------------------------");
    print(uid);
    checkCarDetails(uid);
    fromController.text = widget.from;
    toController.text = widget.to;
    dateController.text = "";
    Future.delayed(Duration.zero, () {
      _showBottomSheet(context);
    });
  }

  @override
  void dispose() {
    super.dispose();
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    timeController.dispose();
  }

  checkCarDetails(String? uid) async {
    print("here--------------cardefault");
    print("1----------------");
    DatabaseReference ref = FirebaseDatabase.instance.ref("CarInfo");

    Query query = ref.orderByChild("id").equalTo(uid);
    DataSnapshot dataSnapshot = await query.get();
    print(dataSnapshot.value);
    if (dataSnapshot.value != null) {
      setState(() {
        print("2-----------------------");
        print("-----------------iniside setstate");
        isCarAdded = true;
      });
      (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
        bool isDefault = value['isDefault'];
        carmodel = value['carModel'];
        carnumber = value['carNumber'];
        seats = value['Seats'];
        print("3----------------");
        print(carmodel);
        print(isDefault);
      });
    } else {
      print('No data found');
      setState(() {
        isCarAdded = false;
      });
    }
  }

  addShareRideInfo() {
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    setState(() {
      isLoading = true;
    });

    shareRideRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
      'id': uid,
      'from': fromController.text.toString(),
      'to': toController.text.toString(),
      'date': dateController.text.toString(),
      'time': timeController.text.toString(),
    }).then((value) {
      setState(() {
        isLoading = false;
      });

      Utills().toastSuccessMessage("Information added successfully!");
//////////changef from shareride screen..........
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const HomeTabScreen()));
    }).catchError((error) {
      Utills().toastFaiureMessage(error.message);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: () async {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => MainScreen()));
          return true;
        },
        child: const Scaffold(
          resizeToAvoidBottomInset: false,
          body: Center(child: Text("bottom sheet")),
        ));
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0), topRight: Radius.circular(30.0)),
      ),
      context: context,
      builder: (BuildContext context) {
        return Form(
          key: _formKey,
          child: Column(
            children: [
              Container(
                padding:
                    const EdgeInsets.only(top: 15.0, left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    TextFormField(
                      controller: fromController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter from field";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'From',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          prefixIcon: Icon(Icons.location_on),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextFormField(
                      controller: toController,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Please enter Destination field";
                        } else {
                          return null;
                        }
                      },
                      decoration: const InputDecoration(
                          labelText: 'To',
                          labelStyle: TextStyle(
                              fontFamily: 'Montserrat',
                              fontWeight: FontWeight.bold,
                              color: Colors.grey),
                          prefixIcon: Icon(Icons.location_city),
                          // hintText: 'EMAIL',
                          // hintStyle: ,
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.black))),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller: dateController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.calendar_today),
                        labelText: "Date",
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        DateTime? pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(
                                2000), //DateTime.now() - not to allow to choose before today.
                            lastDate: DateTime(2101));

                        if (pickedDate != null) {
                          print(
                              pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate =
                              DateFormat('yyyy-MM-dd').format(pickedDate);
                          print(
                              formattedDate); //formatted date output using intl package =>  2021-03-16
                          //you can implement different kind of Date Format here according to your requirement

                          setState(() {
                            dateController.text =
                                formattedDate; //set output date to TextField value.
                          });
                        } else {
                          Utills().toastFaiureMessage("Date is not selected");
                          print("Date is not selected");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    TextField(
                      controller:
                          timeController, //editing controller of this TextField
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.timer), //icon of text field
                        labelText: "Time",
                        labelStyle: TextStyle(
                            fontFamily: 'Montserrat',
                            fontWeight: FontWeight.bold,
                            color: Colors.grey),
                      ),
                      readOnly:
                          true, //set it true, so that user will not able to edit text
                      onTap: () async {
                        TimeOfDay? pickedTime = await showTimePicker(
                          initialTime: TimeOfDay.now(),
                          context: context,
                        );

                        if (pickedTime != null) {
                          print(pickedTime.format(context)); //output 10:51 PM
                          DateTime parsedTime = DateFormat.jm()
                              .parse(pickedTime.format(context).toString());
                          //converting to DateTime so that we can further format on different pattern.
                          print(parsedTime); //output 1970-01-01 22:53:00.000
                          String formattedTime =
                              DateFormat('HH:mm:ss').format(parsedTime);
                          print(formattedTime); //output 14:59:00
                          //DateFormat() is from intl package, you can format the time on any pattern you need.

                          setState(() {
                            timeController.text =
                                formattedTime; //set the value of text field.
                          });
                        } else {
                          print("Time is not selected");
                        }
                      },
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: isCarAdded
                          ? Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                const Icon(Icons.directions_car),
                                Text(
                                  carmodel,
                                  style: const TextStyle(
                                      fontFamily: 'Montserrat',
                                      fontWeight: FontWeight.bold,
                                      color: Colors.grey),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  carnumber,
                                  style: const TextStyle(fontSize: 16),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Seats: $seats',
                                  style: const TextStyle(fontSize: 16),
                                ),
                              ],
                            )
                          : SizedBox(
                              height: 45.0,
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
                                  // Navigator.of(context).push(MaterialPageRoute(
                                  //     builder: (BuildContext context) =>
                                  //         const CarDetailScreen()));
                                  Navigator.pushNamed(
                                          context, "/carDetailScreen")
                                      .then((value) {
                                    if (value != null) {
                                      initState();
                                    } // if true and you have come back to your Settings screen
                                  });
                                },
                                child: Center(
                                  child: isLoading
                                      ? const CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        )
                                      : const Text(
                                          'ADD Car',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontFamily: 'Montserrat'),
                                        ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(
                      height: 10,
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
                            addShareRideInfo();
                          }
                        },
                        child: Center(
                          child: isLoading
                              ? const CircularProgressIndicator(
                                  strokeWidth: 3,
                                  color: Colors.white,
                                )
                              : const Text(
                                  'Share Ride',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'),
                                ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
