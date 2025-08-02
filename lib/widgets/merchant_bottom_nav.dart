import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:fyndr/screens/main_menu/merchant/merchant_message.dart';
import 'package:fyndr/screens/main_menu/merchant/merchant_profile.dart';
import 'package:fyndr/screens/main_menu/merchant/request_board.dart';

import '../utils/dimensions.dart';


class MerchantBottomNav extends StatefulWidget {
  const MerchantBottomNav({super.key});

  @override
  State<MerchantBottomNav> createState() => _MerchantBottomNavState();
}

class _MerchantBottomNavState extends State<MerchantBottomNav> {

  int _selectedIndex = 0;

  final List<Widget> _pages = [
    RequestBoard(),
    MerchantMessage(),
    MerchantProfile()
  ];

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
