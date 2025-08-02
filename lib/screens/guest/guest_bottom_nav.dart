import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/screens/guest/guest_home_screen.dart';
import 'package:fyndr/screens/main_menu/user/messages_screen.dart';
import 'package:fyndr/screens/main_menu/user/request_screen.dart';
import 'package:fyndr/screens/main_menu/user/home_screen.dart';
import 'package:fyndr/screens/main_menu/user/profile_screen.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:get/get.dart';

class GuestBottomNav extends StatefulWidget {
  const GuestBottomNav({super.key});

  @override
  State<GuestBottomNav> createState() => _GuestBottomNavState();
}

class _GuestBottomNavState extends State<GuestBottomNav> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    GuestHomeScreen(),
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
    if (index == 0) {
      setState(() => _selectedIndex = index);
    } else {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.lock_outline, size: 48, color: Colors.orange),
                const SizedBox(height: 16),
                Text(
                  'Create an Account',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'You need an account to access this feature. Sign up now to continue.',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.grey[700],
                          side: BorderSide(color: Colors.grey.shade300),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.pop(context);
                          Get.offAllNamed(AppRoutes.onboardingScreen);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.orange,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text('Sign Up'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
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
                    color: Colors.black.withOpacity(0.4),
                  ),
                  child: BottomNavigationBar(
                    backgroundColor: Colors.transparent,
                    elevation: 0,
                    type: BottomNavigationBarType.fixed,
                    currentIndex: _selectedIndex,
                    onTap: _onItemTapped,
                    selectedItemColor: Colors.white,
                    unselectedItemColor: Colors.grey.shade700,
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
