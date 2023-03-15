import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

import '../TabPages/account_tab.dart';
import '../TabPages/home_tab.dart';
//import 'package:flutter_html/flutter_html.dart';


class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  TabController? tabController;
  int selectedIndex = 0;

  onItemClick(int index) {
    setState(() {
      selectedIndex = index;
      tabController!.index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          // Image(
          //   image: AssetImage("assets/images/Picture4.jpg"),
          //   width : 20,
          //   height: 10,
          // ),
          HomeTabScreen(),
          AccountTabScreen(),
          AccountTabScreen(),

        ],
      ),
      bottomNavigationBar: Container(
        height: 50,
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [
            Color.fromARGB(255, 100, 145, 236),
            Color.fromARGB(255, 69, 204, 231),
          ]),
        ),
        child: GNav(
            onTabChange: onItemClick,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            tabBackgroundGradient: LinearGradient(colors: [
              const Color.fromARGB(255, 100, 145, 236).withOpacity(0.3),
              const Color.fromARGB(255, 69, 204, 231).withOpacity(0.3),
            ]),
            backgroundColor: Colors.white,
            color: const Color.fromARGB(255, 100, 145, 236),
            activeColor: const Color.fromARGB(255, 100, 145, 236),
            gap: 8,
            tabs: const [
              GButton(
                icon: Icons.home,
                text: 'Home',
              ),
              GButton(
                icon: Icons.account_balance,
                text: 'Organization',
              ),
              GButton(
                icon: Icons.person,
                text: 'Profile',
              ),
            ]),
      ),
    );
  }
}

// bottomNavigationBar: BottomNavigationBar(
//         items:const [
//           BottomNavigationBarItem(

//               icon: Icon(Icons.home),
//               label: "Home"),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: "Account"),
//         ],
//         unselectedItemColor: Color.fromARGB(255, 203, 188, 188),
//         selectedItemColor: Color.fromARGB(255, 100, 145, 236),
//         backgroundColor: Colors.white,
//         type: BottomNavigationBarType.fixed,
//         selectedLabelStyle: const TextStyle(fontSize: 14),
//         showUnselectedLabels: true,
//         currentIndex: selectedIndex,
//         onTap: onItemClick,
//       ),

