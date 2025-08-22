import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class ThemeController extends GetxController {
  static const String themeKey = 'themeMode';
  var themeMode = ThemeMode.system.obs;

  @override
  void onInit() {
    super.onInit();
    _loadThemeFromStorage();
  }

  void toggleTheme() async {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }

    Get.changeThemeMode(themeMode.value);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themeKey, themeMode.value.toString().split('.').last);
  }

  void useSystemTheme() async {
    themeMode.value = ThemeMode.system;
    Get.changeThemeMode(ThemeMode.system);

    final prefs = await SharedPreferences.getInstance();
    prefs.setString(themeKey, 'system');
  }

  void _loadThemeFromStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final savedTheme = prefs.getString(themeKey);

    switch (savedTheme) {
      case 'light':
        themeMode.value = ThemeMode.light;
        break;
      case 'dark':
        themeMode.value = ThemeMode.dark;
        break;
      default:
        themeMode.value = ThemeMode.system;
    }

    Get.changeThemeMode(themeMode.value);
  }
}