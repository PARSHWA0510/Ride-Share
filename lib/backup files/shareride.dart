import 'package:flutter/material.dart';
import 'package:rideshare/Screens/selectloacationscreen.dart';
import 'package:rideshare/Utills/utills.dart';

import '../MainScreen/main_screen.dart';
import '../Widgets/bootmsheetwidget.dart';

class ShareRideScreen extends StatefulWidget {
  const ShareRideScreen({super.key});

  @override
  State<ShareRideScreen> createState() => _ShareRideScreenState();
}

class _ShareRideScreenState extends State<ShareRideScreen> {
  late String _from;
  final fromController = TextEditingController();
  final toController = TextEditingController();
  final dateController = TextEditingController();
  final timeController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      _showBottomSheet(context);
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    fromController.dispose();
    toController.dispose();
    dateController.dispose();
    timeController.dispose();
  }

  void _showLocationScreen() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LocationScreen()),
    );
    if (result != null) {
      setState(() {
        _from = result;
      });
    }
  }

  void _showBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Padding(
          padding:
              EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            height: 200.0,
            child: Center(
                child: Column(
              children: [
                InkWell(
                  onTap: () {
                    Utills().toastFaiureMessage("clicked");
                    _showLocationScreen();
                  },
                  child: TextFormField(
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
                        prefixIcon: Icon(Icons.location_city),
                        // hintText: 'EMAIL',
                        // hintStyle: ,
                        focusedBorder: UnderlineInputBorder(
                            borderSide: BorderSide(color: Colors.black))),
                  ),
                ),
              ],
            )),
          ),
        );
      },
    );
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
}
