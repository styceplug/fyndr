import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:mime/mime.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controllers/theme_controller.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';



class AuthRepo {
  final ApiClient apiClient;
  final SharedPreferences sharedPreferences;

  AuthRepo({required this.apiClient, required this.sharedPreferences});




  //MERCHANTS


  Future<Response> updateMerchantBusinessDetails({
    required List<String> servicesOffered,
    required String businessAddress,
    required String businessLocation,
  }) async {
    final body = {
      "servicesOffered": servicesOffered,
      "businessAddress": businessAddress,
      "businessLocation": businessLocation,
    };

    return await apiClient.putData(AppConstants.UPDATE_MERCHANT_BUSINESS_DETAILS, body);
  }

  Future<http.Response> submitBusinessVerification({
    required File pdfFile,
    required String cacNumber,
    required String firstName,
    required String lastName,
    String? middleName,
    String? ninNumber,
  }) async {
    final request = http.MultipartRequest(
      'PUT',
      Uri.parse('${AppConstants.BASE_URL}${AppConstants.VERIFY_BUSINESS}'),
    );

    final token = await getUserToken();
    request.headers['Authorization'] = 'Bearer $token';

    request.fields['cacNumber'] = cacNumber;
    request.fields['firstName'] = firstName;
    request.fields['lastName'] = lastName;

    if (middleName != null && middleName.isNotEmpty) {
      request.fields['middleName'] = middleName;
    }
    if (ninNumber != null && ninNumber.isNotEmpty) {
      request.fields['ninNumber'] = ninNumber;
    }

    final fileBytes = await pdfFile.readAsBytes();
    final pdf = http.MultipartFile.fromBytes(
      'pdf',
      fileBytes,
      filename: pdfFile.path.split('/').last,
      contentType: MediaType('application', 'pdf'),
    );

    request.files.add(pdf);

    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    return http.Response(response.body, response.statusCode);  }


  // Save merchant token
  Future<void> saveMerchantToken(String token) async {
    apiClient.updateHeader(token);
    await sharedPreferences.setString(AppConstants.authToken, token);
  }

// Get merchant token
  String? getMerchantToken() {
    return sharedPreferences.getString(AppConstants.authToken);
  }

// Clear merchant token
  Future<void> clearMerchantToken() async {
    await sharedPreferences.remove(AppConstants.authToken);
  }

// Cache merchant profile
  Future<void> cacheMerchantProfile(Map<String, dynamic> json) async {
    final raw = jsonEncode(json);
    await sharedPreferences.setString('cached_merchant_profile', raw);
  }

// Get cached merchant profile
  Map<String, dynamic>? getCachedMerchantProfile() {
    final raw = sharedPreferences.getString('cached_merchant_profile');
    if (raw != null) {
      return jsonDecode(raw);
    }
    return null;
  }


  Future<Response> fetchMerchantProfile() async {
    return await apiClient.getData(AppConstants.MERCHANT_PROFILE);
  }

  Future<Response> requestOtpMerchant(String phoneNumber) async {
    final body = {
      "number": phoneNumber,
    };
    return await apiClient.postData(AppConstants.MERCHANT_REQUEST_OTP, body);
  }

  Future<Response> resendOtpMerchant(String phoneNumber) async {
    final body = {
      "number": phoneNumber,
    };
    return await apiClient.postData(AppConstants.MERCHANT_RESEND_OTP, body);
  }

  Future<Map<String, dynamic>> completeMerchantAuth({
    required String name,
    required String email,
    required String businessName,
    required String businessAddress,
    required String nin,
    required String state,
    required String lga,
    required List<String> servicesOffered,
    required String whatsappNumber,
    File? avatar,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('authToken');

    var uri = Uri.parse('${AppConstants.BASE_URL}${AppConstants.MERCHANT_REGISTER}');
    var request = http.MultipartRequest('POST', uri);

    request.headers['Authorization'] = 'Bearer $token'; // ✅ add token to headers

    request.fields['name'] = name;
    request.fields['email'] = email;
    request.fields['businessName'] = businessName;
    request.fields['businessAddress'] = businessAddress;
    request.fields['nin'] = nin;
    request.fields['state'] = state;
    request.fields['lga'] = lga;
    request.fields['whatsappNumber'] = whatsappNumber;

    for (int i = 0; i < servicesOffered.length; i++) {
      request.fields['servicesOffered[$i]'] = servicesOffered[i];
    }

    if (avatar != null) {
      request.files.add(await http.MultipartFile.fromPath('avatar', avatar.path,contentType: MediaType('image', 'png'),));
    }

    try {
      var response = await request.send();
      final respStr = await response.stream.bytesToString();
      print("📡 RAW RESPONSE STRING:\n$respStr");

      Map<String, dynamic> jsonResponse = {};
      try {
        jsonResponse = jsonDecode(respStr);
      } catch (e) {
        print("❌ JSON Decode Failed: $e");
        return {
          'success': false,
          'message': 'Server returned non-JSON response'
        };
      }

      if (response.statusCode == 201) {
        return {
          'success': true,
          'data': jsonResponse['data'],
          'token': jsonResponse['data']['token'],
        };
      } else {
        return {
          'success': false,
          'message': jsonResponse['message'] ?? 'Unknown error',
        };
      }
    } catch (e, s) {
      print('❌ Exception: $e');
      print('📌 Stack trace: $s');
      return {
        'success': false,
        'message': 'Something went wrong. Please try again later.'
      };
    }
  }




  //USERS

  Future<Response> requestOtpUser(String phoneNumber) async {
    final body = {
      "number": phoneNumber,
    };
    return await apiClient.postData(AppConstants.USER_REQUEST_OTP, body);
  }

  Future<Response> resendOtpUser(String phoneNumber) async {
    final body = {
      "number": phoneNumber,
    };
    return await apiClient.postData(AppConstants.USER_RESEND_OTP, body);
  }

  Future<Response> completeUserAuth(Map<String, dynamic> data) async {
    return await apiClient.postData(AppConstants.USER_REGISTER, data);
  }

  Future<Response> verifyOtp(Map<String, dynamic> body) async {
    return await apiClient.postData(AppConstants.VERIFY_OTP, body);
  }

  Future<void> saveUserToken(String token) async {
    apiClient.updateHeader(token);
    await sharedPreferences.setString(AppConstants.authToken, token);
  }


  String? getUserToken() {
    return sharedPreferences.getString(AppConstants.authToken);
  }

  Future<void> clearUserToken() async {
    final prefs = await SharedPreferences.getInstance();
    final bool isDark = prefs.getBool(ThemeController.themeKey) ?? false;

    await prefs.clear(); // clears everything
    await prefs.setBool(ThemeController.themeKey, isDark);
  }

  Future<Response> fetchUserProfile() async {
    return await apiClient.getData(AppConstants.USER_PROFILE);
  }

  Future<void> cacheUserProfile(Map<String, dynamic> json) async {
    final raw = jsonEncode(json);
    await sharedPreferences.setString('cached_user_profile', raw);
  }

  Map<String, dynamic>? getCachedUserProfile() {
    final raw = sharedPreferences.getString('cached_user_profile');
    if (raw != null) {
      return jsonDecode(raw);
    }
    return null;
  }

  Future<Response> deleteAccount(String name) async {
    final isMerchant = getMerchantToken() != null;
    final token = isMerchant ? getMerchantToken() : getUserToken();
    final url = isMerchant ? AppConstants.DELETE_MERCHANT : AppConstants.DELETE_USER;

    return await apiClient.request(
      url,
      'delete',
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
      body: {'name': name},
    );
  }

  Future<Response> updateProfileImage(File imageFile) async {
    final mimeType = lookupMimeType(imageFile.path) ?? 'image/jpeg';
    final fileName = imageFile.path.split('/').last;

    // Check if merchant or user
    final isMerchant = sharedPreferences.getBool(AppConstants.isMerchant) ?? false;
    final endpoint = isMerchant
        ? AppConstants.UPDATE_MERCHANT_PROFILE_IMAGE
        : AppConstants.UPDATE_USER_PROFILE_IMAGE;

    final uri = Uri.parse('${apiClient.baseUrl}$endpoint');

    final request = http.MultipartRequest('PUT', uri);

    // Add image file
    request.files.add(await http.MultipartFile.fromPath(
      'avatar',
      imageFile.path,
      filename: fileName,
      contentType: MediaType.parse(mimeType),
    ));

    // Auth header
    final token = sharedPreferences.getString(AppConstants.authToken);
    request.headers.addAll({
      'Authorization': 'Bearer $token',
      'Content-Type': 'multipart/form-data',
    });

    // Debug log
    if (kDebugMode) {
      print("🖼️ Uploading profile image: $fileName");
      print("📏 Image size: ${await imageFile.length()} bytes");
      print("🔁 Endpoint: $endpoint");
    }

    // Send request
    final streamedResponse = await request.send();
    final responseString = await streamedResponse.stream.bytesToString();

    return Response(
      body: jsonDecode(responseString),
      statusCode: streamedResponse.statusCode,
    );
  }





}