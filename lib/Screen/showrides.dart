import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../views/chat_home_screen.dart';

class ShowRideScreen extends StatefulWidget {
  final String from;
  final String to;

  const ShowRideScreen({super.key, required this.from, required this.to});

  @override
  State<ShowRideScreen> createState() => _ShowRideScreenState();
}

class _ShowRideScreenState extends State<ShowRideScreen> {
  final _auth = FirebaseAuth.instance;
  var from;
  var to;
  User? user;
  var uid;
  int count = 0;

  @override
  void initState() {
    super.initState();
    print(
        "-------------------------inside showride screen-------------------------------");
    user = _auth.currentUser;
    uid = user?.uid;
    from = widget.from;
    to = widget.to;
  }


  List<Map<String, dynamic>> data = [];

  Future<List<Map<String, dynamic>>> searchRide(
      String? uid, String from, String to) async {
    DatabaseReference ref = FirebaseDatabase.instance.ref("ShareRideInfo");

    DatabaseReference userRef = FirebaseDatabase.instance.ref("UserInfo");

    Query query = ref.orderByChild("id").equalTo(uid);
    DataSnapshot dataSnapshot = await query.get();

    print(dataSnapshot.value);

    if (dataSnapshot.value != null) {
      (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) async {
        var id = value['id'];
        var fromValue = value['from'];
        var toValue = value['to'];
        var name;
        var profession;
        var title;
        Query uquery = userRef.orderByChild("id").equalTo(uid);
        DataSnapshot udataSnapshot = await uquery.get();
        print(udataSnapshot.value);
        if (udataSnapshot.value != null) {
          (udataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
            name = value['name'];
            profession = value['profession'];
            title = value['title'];
          });
        }

        if (fromValue.toString().toLowerCase().contains(from.toLowerCase()) &&
            toValue.toString().toLowerCase().contains(to.toLowerCase())) {
          data.add({
            "from": fromValue,
            "to": toValue,
            "date": value['date'],
            "time": value['time'],
            "name": name,
            "profession": profession,
            "title": title,
          });
        }
      });
    } else {
      print('No data found');
    }
    return data;
  }



  List<Map<String, dynamic>> dataList = [
    {
      "from": "Surat",
      "to": "Nadiad",
      "date": "30-04-2023",
      "org": "Facebook",
      "name": "Tulsi Lukhi",
      "profession": "Software Developer",
      "title": "Project Manager",
    },
    {
      "from": "Surat",
      "to": "Vadodara",
      "date": "30-04-2023",
      "org": "Google",
      "name": "Parshwa Mehta",
      "profession": "Marketing Manager ",
      "title": "Project Manager",
    },
    {
      "from": "Surat",
      "to": "Bhavnager",
      "date": "28-04-2023",
      "org": "Amazon",
      "name": "Parangi Rathod",
      "profession": "Graphic Designing",
      "title": "Design Head",
    },
    {
      "from": "Surat",
      "to": "Nadiad",
      "date": "30-04-2023",
      "org": "Tred",
      "name": "Om A lukhi",
      "profession": "Software Developer",
      "title": "Project Manager",
    }
  ];

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
          title: const Text("Carpool"),
        ),
        body: ListView.builder(
          itemCount: dataList.length,
          itemBuilder: (context, index) {
            return Container(
              // padding: EdgeInsets.only(top: 15),
              decoration: const BoxDecoration(
                // border: Border(bottom: BorderSide(color: Colors.black)),
                boxShadow: [
                  // BoxShadow(
                  //   color: Color.fromARGB(255, 208, 208, 208),
                  //   blurRadius: 2.0, // soften the shadow
                  //   spreadRadius: 5.0, //extend the shadow
                  //   offset: Offset(
                  //     5.0, // Move to right 5  horizontally
                  //     5.0, // Move to bottom 5 Vertically
                  //   ),
                  // )
                ],
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30.0),
                  topRight: Radius.circular(30.0),
                ),
              ),
              child: Card(
                child: ListTile(
                  leading: CircleAvatar(
                    //here there will be user photo
                    backgroundColor: Colors.blueGrey,
                    foregroundColor: Colors.white,
                    //here there will be user photo
                    child: Text(dataList[index]['name'][0]),
                  ),
                  title: Text(
                    '${dataList[index]['name']} - ${dataList[index]['profession']} ',
                    // snapshot.data?[index]['Name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From: ${dataList[index]['from']},To: ${dataList[index]['to']}',
                        style: const TextStyle(
                          fontSize: 16,
                        ),
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      Text(
                        '${dataList[index]['date']} ${dataList[index]['org']}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 14,
                        ),
                      ),
                    ],
                  ),
                  trailing: Icon(
                    Icons.chat_outlined,
                    color: Colors.grey[600],
                  ),
                  onTap: () {
                    // handle item tap
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>
                            const ChatHomeScreen()));
                  },
                ),
              ),
            );
          },
        ));
  }
}
