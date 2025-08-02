import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/controllers/notification_controller.dart';
import 'package:fyndr/screens/auth/user/user_complete_auth.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:get/get.dart';

import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/notification_card.dart';

class MerchantNotificationScreen extends StatefulWidget {
  const MerchantNotificationScreen({super.key});

  @override
  State<MerchantNotificationScreen> createState() => _MerchantNotificationScreenState();
}

class _MerchantNotificationScreenState extends State<MerchantNotificationScreen> {
  NotificationController controller = Get.find<NotificationController>();

  Timer? notificationTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.fetchNotifications();

      notificationTimer = Timer.periodic(Duration(seconds: 60), (_) {
        controller.fetchNotifications();
      });
    });
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: CustomAppbar(
        centerTitle: true,
        title: 'Notifications',
        leadingIcon: InkWell(
          onTap: () => Get.back(),
          child: Icon(Icons.chevron_left, color: theme.iconTheme.color),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await controller.fetchNotifications();
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Obx(() {
            final notifications = controller.notifications;

            if (notifications.isEmpty) {
              return const Center(
                child: EmptyState(message: 'No notifications yet'),
              );
            }

            return ListView.builder(
              itemCount: notifications.length,
              itemBuilder: (context, index) {
                return NotificationCard(notification: notifications[index]);
              },
            );
          }),
        ),
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
    );
  }
}
