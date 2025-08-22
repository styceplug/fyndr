import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyndr/controllers/app_controller.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/controllers/chat_controller.dart';
import 'package:fyndr/controllers/notification_controller.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/controllers/theme_controller.dart';
import 'package:fyndr/controllers/version_controller.dart';
import 'package:fyndr/screens/auth/user/user_complete_auth.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:get/get.dart';
import 'package:fyndr/routes/routes.dart';

import 'firebase_options.dart';
import 'helpers/dependencies.dart' as dep;
import 'helpers/global_loader_controller.dart';
import 'helpers/push_notification.dart';
import 'helpers/version_service.dart';
import 'widgets/app_loading_overlay.dart';

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(); // needed if not already initialized in isolate
  FirebaseMessagingHelper.firebaseMessagingBackgroundHandler(message);
}

ChatController chatController = Get.find<ChatController>();
ThemeController themeController = Get.find<ThemeController>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await VersionService.init();
  await dep.init();

  // Load token from auth controller
  final userToken = await Get.find<AuthController>().getUserToken();
  if (userToken != null) {
    chatController.loadCachedChats();
    await FirebaseMessagingHelper.initializeFCM();
  }

  // Always register loader controller
  Get.put(GlobalLoaderController(), permanent: true);

  HardwareKeyboard.instance.clearState();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      builder: (_) {
        return GetBuilder<VersionController>(
          builder: (_) {
            return GetBuilder<GlobalLoaderController>(
              builder: (_) {
                return GetBuilder<AuthController>(
                  builder: (_) {
                    return GetBuilder<NotificationController>(
                      builder: (_) {
                        return GetBuilder<ChatController>(
                          builder: (_) {
                            return GetBuilder<AppController>(
                              builder: (appController) {
                                return GetMaterialApp(
                                  themeMode: themeController.themeMode.value,
                                  theme: ThemeData(
                                    fontFamily: 'Sora',
                                    brightness: Brightness.light,
                                    scaffoldBackgroundColor: AppColors.lightBg,
                                    iconTheme: IconThemeData(
                                      color: AppColors.darkBg,
                                    ),
                                  ),
                                  darkTheme: ThemeData(
                                    brightness: Brightness.dark,
                                    scaffoldBackgroundColor: AppColors.darkBg,
                                    iconTheme: IconThemeData(
                                      color: Colors.white,
                                    ),
                                  ),
                                  debugShowCheckedModeBanner: false,
                                  title: 'Fyndr',

                                  getPages: AppRoutes.routes,
                                  initialRoute: AppRoutes.splashScreen,
                                  builder: (context, child) {
                                    final loaderController =
                                        Get.find<GlobalLoaderController>();
                                    return Obx(() {
                                      return Stack(
                                        children: [
                                          child!,
                                          if (loaderController.isLoading.value)
                                            const AppLoadingOverlay(),
                                        ],
                                      );
                                    });
                                  },
                                );
                              },
                            );
                          },
                        );
                      },
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }
}
