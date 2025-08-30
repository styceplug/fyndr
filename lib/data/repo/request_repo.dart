import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:fyndr/screens/auth/user/user_complete_auth.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:path/path.dart' as path;
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

  Future<Response> postBeautyRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_BEAUTY_REQUESTS, body);
  }

  Future<Response> postCateringRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_CATERING_REQUESTS, body);
  }

  Future<Response> postCarpentryRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_CARPENTRY_REQUESTS, body);
  }

  Future<Response> postElectricianRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_ELECTRICAL_REQUESTS, body);
  }


  Future<Response> postITRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_IT_REQUESTS, body);
  }

  Future<Response> postMechanicRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_MECHANIC_REQUESTS, body);
  }

  Future<Response> postMediaRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_MEDIA_REQUESTS, body);
  }

  Future<Response> postPlumbingRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_PLUMBING_REQUESTS, body);
  }


  Future<Response> postHospitalityRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_HOSPITALITY_REQUESTS, body);
  }

  Future<Response> postEventManagementRequest(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_EVENT_MANAGEMENT_REQUESTS, body);
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

  Future<Response> getJobListings() async {
    return await apiClient.getData(AppConstants.GET_JOB_LISTINGS);
  }

  Future<Response> postJobListing(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_OPEN_JOB, body);
  }

 /* Future<Response> postCV(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.POST_CV, body);
  }*/
  Future<Response> postCV(Map<String, dynamic> body, {File? image}) async {
    var url = '${AppConstants.BASE_URL}${AppConstants.POST_CV}';

    if (image != null) {
      var request = http.MultipartRequest("POST", Uri.parse(url));

      String? token = await authController.getUserToken();
      if (token != null) {
        request.headers['Authorization'] = "Bearer $token";
      }
      request.headers['Accept'] = "application/json";

      // Add form fields
      body.forEach((key, value) {
        if (value != null) {
          if (value is List) {
            // Handle arrays (skills, languages, workExperienceDetails)
            if (key == 'workExperienceDetails') {
              // Convert work experience to JSON string
              request.fields[key] = jsonEncode(value);
            } else {
              // Handle simple arrays like skills and languages
              for (int i = 0; i < value.length; i++) {
                request.fields['$key[$i]'] = value[i].toString();
              }
            }
          } else {
            request.fields[key] = value.toString();
          }
        }
      });

      // Get proper MIME type based on file extension
      String fileName = image.path.toLowerCase();
      String mimeType;
      if (fileName.endsWith('.png')) {
        mimeType = 'image/png';
      } else if (fileName.endsWith('.jpg') || fileName.endsWith('.jpeg')) {
        mimeType = 'image/jpeg';
      } else if (fileName.endsWith('.gif')) {
        mimeType = 'image/gif';
      } else if (fileName.endsWith('.webp')) {
        mimeType = 'image/webp';
      } else {
        mimeType = 'image/jpeg'; // Default fallback
      }

      request.files.add(await http.MultipartFile.fromPath(
        "cv_image",
        image.path,
        contentType: MediaType.parse(mimeType),
      ));

      var streamedResponse = await request.send();
      var response = await http.Response.fromStream(streamedResponse);

      try {
        return Response(
          statusCode: response.statusCode,
          body: jsonDecode(response.body),
        );
      } catch (e, s) {
        print("JSON decode error: $e");
        print("StackTrace: $s");
        print("Raw response: ${response.body}");

        return Response(
          statusCode: response.statusCode,
          body: {
            "error": "Invalid JSON format",
            "raw": response.body,
          },
        );
      }
    } else {
      return await apiClient.postData(url, body);
    }
  }

  Future<Response> postProposal(String jobId, Map<String, dynamic> body) async {
    return await apiClient.postData(
      "${AppConstants.POST_PROPOSAL}/$jobId",
      body,
    );
  }

  Future<Response> getAllCv() async{
    return await apiClient.getData(AppConstants.GET_ALL_CV);
  }

  Future<Response> getMyCv() async{
    return await apiClient.getData(AppConstants.GET_USER_CV);
  }

  Future<Response> getSingleJob(String jobId) async {
    return await apiClient.getData("/v1/job/single/$jobId");
  }

  Future<Response> getSingleCv(String cvId) async {
    return await apiClient.getData("/v1/cv/single/$cvId");
  }
}
