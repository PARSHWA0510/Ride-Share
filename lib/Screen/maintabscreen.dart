import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';

import 'package:open_street_map_search_and_pick/open_street_map_search_and_pick.dart';
import 'package:rideshare/Screen/requestridetab.dart';
import 'package:rideshare/Screen/shareridescreen.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:rideshare/views/chatRoomsScreen.dart';

import '../Utills/utills.dart';
import '../views/chat_home_screen.dart';

class ScreenHomeTab extends StatefulWidget {
  const ScreenHomeTab({super.key});

  @override
  State<ScreenHomeTab> createState() => _ScreenHomeTabState();
}

class _ScreenHomeTabState extends State<ScreenHomeTab>
    with SingleTickerProviderStateMixin {
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

  TabController? _tabController;
  int selectedIndex = 0;

  int count = 0;

  onItemClick(int index) {
    print("here---------------");
    setState(() {
      selectedIndex = index;
      _tabController!.index = index;
    });
  }

  @override
  void initState() {
    super.initState();

    _tabController = TabController(length: 2, vsync: this);
  }

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
          leading: const Icon(
            Icons.menu,
          ),
          title: const Text("Carpool"),
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.message_outlined),
              tooltip: 'Show Snackbar',
              onPressed: () {
                // ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                //     content: Text('This is a for message functionality')));

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                        const ChatHomeScreen()));
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
        bottomSheet: Container(
            width: MediaQuery.of(context).size.width,
            height: 370,
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
                padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 1),
                child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    // crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: [
                          Container(
                            // The height of TabBar without icons is 46 (72 with), so 2 pixels for border
                            height: 48,
                            decoration: const BoxDecoration(
                              border: Border(
                                bottom: BorderSide(
                                  color: Color.fromARGB(255, 230, 228, 228),
                                  width: 1,
                                ),
                              ),
                            ),
                          ),
                          TabBar(
                              onTap: onItemClick,
                              indicator: const UnderlineTabIndicator(
                                  insets: EdgeInsets.zero,
                                  borderSide: BorderSide(
                                      width: 3,
                                      color:
                                          Color.fromARGB(255, 81, 187, 213))),
                              unselectedLabelColor: Colors.grey,
                              labelColor:
                                  const Color.fromARGB(255, 81, 187, 213),
                              tabs: const [
                                Tab(
                                  child: Text(
                                    "Share Pool",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                Tab(
                                  child: Text(
                                    "Find Pool",
                                    style: TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ]),
                        ],
                      ),
                      const Expanded(
                          child: TabBarView(
                        children: [ShareRideTab(), RequestRideTab()],
                      ))
                    ]),
              ),
            )),
        body: FlutterMap(
          options: MapOptions(
            center: LatLng(51.509364, -0.128928),
            zoom: 9.2,
          ),

          /*layers: [
             TileLayerOptions(
               urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
               userAgentPackageName: 'com.example.app',
             ),
           ],*/
          nonRotatedChildren: [
            AttributionWidget.defaultWidget(
              source: 'OpenStreetMap contributors',
              onSourceTapped: null,
            ),
          ],
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.example.rideshare',
            ),
          ],
        ));
  }
}
