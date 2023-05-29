import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:rideshare/Screen/userdetails.dart';
import 'package:rideshare/TabPages/acc_tab.dart';

class RenderScreen extends StatefulWidget {
  const RenderScreen({super.key});

  @override
  State<RenderScreen> createState() => _RenderScreenState();
}

class _RenderScreenState extends State<RenderScreen> {
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

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    checkUser();
  }

  @override
  Widget build(BuildContext context) {

    return isUserAdded ? UserDetailsScreen() : AccountTabScreen(name: "",profession: "",dob: "",org: "",);
  }
}
