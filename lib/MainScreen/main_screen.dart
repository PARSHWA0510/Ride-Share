import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:rideshare/Screen/decisonscreen.dart';

import '../Screen/maintabscreen.dart';
// import '../TabPages/account_tab.dart';
import '../TabPages/acc_tab.dart';

class MainScreen extends StatefulWidget {
  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int selectedIndex = 0;

  onItemClick(int index) {
    setState(() {
      selectedIndex = index;
      tabController.index = index;
    });
  }

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TabBarView(
        physics: const NeverScrollableScrollPhysics(),
        controller: tabController,
        children: const [
          ScreenHomeTab(),
          // AccountTabScreen(),
          ScreenHomeTab(),
          RenderScreen(),
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

//----------------------------------------------LINK--------------- -----------------
//https://www.youtube.com/watch?v=kcLt5IHOFRI&list=PLBxWkM8PLHcr2vkdY2n9rIcxjZ9Th3Us7&index=2
//https://medium.com/flutter-community/building-a-chat-app-with-flutter-and-firebase-from-scratch-9eaa7f41782e



//https://www.youtube.com/watch?v=jDOYBUnapAs&list=PL8kbUJtS6hyal7Uw7wTeYmv7yiNPH5kOq&index=24 (From 23rd Video)
//https://github.com/HarshAndroid/WeChat
//Harsh M Rajpurohit