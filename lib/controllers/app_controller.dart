import 'package:flutter/material.dart';
import 'package:fyndr/controllers/version_controller.dart';
import 'package:fyndr/screens/main_menu/user/home_screen.dart';
import 'package:fyndr/screens/main_menu/user/messages_screen.dart';
import 'package:fyndr/screens/main_menu/user/profile_screen.dart';
import 'package:fyndr/screens/main_menu/user/request_screen.dart';
import 'package:get/get.dart';

import '../data/repo/app_repo.dart';

class AppController extends GetxController {
  final AppRepo appRepo;

  AppController({required this.appRepo});

  Rx<ThemeMode> themeMode = Rx<ThemeMode>(ThemeMode.system);

  var currentAppPage = 0.obs;
  PageController pageController = PageController();

  final List<Widget> pages = [
    const HomeScreen(),
    const RequestScreen(),
    const MessagesScreen(),
    const ProfileScreen(),
  ];

  @override
  void onInit() {
    // initializeApp();
    super.onInit();
  }

  void initializeApp() async {
    await Future.wait([
      // Get.find<VersionController>().fetchActiveClasses(),
    ]);
  }

  void changeCurrentAppPage(int page,{bool movePage = true}) {
    currentAppPage.value = page;
    if (movePage) {
      pageController.animateToPage(
        page,
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeInOut,
      );
    }
    update();
  }
}
