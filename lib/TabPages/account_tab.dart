// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:firebase_database/firebase_database.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:rideshare/Screen/userdetails.dart';
// //import 'package:rideshare/Screen/update_profile.dart';
// import '../Auth/loginscreen.dart';
// import '../Utills/utills.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';

// class AccountTabScreen extends StatefulWidget {
//   const AccountTabScreen({super.key});

//   @override
//   State<AccountTabScreen> createState() => _AccountTabScreenState();
// }

// class _AccountTabScreenState extends State<AccountTabScreen> {
//   PickedFile? imageFile;
//   final ImagePicker picker = ImagePicker();

//   final nameCotroller = TextEditingController();
//   final professionController = TextEditingController();
//   final dobController = TextEditingController();
//   final titleController = TextEditingController();

//   final _auth = FirebaseAuth.instance;
//   final databaseRef = FirebaseDatabase.instance.ref('UserInfo');

//   @override
//   void initState() {
//     super.initState();
//     final User? user = _auth.currentUser;
//     final uid = user?.uid;
//     dobController.text = "";
//   }

//   @override
//   void dispose() {
//     super.dispose();
//     nameCotroller.dispose();
//     professionController.dispose();
//     dobController.dispose();
//     titleController.dispose();
//   }

//   final auth = FirebaseAuth.instance;
//   bool isLoading = false;

//   void submit() {
//     final User? user = _auth.currentUser;
//     final uid = user?.uid;
//     setState(() {
//       isLoading = true;
//     });

//     print(uid);
//     print(nameCotroller.text);
//     print(professionController.text);
//     print(dobController.text);
//     print(titleController.text);

//     databaseRef.child(DateTime.now().millisecondsSinceEpoch.toString()).set({
//       'id': uid,
//       'name': nameCotroller.text.toString(),
//       'profession': professionController.text.toString(),
//       'dob': dobController.text.toString(),
//       'title': titleController.text.toString(),
//     }).then((value) {
//       setState(() {
//         isLoading = false;
//       });

//       Utills().toastSuccessMessage("User Information added successfully!");
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (BuildContext context) => const UserDetailsScreen()));
//     }).catchError((error) {
//       Utills().toastFaiureMessage(error.message);
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   void signout() {
//     setState(() {
//       isLoading = true;
//     });
//     auth.signOut().then((value) {
//       setState(() {
//         isLoading = false;
//       });

//       Utills().toastSuccessMessage("Successfully Loged out!");
//       Navigator.of(context).pushReplacement(MaterialPageRoute(
//           builder: (BuildContext context) => const LoginPage()));
//     }).catchError((error) {
//       Utills().toastFaiureMessage(error.message);
//       setState(() {
//         isLoading = false;
//       });
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     void takephoto(ImageSource source) async {
//       final pickedFile = await picker.getImage(
//         source: source,
//       );
//       setState(() {
//         imageFile = pickedFile;
//       });
//     }

//     Widget bottomsheet() {
//       print("----------inside bottomsheet");
//       return Container(
//         height: 100.0,
//         width: MediaQuery.of(context).size.width,
//         margin: const EdgeInsets.symmetric(
//           horizontal: 20,
//           vertical: 20,
//         ),
//         child: Column(
//           children: <Widget>[
//             const Text(
//               "Choose Profile Photo",
//               style: TextStyle(
//                 fontSize: 20.0,
//               ),
//             ),
//             SizedBox(height: 20),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: <Widget>[
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.camera),
//                   onPressed: () {
//                     takephoto(ImageSource.camera);
//                   },
//                   label: Text("Camera"),
//                 ),
//                 SizedBox(width: 40),
//                 ElevatedButton.icon(
//                   icon: Icon(Icons.image),
//                   onPressed: () {
//                     takephoto(ImageSource.gallery);
//                   },
//                   label: Text("Gallery"),
//                 ),
//               ],
//             )
//           ],
//         ),
//       );
//     }

//     Widget imageprofile() {
//       // print(context.widget);
//       return Center(
//         child: Stack(
//           children: <Widget>[
//             CircleAvatar(
//               radius: 80.0,
//               //backgroundImage: imageFile==null? AssetImage("images/avtar.png") : FileImage(File(imageFile.path)),
//               backgroundImage: imageFile == null
//                   ? AssetImage('assets/images/accountAvatar.jpg')
//                       as ImageProvider
//                   : FileImage(File(imageFile!.path)),
//             ),
//             Positioned(
//               bottom: 20,
//               right: 20,
//               child: InkWell(
//                 onTap: () {
//                   showBottomSheet(
//                     context: context,
//                     builder: ((builder) => bottomsheet()),
//                   );
//                 },
//                 child: Icon(
//                   Icons.camera_alt,
//                   color: Colors.black,
//                   size: 28,
//                 ),
//               ),
//             )
//           ],
//         ),
//       );
//     }

//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
//         child: ListView(
//           children: <Widget>[
//             imageprofile(),
//             SizedBox(height: 20),
//             nameTextField(),
//             SizedBox(height: 20),
//             ProfessionTextField(),
//             SizedBox(height: 20),
//             dobTextField(),
//             SizedBox(height: 20),
//             TitleTextField(),
//             SizedBox(height: 20),
//             ElevatedButton(
//                 onPressed: () {
//                   submit();
//                 },
//                 child: const Center(
//                   child: Text(
//                     'Submit',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Montserrat'),
//                   ),
//                 )),
//             ElevatedButton(
//                 onPressed: () {
//                   signout();
//                 },
//                 child: const Center(
//                   child: Text(
//                     'Logout',
//                     style: TextStyle(
//                         color: Colors.white,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Montserrat'),
//                   ),
//                 ))
//           ],
//         ),
//       ),
//     );
//   }

//   Widget nameTextField() {
//     return TextFormField(
//       controller: nameCotroller,
//       validator: (value) {
//         if (value!.isEmpty) {
//           return "Please enter From field";
//         } else {
//           return null;
//         }
//       },
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.teal),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.lightBlue,
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           Icons.person,
//           color: Colors.blue,
//         ),
//         labelText: "Name",
//         helperText: "Name can't be empty",
//         // hintText: "Parshwa Mehta",
//       ),
//     );
//   }

//   Widget ProfessionTextField() {
//     return TextFormField(
//       controller: professionController,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.teal),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.lightBlue,
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           Icons.shopping_bag_outlined,
//           color: Colors.lightBlue,
//         ),
//         labelText: "Profession",
//         helperText: "Profession can't be empty",
//         // hintText: "Full stack developer",
//       ),
//     );
//   }

//   Widget dobTextField() {
//     return TextField(
//       controller: dobController,
//       //editing controller of this TextField
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.teal),
//         ),
//         //icon of text field
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.lightBlue,
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           Icons.calendar_today,
//           color: Colors.blue,
//         ),
//         labelText: "Name",
//         helperText: "Name can't be empty",
//       ),
//       readOnly: true,
//       //set it true, so that user will not able to edit text
//       onTap: () async {
//         DateTime? pickedDate = await showDatePicker(
//             context: context,
//             initialDate: DateTime.now(),
//             firstDate: DateTime(1950),
//             //DateTime.now() - not to allow to choose before today.
//             lastDate: DateTime(2100));

//         if (pickedDate != null) {
//           print(
//               pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
//           String formattedDate = DateFormat('yyyy-MM-dd').format(pickedDate);
//           print(
//               formattedDate); //formatted date output using intl package =>  2021-03-16
//           setState(() {
//             dobController.text =
//                 formattedDate; //set output date to TextField value.
//           });
//         } else {}
//       },
//     );
//   }

//   Widget TitleTextField() {
//     return TextFormField(
//       controller: titleController,
//       decoration: const InputDecoration(
//         border: OutlineInputBorder(
//           borderSide: BorderSide(color: Colors.teal),
//         ),
//         focusedBorder: OutlineInputBorder(
//           borderSide: BorderSide(
//             color: Colors.lightBlue,
//             width: 2,
//           ),
//         ),
//         prefixIcon: Icon(
//           Icons.event_seat,
//           color: Colors.lightBlue,
//         ),
//         labelText: "Title",
//         helperText: "It can't be empty",
//         hintText: "Flutter developer",
//       ),
//     );
//   }
// }
