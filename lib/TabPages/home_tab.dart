import 'package:flutter/material.dart';
import 'package:rideshare/Screens/request_ride.dart';
import 'package:rideshare/Screens/shareride.dart';
import '../Utills/utills.dart';

class HomeTabScreen extends StatefulWidget {
  const HomeTabScreen({super.key});

  @override
  State<HomeTabScreen> createState() => _HomeTabScreenState();
}

class _HomeTabScreenState extends State<HomeTabScreen>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final fromController = TextEditingController();
  final toController = TextEditingController();
  Color colorPrimary = Colors.blue;
  TabController? tabController;
  int? selectedIndex = 0;

  int count = 0;

  onItemClick(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    fromController.addListener(_onFieldChanged);
    toController.addListener(_onFieldChanged);
    tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    fromController.dispose();
    toController.dispose();
    super.dispose();
  }

  void _onFieldChanged() {
    if (count == 0) {
      if (fromController.text.isNotEmpty && toController.text.isNotEmpty) {
        print("------------------------------onfieldchanged");
        if (selectedIndex == 0) {
          print(selectedIndex);
          shareRide();
        } else {
          requestRide();
        }
        setState(() {
          count = 1;
        });
      }
    }
  }

  void shareRide() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => ShareRide(
                  from: fromController.text,
                  to: toController.text,
                )))
        .then((value) {})
        .catchError((error) {
      Utills().toastFaiureMessage(error.message);
    });
  }

  void requestRide() {
    Navigator.of(context)
        .push(MaterialPageRoute(
            builder: (BuildContext context) => const RequestRideScreen()))
        .then((value) {})
        .catchError((error) {
      Utills().toastFaiureMessage(error.message);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // backgroundColor: Colors.white,
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
        leading: const Icon(
          Icons.menu,
        ),
        title: const Text("Carpool"),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.message_outlined),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('This is a for message functionality')));
            },
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            tooltip: 'Show Snackbar',
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text('This is a notification functionality')));
            },
          ),
        ],
      ),
      // body: FlutterMap(
      //   options: MapOptions(
      //     center: LatLng(51.509364, -0.128928),
      //     zoom: 9.2,
      //   ),
      // ),
      bottomSheet: Container(
          width: MediaQuery.of(context).size.width,
          height: 220,
          decoration: const BoxDecoration(
            // color: colorPrimary,
            boxShadow: [
              BoxShadow(
                color: Color.fromARGB(255, 208, 208, 208),
                blurRadius: 15.0, // soften the shadow
                spreadRadius: 5.0, //extend the shadow
                offset: Offset(
                  5.0, // Move to right 5  horizontally
                  5.0, // Move to bottom 5 Vertically
                ),
              )
            ],
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(30.0),
              topRight: Radius.circular(30.0),
            ),
          ),
          child: DefaultTabController(
            length: 2,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    TabBar(
                      onTap: onItemClick,
                      unselectedLabelColor:
                          const Color.fromARGB(255, 81, 187, 213),
                      indicator: BoxDecoration(
                          borderRadius: BorderRadius.circular(50),
                          gradient: const LinearGradient(colors: [
                            Color.fromARGB(255, 100, 145, 236),
                            Color.fromARGB(255, 69, 204, 231),
                          ])),
                      tabs: [
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color.fromARGB(255, 100, 145, 236)
                                    .withOpacity(0.3),
                                const Color.fromARGB(255, 69, 204, 231)
                                    .withOpacity(0.3),
                              ]),
                              borderRadius: BorderRadius.circular(50),
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Find Pool",
                              ),
                            ),
                          ),
                        ),
                        Tab(
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                const Color.fromARGB(255, 100, 145, 236)
                                    .withOpacity(0.3),
                                const Color.fromARGB(255, 69, 204, 231)
                                    .withOpacity(0.3),
                              ]),
                              borderRadius: BorderRadius.circular(50),
                              // border: Border.all(
                              //     color:
                              //         const Color.fromARGB(255, 69, 204, 231),
                              //     width: 1.5)
                            ),
                            child: const Align(
                              alignment: Alignment.center,
                              child: Text("Offer Pool"),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: TabBarView(controller: tabController, children: [
                        Container(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            children: [
                              TextFormField(
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
                                    labelText: 'From',
                                    labelStyle: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 203, 202, 202)),
                                    prefixIcon: Icon(
                                      Icons.circle,
                                      color: Colors.green.withOpacity(0.3),
                                      size: 15,
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 203, 202, 202)))),
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                controller: toController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter destination field";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'To ',
                                    prefixIcon: Icon(
                                      Icons.circle,
                                      color: Colors.red.withOpacity(0.3),
                                      size: 15,
                                    ),
                                    labelStyle: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 203, 202, 202)))),
                              ),
                            ],
                          ),
                        ),
                        ////////////////////////
                        Container(
                          padding:
                              const EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Column(
                            children: [
                              TextFormField(
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
                                    labelText: 'From',
                                    labelStyle: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Color.fromARGB(255, 203, 202, 202)),
                                    prefixIcon: Icon(
                                      Icons.circle,
                                      color: Colors.green.withOpacity(0.3),
                                      size: 15,
                                    ),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 203, 202, 202)))),
                              ),
                              const SizedBox(height: 10.0),
                              TextFormField(
                                controller: toController,
                                keyboardType: TextInputType.text,
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Please enter destination field";
                                  } else {
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                    labelText: 'To ',
                                    prefixIcon: Icon(
                                      Icons.circle,
                                      color: Colors.red.withOpacity(0.3),
                                      size: 15,
                                    ),
                                    labelStyle: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        color: Colors.grey),
                                    focusedBorder: const UnderlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Color.fromARGB(
                                                255, 203, 202, 202)))),
                              ),
                            ],
                          ),
                        ),
                      ]),
                    )
                  ]),
            ),
          )),
    );
  }
}
