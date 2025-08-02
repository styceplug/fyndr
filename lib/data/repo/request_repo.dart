import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:http/http.dart' as http;

import 'package:http_parser/http_parser.dart';

class RequestRepo {
  final ApiClient apiClient;

  RequestRepo({required this.apiClient});



  //MERCHANTS

  Future<Response> getMerchantRequests() async {
    return await apiClient.getData(AppConstants.GET_MERCHANT_REQUESTS);
  }

  Future<Response> fetchSingleMerchantRequest(String requestId) async {
    final uri = AppConstants.GET_SINGLE_MERCHANT_REQUEST.replaceFirst('{requestId}', requestId);
    return await apiClient.getData(uri);
  }

  Future<Response> startChat({
    required String requestId,
    required String proposal,
  }) async {
    final body = {
      "requestId": requestId,
      "proposal": proposal,
      "senderType": "Merchant"
    };

    return await apiClient.postData(AppConstants.START_CHAT, body);
  }



  //USERS

  Future<Response> chooseMerchant(String requestId, String interestId) {
    return apiClient.chooseMerchant(requestId: requestId, interestId: interestId);
  }

  Future<Response> getUserRequests() async {
    return await apiClient.getData(AppConstants.GET_REQUESTS);
  }

  Future<Response> getSingleRequest(String requestId) async {
    final uri = AppConstants.GET_SINGLE_REQUEST.replaceFirst(
      '{requestId}',
      requestId,
    );
    return await apiClient.getData(uri);
  }

  Future<Response> postCarPartRequest({
    required File carPartImage,
    required Map<String, dynamic> fields,
  }) async {
    final mimeType = lookupMimeType(carPartImage.path) ?? 'image/jpeg';
    final fileName = carPartImage.path.split('/').last;

    // Create MultipartRequest instead of FormData
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('${apiClient.baseUrl}${AppConstants.POST_CARPART_REQUESTS}'),
    );

    // Add fields
    fields.forEach((key, value) {
      request.fields[key] = value.toString();
      if (kDebugMode)
        print("🧾 $key: ${value.toString()} (${value.runtimeType})");
    });

    // Add the image file
    request.files.add(
      await http.MultipartFile.fromPath(
        'car_part_image',
        carPartImage.path,
        filename: fileName,
        contentType: MediaType.parse(mimeType),
      ),
    );

    if (kDebugMode) {
      print("📏 Image size (bytes): ${await carPartImage.length()}");
      print("🧾 Final Fields: ${request.fields}");
      print("🧾 Files: ${request.files.map((f) => f.field).join(', ')}");
    }

    return await apiClient.postMultipartData(
      AppConstants.POST_CARPART_REQUESTS,
      request,
    );
  }

  Future<Response> postRealEstateRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(
      AppConstants.POST_REALESTATE_REQUESTS,
      body,
    );
  }

  Future<Response> postCleaningRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_CLEANING_REQUESTS, body);
  }

  Future<Response> postCarHireRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_CARHIRE_REQUESTS, body);
  }

  Future<Response> postAutomobileRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(
      AppConstants.POST_AUTOMOBILE_REQUESTS,
      body,
    );
  }

  Future<Response> cancelUserRequest(String requestId) async {
    final uri = AppConstants.CANCEL_REQUEST.replaceFirst(
      '{requestId}',
      requestId,
    );
    return await apiClient.putData(uri, {});
  }

  Future<Response> closeUserRequest(String requestId) async {
    final uri = AppConstants.COMPLETE_REQUEST.replaceFirst(
      '{requestId}',
      requestId,
    );
    return await apiClient.putData(uri, {});
  }
}
