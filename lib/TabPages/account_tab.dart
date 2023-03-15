import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rideshare/Screens/update_profile.dart';
import '../Auth/loginscreen.dart';
import '../Utills/utills.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
class AccountTabScreen extends StatefulWidget {
  const AccountTabScreen({super.key});

  @override
  State<AccountTabScreen> createState() => _AccountTabScreenState();
}

class _AccountTabScreenState extends State<AccountTabScreen> {

  PickedFile? imageFile;
  final ImagePicker picker = ImagePicker();

  final auth = FirebaseAuth.instance;
  bool isLoading = false;

  void signout() {
    setState(() {
      isLoading = true;
    });
    auth.signOut().then((value) {
      setState(() {
        isLoading = false;
      });

      Utills().toastSuccessMessage("Successfully Loged out!");
      Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (BuildContext context) => const LoginPage()));
    }).catchError((error) {
      Utills().toastFaiureMessage(error.message);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {


    void takephoto(ImageSource source) async{
      final pickedFile=await  picker.getImage(
        source: source ,
      );
      setState(() {
        imageFile=pickedFile;
      });
    }

    Widget bottomsheet(){
      print("----------inside bottomsheet");
      return Container(
        height: 100.0,
        width: MediaQuery.of(context).size.width,
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 20,
        ),
        child: Column(
          children: <Widget>[
            Text(
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
                  onPressed : (){
                    takephoto(ImageSource.camera);
                  },
                  label : Text("Camera"),
                ),
                SizedBox(width: 40),
                ElevatedButton.icon(
                  icon: Icon(Icons.image),
                  onPressed : (){
                    takephoto(ImageSource.gallery);
                  },
                  label : Text("Gallery"),
                ),
              ],
            )
          ],
        ),
      );
    }

    Widget imageprofile(){
      // print(context.widget);
      return Center(
        child: Stack(
          children: <Widget>[
            CircleAvatar(
              radius: 80.0,
              //backgroundImage: imageFile==null? AssetImage("images/avtar.png") : FileImage(File(imageFile.path)),
              backgroundImage: imageFile==null? AssetImage('assets/images/accountAvatar.jpg') as ImageProvider : FileImage(File(imageFile!.path)),
            ),
            Positioned(
              bottom: 20,
              right: 20,
              child: InkWell(
                onTap: (){
                  showBottomSheet(
                    context: context ,
                    builder: ((builder) => bottomsheet()),
                  );
                },
                child: Icon(
                  Icons.camera_alt,
                  color: Colors.black,
                  size: 28,
                ),
              ),)
          ],
        ),
      );
    }

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
        child: ListView(
          children: <Widget>[
            imageprofile(),
            SizedBox(height: 20),
            nameTextField(),
            SizedBox(height: 20),
            ProfessionTextField(),
            SizedBox(height: 20),
            dobTextField(),
            SizedBox(height: 20),
            TitleTextField(),
            SizedBox(height: 20),
            AboutTextField(),
            SizedBox(height: 20),
          ],
        ),
      ),
    );

    return Scaffold(

        body: Container(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (BuildContext context) => const UpdateProfileScreen()));
        },
        child: Column(
          children: [
            Column(
              children: [
                Row(
                  children: const [
                    Padding(
                      padding: EdgeInsets.fromLTRB(26, 10, 0.0, 0.0),
                      child: Text(
                        "Not Provided",
                        style: TextStyle(
                          fontFamily: "Montserrat",
                          fontSize: 40,
                          fontWeight: FontWeight.w700,
                          color: Colors.black,
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
            const SizedBox(
              height: 100,
            ),
            ElevatedButton(
                onPressed: () {
                  signout();
                },
                child: const Center(
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Montserrat'),
                  ),
                ))
          ],
        ),
      ),
    ));
  }


  Widget nameTextField(){
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.teal
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.lightBlue,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.blue,
        ),
        labelText: "Name",
        helperText: "Name can't be empty",
        hintText: "Parshwa Mehta",
      ),
    );
  }

  Widget ProfessionTextField(){
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.teal
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Profession",
        helperText: "Profession can't be empty",
        hintText: "Full stack developer",
      ),
    );
  }

  Widget dobTextField(){
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.teal
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Date of birth ",
        helperText: "provide DOB on dd/mm/yyyy",
        hintText: "05/10/2002",
      ),
    );
  }

  Widget TitleTextField(){
    return TextFormField(
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.teal
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        prefixIcon: Icon(
          Icons.person,
          color: Colors.green,
        ),
        labelText: "Title",
        helperText: "It can't be empty",
        hintText: "Flutter developer",
      ),
    );
  }

  Widget AboutTextField(){
    return TextFormField(
      maxLines: 4,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: Colors.teal
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.orange,
            width: 2,
          ),
        ),
        labelText: "About",
        helperText: "Write about yourself",
        //hintText: "Full stack developer",
      ),
    );
  }
}
