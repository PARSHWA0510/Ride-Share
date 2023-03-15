// import 'package:flutter/material.dart';
// import 'package:rideshare/Screens/request_ride.dart';

// import 'package:rideshare/Screens/shareride.dart';

// import '../Utills/utills.dart';
// import '../Widgets/button.dart';
// import 'account_tab.dart';

// class HomeTabScreen extends StatefulWidget {
//   const HomeTabScreen({super.key});

//   @override
//   State<HomeTabScreen> createState() => _HomeTabScreenState();
// }

// class _HomeTabScreenState extends State<HomeTabScreen>
//     with SingleTickerProviderStateMixin {
//   bool isLoading = false;
//   final _formKey = GlobalKey<FormState>();
//   final fromController = TextEditingController();
//   final toController = TextEditingController();
//   Color colorPrimary = Colors.blue;
//   TabController? tabController;
//   int selectedIndex = 0;

//   @override
//   void initState() {
//     super.initState();
//     tabController = TabController(length: 2, vsync: this);
//   }

//   void shareRide() {
//     setState(() {
//       isLoading = true;
//     });
//     Navigator.of(context)
//         .push(MaterialPageRoute(
//             builder: (BuildContext context) => const ShareRide()))
//         .then((value) {
//       setState(() {
//         isLoading = false;
//       });
//     }).catchError((error) {
//       Utills().toastFaiureMessage(error.message);
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   void requestRide() {
//     setState(() {
//       isLoading = true;
//     });
//     Navigator.of(context)
//         .push(MaterialPageRoute(
//             builder: (BuildContext context) => const RequestRideScreen()))
//         .then((value) {
//       setState(() {
//         isLoading = false;
//       });
//     }).catchError((error) {
//       Utills().toastFaiureMessage(error.message);
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         // backgroundColor: Colors.white,
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
//         leading: const Icon(
//           Icons.menu,
//         ),
//         title: const Text("Carpool"),
//         actions: <Widget>[
//           IconButton(
//             icon: const Icon(Icons.message_outlined),
//             tooltip: 'Show Snackbar',
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                   content: Text('This is a for message functionality')));
//             },
//           ),
//           IconButton(
//             icon: const Icon(Icons.notifications),
//             tooltip: 'Show Snackbar',
//             onPressed: () {
//               ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
//                   content: Text('This is a notification functionality')));
//             },
//           ),
//         ],
//       ),
//       bottomSheet: Container(
//           width: MediaQuery.of(context).size.width,
//           height: 200,
//           decoration: const BoxDecoration(
//             // color: colorPrimary,
//             boxShadow: [
//               BoxShadow(
//                 color: Color.fromARGB(255, 208, 208, 208),
//                 blurRadius: 15.0, // soften the shadow
//                 spreadRadius: 5.0, //extend the shadow
//                 offset: Offset(
//                   5.0, // Move to right 5  horizontally
//                   5.0, // Move to bottom 5 Vertically
//                 ),
//               )
//             ],
//             color: Colors.white,
//             borderRadius: BorderRadius.only(
//               topLeft: Radius.circular(30.0),
//               topRight: Radius.circular(30.0),
//             ),
//           ),
//           child: DefaultTabController(
//             length: 2,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
//               child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: <Widget>[
//                     TabBar(
//                       tabs: [
//                         Tab(
//                           child: MyElevatedButton(
//                             width: double.maxFinite,
//                             onPressed: () {},
//                             borderRadius: BorderRadius.circular(20),
//                             child: const Text('Find Pol'),
//                           ),
//                         ),
//                         Tab(
//                           child: MyElevatedButton(
//                             width: double.maxFinite,
//                             onPressed: () {},
//                             borderRadius: BorderRadius.circular(20),
//                             child: const Text('Offer Pol'),
//                           ),
//                         ),
//                       ],
//                     ),
//                     Expanded(
//                       child: TabBarView(
//                         controller: tabController,
//                         children: <Widget>[
//                           Column(
//                             children: <Widget>[
//                               const Text(
//                                 'the first tab view',
//                                 style: TextStyle(fontSize: 24),
//                               ),
//                               SizedBox(height: 26),
//                               Container(
//                                   height: 73,
//                                   width: MediaQuery.of(context).size.width - 24,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: colorPrimary,
//                                       border: Border.all(
//                                           width: 0.5, color: Colors.redAccent)),
//                                   child: Align(
//                                     alignment: Alignment.center,
//                                     child: TextField(
//                                       maxLength: 30,
//                                       enableInteractiveSelection: false,
//                                       keyboardType: TextInputType.number,
//                                       style: TextStyle(height: 1.6),
//                                       cursorColor: Colors.green[800],
//                                       textAlign: TextAlign.center,
//                                       autofocus: false,
//                                       decoration: const InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: 'Internet',
//                                         counterText: "",
//                                       ),
//                                     ),
//                                   )),
//                             ],
//                           ),
//                           Column(
//                             children: <Widget>[
//                               const Text(
//                                 'the second tab view',
//                                 style: TextStyle(fontSize: 24),
//                               ),
//                               const SizedBox(height: 26),
//                               Container(
//                                   height: 73,
//                                   width: MediaQuery.of(context).size.width - 24,
//                                   decoration: BoxDecoration(
//                                       borderRadius: BorderRadius.circular(5),
//                                       color: colorPrimary,
//                                       border: Border.all(
//                                           width: 0.5, color: Colors.redAccent)),
//                                   child: Align(
//                                     alignment: Alignment.center,
//                                     child: TextField(
//                                       maxLength: 30,
//                                       enableInteractiveSelection: false,
//                                       keyboardType: TextInputType.number,
//                                       style: TextStyle(height: 1.6),
//                                       cursorColor: Colors.green[800],
//                                       textAlign: TextAlign.center,
//                                       autofocus: false,
//                                       decoration: const InputDecoration(
//                                         border: InputBorder.none,
//                                         hintText: 'Credit',
//                                         counterText: "",
//                                       ),
//                                     ),
//                                   )),
//                             ],
//                           )
//                         ],
//                       ),
//                     )
//                   ]),
//             ),
//           )),
//     );
//   }
// }
// // 