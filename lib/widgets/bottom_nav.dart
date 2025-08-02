import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fyndr/screens/main_menu/user/messages_screen.dart';
import 'package:fyndr/screens/main_menu/user/request_screen.dart';
import 'package:fyndr/screens/main_menu/user/home_screen.dart';
import 'package:fyndr/screens/main_menu/user/profile_screen.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:get/get.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    HomeScreen(),
    RequestScreen(),
    MessagesScreen(),
    ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    final int? initialIndex = Get.arguments as int?;
    if (initialIndex != null) {
      _selectedIndex = initialIndex;
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // <- This is critical
      body: Stack(
        children: [
          _pages[_selectedIndex],

          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                child: Container(
                  padding: EdgeInsets.only(top: Dimensions.height10),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.7),
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey.shade400,
                    items: const [
                      BottomNavigationBarItem(
                        icon: Icon(Icons.home),
                        label: 'Home',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.menu),
                        label: 'Requests',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.message_rounded),
                        label: 'Messages',
                      ),
                      BottomNavigationBarItem(
                        icon: Icon(Icons.person_2_outlined),
                        label: 'Profile',
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
