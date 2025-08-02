import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/data/api/api_client.dart';
import 'package:fyndr/helpers/push_notification.dart';
import 'package:fyndr/screens/auth/merchant/merchant_complete_auth.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/notification_controller.dart';
import '../../controllers/version_controller.dart';
import '../../helpers/version_service.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/bouncing_dots_indicator.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  final AuthController authController = Get.find<AuthController>();
  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
  final ApiClient apiClient = Get.find<ApiClient>();
  final notificationController = Get.find<NotificationController>();
  RequestController requestController = Get.find<RequestController>();

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration:  Duration(seconds: 3),
    );
    _fadeAnimation = Tween<double>(begin: 0, end: 1).animate(_controller);
    _controller.forward();

    WidgetsBinding.instance.addPostFrameCallback((_) => initialize());
  }

  Future<void> initialize() async {
    // Step 1: Connectivity check
    final connectivity = await Connectivity().checkConnectivity();
    if (connectivity == ConnectivityResult.none) {
      Get.offAllNamed(AppRoutes.noInternetScreen);
      return;
    }

    // Step 2: DNS check
    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isEmpty || result.first.rawAddress.isEmpty) {
        Get.offAllNamed(AppRoutes.noInternetScreen);
        return;
      }
    } catch (_) {
      Get.offAllNamed(AppRoutes.noInternetScreen);
      return;
    }

    // Step 3: Version check (daily or weekly)
    final versionController = Get.find<VersionController>();
    final SharedPreferences prefs = Get.find<SharedPreferences>();

    final now = DateTime.now();
    final lastCheckString = prefs.getString(AppConstants.lastVersionCheck);
    bool shouldCheckVersion = true;

    if (lastCheckString != null) {
      final lastCheck = DateTime.tryParse(lastCheckString);
      if (lastCheck != null && now.difference(lastCheck).inDays < 1) {
        shouldCheckVersion = false;
      }
    }

    if (shouldCheckVersion) {
      await versionController.checkAppVersion();
      await prefs.setString(AppConstants.lastVersionCheck, now.toIso8601String());

      final versionStatus = versionController.versionStatus.value;
      if (versionStatus == 'no-internet') {
        Get.offAllNamed(AppRoutes.noInternetScreen);
        return;
      } else if (versionStatus != 'OK') {
        Get.offAllNamed(AppRoutes.updateAppScreen);
        return;
      }
    } else {
      print("⏭️ Skipping version check (last checked $lastCheckString)");
    }

    // Step 4: Check token and route accordingly
    final token = sharedPreferences.getString(AppConstants.authToken);
    final isMerchant = sharedPreferences.getBool(AppConstants.isMerchant) ?? false;

    await Future.delayed(const Duration(seconds: 1));

    if (token != null && token.isNotEmpty) {
      apiClient.updateHeader(token);
      print("🔑 Header updated with token: $token");

      await FirebaseMessagingHelper.initializeFCM();

      if (isMerchant) {
        print("🔐 Merchant token found.");

        await authController.loadCachedMerchantProfile();

        if (authController.currentMerchant.value != null) {
          Get.offAllNamed(AppRoutes.merchantBottomNav);
          authController.refreshMerchantProfile();
          requestController.fetchMerchantRequests();
        } else {
          print("⚠️ No cached merchant profile. Trying to fetch from server...");
          await authController.loadMerchantProfile();

          if (authController.currentMerchant.value != null) {
            Get.offAllNamed(AppRoutes.merchantBottomNav);
            requestController.fetchMerchantRequests();
          } else {
            Get.offAllNamed(AppRoutes.onboardingScreen);
          }
        }
      } else {
        print("🔐 User token found.");

        await authController.loadCachedUserProfile();

        if (authController.currentUser.value != null) {
          Get.offAllNamed(AppRoutes.bottomNav);
          authController.refreshUserProfile();
        } else {
          print("⚠️ No cached user profile. Trying to fetch from server...");
          await authController.loadUserProfile();

          if (authController.currentUser.value != null) {
            Get.offAllNamed(AppRoutes.bottomNav);
          } else {
            Get.offAllNamed(AppRoutes.onboardingScreen);
          }
        }
      }
    } else {
      print("👤 No token found. Going to onboarding.");
      Get.offAllNamed(AppRoutes.onboardingScreen);
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SizedBox(
        width: Dimensions.screenWidth,
        height: Dimensions.screenHeight,
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.height313),
              FadeTransition(
                opacity: _fadeAnimation,
                child: Container(
                  height: Dimensions.height100 * 2,
                  width: Dimensions.width100 * 2,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius15),
                    image: DecorationImage(
                      image: AssetImage(AppConstants.getPngAsset('logo')),
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height313),
              Padding(
                padding: EdgeInsets.only(bottom: Dimensions.height43),
                child: Column(
                  children: [
                    SizedBox(
                      height: Dimensions.height20,
                      width: Dimensions.width20 * 10,
                      child: BouncingDotsIndicator(
                        color: Theme.of(context).dividerColor,
                      ),
                    ),
                    Text(
                      "App version: ${VersionService.currentVersion}",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).textTheme.bodyMedium?.color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );  }
}