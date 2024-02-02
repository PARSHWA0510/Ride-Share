// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/src/widgets/framework.dart';
// import 'package:flutter/src/widgets/placeholder.dart';
//
// class ShowRideScreen extends StatefulWidget {
//   final String from;
//   final String to;
//
//   const ShowRideScreen({super.key, required this.from, required this.to});
//
//   @override
//   State<ShowRideScreen> createState() => _ShowRideScreenState();
// }
//
// class _ShowRideScreenState extends State<ShowRideScreen> {
//   final _auth = FirebaseAuth.instance;
//   var from;
//   var to;
//   User? user;
//   var uid;
//   int count = 0;
//
//   @override
//   void initState() {
//     super.initState();
//     user = _auth.currentUser;
//     uid = user?.uid;
//     from = widget.from;
//     to = widget.to;
//   }
//
//   List<Map<String, dynamic>> data = [];
//
//   Future<List<Map<String, dynamic>>> searchRide(
//       String? uid, String from, String to) async {
//     DatabaseReference ref = FirebaseDatabase.instance.ref("ShareRideInfo");
//
//     DatabaseReference userRef = FirebaseDatabase.instance.ref("UserInfo");
//
//     Query query = ref.orderByChild("id").equalTo(uid);
//     DataSnapshot dataSnapshot = await query.get();
//
//     print(dataSnapshot.value);
//
//     if (dataSnapshot.value != null) {
//       (dataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) async {
//         var id = value['id'];
//         var fromValue = value['from'];
//         var toValue = value['to'];
//         var name;
//         var profession;
//         var title;
//         Query uquery = userRef.orderByChild("id").equalTo(uid);
//         DataSnapshot udataSnapshot = await uquery.get();
//         print(udataSnapshot.value);
//         if (udataSnapshot.value != null) {
//           (udataSnapshot.value as Map<dynamic, dynamic>).forEach((key, value) {
//             name = value['name'];
//             profession = value['profession'];
//             title = value['title'];
//           });
//         }
//
//         if (fromValue.toString().toLowerCase().contains(from.toLowerCase()) &&
//             toValue.toString().toLowerCase().contains(to.toLowerCase())) {
//           data.add({
//             "from": fromValue,
//             "to": toValue,
//             "date": value['date'],
//             "time": value['time'],
//             "name": name,
//             "profession": profession,
//             "title": title,
//           });
//         }
//       });
//     } else {
//       print('No data found');
//     }
//     return data;
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//                 begin: Alignment.topLeft,
//                 end: Alignment.topRight,
//                 colors: <Color>[
//                   Color.fromARGB(255, 100, 145, 236),
//                   Color.fromARGB(255, 69, 204, 231),
//                 ]),
//           ),
//         ),
//         leading: GestureDetector(
//           child: const Icon(
//             Icons.arrow_back_ios,
//           ),
//           onTap: () {
//             Navigator.pop(context);
//           },
//         ),
//         title: const Text("Carpool"),
//       ),
//       body: FutureBuilder(
//         future: searchRide(uid, from, to),
//         builder: (context, snapshot) {
//           if (snapshot.hasData) {
//             return ListView.builder(
//               itemCount: snapshot.data?.length,
//               itemBuilder: (context, index) {
//                 return Container(
//                   // padding: EdgeInsets.only(top: 15),
//                   decoration: const BoxDecoration(
//                     // border: Border(bottom: BorderSide(color: Colors.black)),
//                     boxShadow: [
//                       // BoxShadow(
//                       //   color: Color.fromARGB(255, 208, 208, 208),
//                       //   blurRadius: 2.0, // soften the shadow
//                       //   spreadRadius: 5.0, //extend the shadow
//                       //   offset: Offset(
//                       //     5.0, // Move to right 5  horizontally
//                       //     5.0, // Move to bottom 5 Vertically
//                       //   ),
//                       // )
//                     ],
//                     color: Colors.white,
//                     borderRadius: BorderRadius.only(
//                       topLeft: Radius.circular(30.0),
//                       topRight: Radius.circular(30.0),
//                     ),
//                   ),
//                   child: ListTile(
//                     leading: CircleAvatar(
//                       //here there will be user photo
//                       backgroundColor: Colors.blueGrey,
//                       foregroundColor: Colors.white,
//                       //here there will be user photo
//                       child: Text(snapshot.data?[index]['name'][0]),
//                     ),
//                     title: Text(
//                       '${snapshot.data?[index]['name']} - ${snapshot.data?[index]['profession']} ',
//                       // snapshot.data?[index]['Name'],
//                       style: const TextStyle(
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18,
//                       ),
//                     ),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text(
//                           'From: ${snapshot.data?[index]['from']},To: ${snapshot.data?[index]['to']}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                           ),
//                         ),
//                         const SizedBox(
//                           height: 4,
//                         ),
//                         Text(
//                           '${snapshot.data?[index]['date']} ${snapshot.data?[index]['time']}',
//                           style: TextStyle(
//                             color: Colors.grey[600],
//                             fontSize: 14,
//                           ),
//                         ),
//                       ],
//                     ),
//                     trailing: Icon(
//                       Icons.arrow_forward_ios,
//                       color: Colors.grey[600],
//                     ),
//                     onTap: () {
//                       // handle item tap
//                     },
//                   ),
//                 );
//               },
//             );
//           } else {
//             return Container();
//           }
//         },
//       ),
//     );
//   }
// }
