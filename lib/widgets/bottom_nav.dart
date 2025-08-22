import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/app_controller.dart';
import '../utils/dimensions.dart';
import 'bottom_bar_item.dart';

class BottomNav extends StatelessWidget {
  const BottomNav({super.key});

  @override
  Widget build(BuildContext context) {
    AppController appController = Get.find<AppController>();

    return Obx(
          () => ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(

            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              // borderRadius: BorderRadius.circular(Dimensions.radius30),
            ),
            padding: EdgeInsets.only(
              bottom: Dimensions.height40,
              left: Dimensions.width15,
              right: Dimensions.width15,
              top: Dimensions.height30,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                BottomBarItem(
                  name: 'Home',
                  image: Icons.home,
                  isActive: appController.currentAppPage.value == 0,
                  onClick: () {
                    appController.changeCurrentAppPage(0);
                  },
                ),
                BottomBarItem(
                  name: 'Requests',
                  image: Icons.menu,
                  isActive: appController.currentAppPage.value == 1,
                  onClick: () {
                    appController.changeCurrentAppPage(1);
                  },
                ),
                BottomBarItem(
                  name: 'Messages',
                  image: Icons.chat,
                  isActive: appController.currentAppPage.value == 2,
                  onClick: () {
                    appController.changeCurrentAppPage(2);
                  },
                ),
                BottomBarItem(
                  name: 'Profile',
                  image: Icons.person,
                  isActive: appController.currentAppPage.value == 3,
                  onClick: () {
                    appController.changeCurrentAppPage(3);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

