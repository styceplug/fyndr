import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/data/api/api_client.dart';
import 'package:get/get_connect/http/src/response/response.dart';

class NotificationRepo {
  final ApiClient apiClient;

  NotificationRepo({required this.apiClient});

  Future<Response> postDeviceToken(String endpoint, Map<String, dynamic> body) async {
    return await apiClient.putData(endpoint, body);
  }

  Future<Response> getNotifications() async {
    return await apiClient.getData(AppConstants.GET_NOTIFICATIONS);
  }

}