import 'package:day_picker/day_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cupertino_datetime_picker/flutter_cupertino_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:rideshare/MainScreen/main_screen.dart';
import 'package:rideshare/Screen/cardetailsscreen.dart';
import '../Utills/utills.dart';
import '../Widgets/mybutton.dart';

class ShareRideTab extends StatefulWidget {
  const ShareRideTab({super.key});

  @override
  State<ShareRideTab> createState() => _ShareRideTabState();
}

class _ShareRideTabState extends State<ShareRideTab> {
  final _formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final datetimeController = TextEditingController();
  final dayController = TextEditingController();

  final carController = TextEditingController();
  bool isLoading = false;
  bool isCarAdded = false;

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

  checkCarDetails(String? uid) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("CarInfo");

    Query query = ref.orderByChild("id").equalTo(uid);
    DataSnapshot dataSnapshot = await query.get();
    print(dataSnapshot.value);
    if (dataSnapshot.value != null) {
      setState(() {
        isCarAdded = true;
      });

      (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
        bool isDefault = value['isDefault'];
        carmodel = value['carModel'];
        carnumber = value['carNumber'];
        seats = value['Seats'];
      });
      carController.text = '$carmodel | $carnumber | $seats';
    } else {
      print('No data found');
      setState(() {
        isCarAdded = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    final User? user = _auth.currentUser;
    final uid = user?.uid;
    checkCarDetails(uid);
    datetimeController.text = "";
  }

  @override
  void dispose() {
    super.dispose();
    fromController.dispose();
    toController.dispose();
    datetimeController.dispose();
    carController.dispose();
    dayController.dispose();
  }

  void _showBottomNavigationDays() {
    showModalBottomSheet<void>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colors.white,
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SelectWeekDays(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      days: _days,
                      border: false,
                      boxDecoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30.0),
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          colors: [
                            Color.fromARGB(255, 100, 145, 236),
                            Color.fromARGB(255, 69, 204, 231)
                          ],
                          tileMode: TileMode
                              .repeated, // repeats the gradient over the canvas
                        ),
                      ),
                      onSelect: (values) {
                        print(
                            "-------------------------------------------------------------------------week values");
                        // <== Callback to handle the selected days
                        dayController.text = values.toString();
                      },
                    ),
                  ),
                ),
                MyElevatedButton(
                  width: 250,
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Text(
                    'CONFIRM',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                )
              ],
            ),
          ),
        );
      },
    );
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
      'date&time': datetimeController.text.toString(),
      'days': dayController.text.toString(),
    }).then((value) {
      setState(() {
        isLoading = false;
      });

      Utills().toastSuccessMessage("Information added successfully!");

      Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (BuildContext context) => MainScreen()));
    }).catchError((error) {
      Utills().toastFaiureMessage(error.message);
      setState(() {
        isLoading = false;
      });
    });
  }

  final List<DayInWeek> _days = [
    DayInWeek(
      "Sun",
    ),
    DayInWeek(
      "Mon",
    ),
    DayInWeek("Tue", isSelected: true),
    DayInWeek(
      "Wed",
    ),
    DayInWeek(
      "Thu",
    ),
    DayInWeek(
      "Fri",
    ),
    DayInWeek(
      "Sat",
    ),
  ];
  @override
  Widget build(BuildContext context) {
    dateTimePickerWidget(BuildContext context) {
      return DatePicker.showDatePicker(
        context,
        dateFormat: 'dd MMMM yyyy HH:mm',
        initialDateTime: DateTime.now(),
        minDateTime: DateTime(2000),
        maxDateTime: DateTime(3000),
        onMonthChangeStartWithFirstDate: true,
        onConfirm: (dateTime, List<int> index) {
          DateTime selectdate = dateTime;
          final selIOS = DateFormat('dd-MMM-yyyy - HH:mm').format(selectdate);
          print(selIOS);
          datetimeController.text = selIOS;
        },
      );
    }

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 2.0, left: 8.0, right: 8.0),
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(fontSize: 14),
                  controller: fromController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter From field";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      // labelText: 'From',
                      // contentPadding: EdgeInsets.symmetric(vertical: 4),
                      hintText: 'From',
                      hintStyle: const TextStyle(color: Colors.grey),
                      labelStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 202, 202)),
                      prefixIcon: Icon(
                        Icons.circle,
                        color: Colors.green.withOpacity(0.4),
                        size: 15,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              strokeAlign: 60,
                              color: Color.fromARGB(255, 203, 202, 202)))),
                ),
                // const SizedBox(
                //   height: 1,
                // ),
                TextFormField(
                  style: const TextStyle(fontSize: 14),
                  controller: toController,
                  keyboardType: TextInputType.text,
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Please enter To field";
                    } else {
                      return null;
                    }
                  },
                  decoration: InputDecoration(
                      // labelText: 'From',
                      hintText: 'To',
                      hintStyle: const TextStyle(color: Colors.grey),
                      labelStyle: const TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 203, 202, 202)),
                      prefixIcon: Icon(
                        Icons.circle,
                        color: Colors.red.withOpacity(0.4),
                        size: 15,
                      ),
                      focusedBorder: const UnderlineInputBorder(
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 203, 202, 202)))),
                ),
                // const SizedBox(
                //   height: 3,
                // ),
                TextField(
                  style: const TextStyle(fontSize: 14),
                  controller: datetimeController,

                  decoration: const InputDecoration(
                    hintText: "Date & Time",
                    hintStyle: TextStyle(color: Colors.grey),
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 203, 202, 202)),
                    prefixIcon: Icon(
                      Icons.access_time,
                      color: Colors.grey,
                      size: 16,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                            color: Color.fromARGB(255, 203, 202, 202))),
                  ),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    dateTimePickerWidget(context);
                  },
                ),
                TextFormField(
                  style: const TextStyle(fontSize: 14),
                  controller: dayController,
                  keyboardType: TextInputType.text,
                  // validator: (value) {
                  //   if (value!.isEmpty) {
                  //     return "Please enter  field";
                  //   } else {
                  //     return null;
                  //   }
                  // },
                  readOnly: true,
                  onTap: () {
                    _showBottomNavigationDays();
                  },
                  decoration: const InputDecoration(
                      // labelText: 'From',
                      // contentPadding: EdgeInsets.symmetric(vertical: 4),
                      hintText: 'Recurring Ride - Mo,Tu,We,Th,Fr,Sa,Su',
                      hintStyle:
                          TextStyle(color: Color.fromARGB(255, 100, 145, 236)),
                      labelStyle: TextStyle(
                          fontFamily: 'Montserrat',
                          fontWeight: FontWeight.bold,

                          color: Color.fromARGB(255, 203, 202, 202)),
                      prefixIcon: Icon(
                        Icons.repeat,
                        color: Colors.grey,
                        size: 17,
                      ),
                      focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                              strokeAlign: 60,
                              color: Color.fromARGB(255, 203, 202, 202)))),
                ),

                Center(
                    child: isCarAdded
                        ? TextFormField(
                            style: const TextStyle(fontSize: 14),
                            controller: carController,
                            keyboardType: TextInputType.text,
                            enabled: false,
                            decoration: const InputDecoration(
                                hintStyle: TextStyle(color: Colors.grey),
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 203, 202, 202)),
                                prefixIcon: Icon(
                                  Icons.directions_car,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        strokeAlign: 60,
                                        color: Color.fromARGB(
                                            255, 203, 202, 202)))),
                          )
                        : TextFormField(
                            style: const TextStyle(fontSize: 14),
                            controller: carController,
                            keyboardType: TextInputType.text,
                            // enabled: false,
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (BuildContext context) =>
                                      const CarDetailScreen()));
                            },
                            decoration: const InputDecoration(
                                hintText: "No car Added! Please Add",
                                hintStyle: TextStyle(
                                    color: Color.fromARGB(255, 100, 145, 236)),
                                labelStyle: TextStyle(
                                    fontFamily: 'Montserrat',
                                    fontWeight: FontWeight.bold,
                                    color: Color.fromARGB(255, 203, 202, 202)),
                                prefixIcon: Icon(
                                  Icons.directions_car,
                                  color: Colors.grey,
                                  size: 18,
                                ),
                                focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        strokeAlign: 60,
                                        color: Color.fromARGB(
                                            255, 203, 202, 202)))),
                          )

                    // SizedBox(
                    //     height: 45.0,
                    //     child: ElevatedButton(
                    //       style: ElevatedButton.styleFrom(
                    //         shadowColor: Colors.blueAccent,
                    //         backgroundColor: Colors.blue,
                    //         elevation: 7.0, //elevation of button
                    //         shape: RoundedRectangleBorder(
                    //             //to set border radius to button
                    //             borderRadius: BorderRadius.circular(20)),
                    //       ),
                    //       onPressed: () {
                    //         Navigator.of(context).push(MaterialPageRoute(
                    //             builder: (BuildContext context) =>
                    //                 const CarDetailScreen()));
                    //       },
                    //       child: Center(
                    //         child: isLoading
                    //             ? const CircularProgressIndicator(
                    //                 strokeWidth: 3,
                    //                 color: Colors.white,
                    //               )
                    //             : const Text(
                    //                 'ADD Car',
                    //                 style: TextStyle(
                    //                     color: Colors.white,
                    //                     fontWeight: FontWeight.bold,
                    //                     fontFamily: 'Montserrat'),
                    //               ),
                    //       ),
                    //     ),
                    //   ),
                    ),

                const SizedBox(
                  height: 15,
                ),
                MyElevatedButton(
                  width: 250,
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      addShareRideInfo();
                    }
                  },
                  borderRadius: BorderRadius.circular(20),
                  child: const Text(
                    'OFFER POOL',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, letterSpacing: 1),
                  ),
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
