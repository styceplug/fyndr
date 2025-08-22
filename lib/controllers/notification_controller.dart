import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:get/get.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fyndr/data/repo/notification_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/notification_model.dart';
import '../utils/app_constants.dart';
import '../widgets/snackbars.dart';

class NotificationController extends GetxController {
  final NotificationRepo notificationRepo;

  NotificationController({required this.notificationRepo});

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  SharedPreferences sharedPreferences = Get.find<SharedPreferences>();

  @override
  void onInit() {
    super.onInit();
    // fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    final response = await notificationRepo.getNotifications();

    if (response.statusCode == 200 && response.body?['code'] == '00') {
      final List data = response.body?['data'] ?? [];

      // 🔍 Print first item for debugging
      if (data.isNotEmpty) {
        print('First notification: ${data.first}');
      }

      try {
        notifications.value =
            data.map((e) => NotificationModel.fromJson(e)).toList();
      } catch (e) {
        print('❌ Error parsing notification: $e');

      }
    } else {
      notifications.clear();
      print(response.body?['message']);
    }
  }
/*  void _showLocalNotification({required String title, required String body}) {
    const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'fyndr_channel',
      'Fyndr Notifications',
      channelDescription: 'Handles app alerts',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    const NotificationDetails notificationDetails =
    NotificationDetails(android: androidDetails);

    flutterLocalNotificationsPlugin.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      title,
      body,
      notificationDetails,
    );
  }

  void _initializeLocalNotifications() {
    const AndroidInitializationSettings androidInit =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    const DarwinInitializationSettings iosInit = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );

    const InitializationSettings initSettings = InitializationSettings(
      android: androidInit,
      iOS: iosInit,
    );

    flutterLocalNotificationsPlugin.initialize(initSettings);
  }

  void _setupFCMListeners() {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('📥 Foreground FCM Message: ${message.notification?.title}');
      if (message.notification != null) {
        _showLocalNotification(
          title: message.notification!.title ?? 'Notification',
          body: message.notification!.body ?? '',
        );
      }
    });

    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print('📦 User opened app from notification');
      // TODO: Navigate based on message.data['type'] if needed
      Get.toNamed(AppRoutes.notificationScreen);
    });
  }

  Future<void> saveDeviceToken() async {
    final isMerchant = sharedPreferences.getBool(AppConstants.isMerchant) ?? false;

    final token = await FirebaseMessaging.instance.getToken();
    final platform = Platform.isAndroid ? 'android' : 'ios';

    if (token != null) {
      final body = {
        "deviceToken": token,
        "platform": platform,
      };

      final endpoint = isMerchant
          ? AppConstants.UPDATE_MERCHANT_DEVICE_TOKEN
          : AppConstants.UPDATE_DEVICE_TOKEN;

      final response = await notificationRepo.postDeviceToken(endpoint, body);

      if (response.statusCode == 200 && response.body['code'] == '00') {
        print('✅ Device token saved successfully');
      } else {
        print('❌ Token save failed: ${response.body}');
      }
    }
  }*/
}