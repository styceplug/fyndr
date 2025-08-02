import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  static const String themeKey = 'isDarkMode';
  var isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void toggleTheme() async {
    isDarkMode.value = !isDarkMode.value;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool(themeKey, isDarkMode.value);
  }

  void _loadThemeFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getBool(themeKey);
    isDarkMode.value = savedTheme ?? false;
    Get.changeThemeMode(isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}