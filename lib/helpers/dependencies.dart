import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/controllers/chat_controller.dart';
import 'package:fyndr/controllers/version_controller.dart';
import 'package:fyndr/data/repo/auth_repo.dart';
import 'package:fyndr/data/repo/chat_repo.dart';
import 'package:fyndr/data/repo/version_repo.dart';
import 'package:fyndr/helpers/global_loader_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controllers/notification_controller.dart';
import '../controllers/request_controller.dart';
import '../controllers/theme_controller.dart';
import '../data/api/api_client.dart';
import '../data/repo/notification_repo.dart';
import '../data/repo/request_repo.dart';
import '../utils/app_constants.dart';

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();

  Get.put(sharedPreferences);

  //api clients
  Get.lazyPut(
    () => ApiClient(
      appBaseUrl: AppConstants.BASE_URL,
      sharedPreferences: Get.find(),
    ),
  );

  //theme
  Get.put(ThemeController());

  // repos
  Get.lazyPut(() => VersionRepo(apiClient: Get.find()));
  Get.lazyPut(
    () => AuthRepo(apiClient: Get.find(), sharedPreferences: Get.find()),
  );
  Get.lazyPut(() => RequestRepo(apiClient: Get.find()));
  Get.lazyPut(() => NotificationRepo(apiClient: Get.find()));
  Get.lazyPut(() => ChatRepo(apiClient: Get.find()));




  //controllers
  Get.lazyPut(() => VersionController(versionRepo: Get.find()));
  Get.lazyPut(() => GlobalLoaderController());
  Get.lazyPut(() => AuthController(authRepo: Get.find()));
  Get.lazyPut(() => RequestController(requestRepo: Get.find()));
  Get.lazyPut(() => NotificationController(notificationRepo: Get.find()));
  Get.lazyPut(() => ChatController(chatRepo: Get.find()));

}
