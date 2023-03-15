import 'package:flutter/material.dart';
import 'package:rideshare/Screens/request_ride.dart';

import 'package:rideshare/Screens/shareride.dart';

import '../Utills/utills.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen> {
  bool isLoading = false;

  void shareRide() {
    setState(() {
      isLoading = true;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => const ShareRide()))
        .then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      Utills().toastFaiureMessage(error.message);
      setState(() {
        isLoading = false;
      });
    });
  }

  void requestRide() {
    setState(() {
      isLoading = true;
    });
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => const RequestRideScreen()))
        .then((value) {
      setState(() {
        isLoading = false;
      });
    }).catchError((error) {
      Utills().toastFaiureMessage(error.message);
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100.0),
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) => const ShareRide()));
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
          const SizedBox(height: 100.0),
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
                Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (BuildContext context) =>
                        const RequestRideScreen()));
              },
              child: Center(
                child: isLoading
                    ? const CircularProgressIndicator(
                        strokeWidth: 3,
                        color: Colors.white,
                      )
                    : const Text(
                        'Request Ride',
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
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';

// class HomrTabScreen extends StatefulWidget {
//   const HomrTabScreen({super.key});

//   @override
//   State<HomrTabScreen> createState() => _HomrTabScreenState();
// }

// class _HomrTabScreenState extends State<HomrTabScreen> {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         appBar: AppBar(
//           // Here we take the value from the MyHomePage object that was created by
//           // the App.build method, and use it to set our appbar title.
//           title: Text("Map api"),
//         ),
//         body: OpenStreetMapSearchAndPick(
//             center: LatLong(23, 89),
//             buttonColor: Colors.blue,
//             buttonText: 'Set Current Location',
//             onPicked: (pickedData) {
//               print(pickedData.latLong.latitude);
//               print(pickedData.latLong.longitude);
//               print(pickedData.address);
//             }));
//   }
// }
