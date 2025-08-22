import 'dart:convert';
import 'dart:io';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/data/api/api_client.dart';
import 'package:fyndr/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/api/api_checker.dart';
import '../data/repo/auth_repo.dart';
import '../helpers/global_loader_controller.dart';
import '../helpers/image_cache.dart';
import '../models/merchant_model.dart';
import '../models/notification_model.dart';
import '../models/user_model.dart';
import 'package:path/path.dart' as path;
import '../routes/routes.dart';
import '../utils/app_constants.dart';

class AuthController extends GetxController {
  final AuthRepo authRepo;

  AuthController({required this.authRepo});

  String? getUserToken() => authRepo.getUserToken();
  String? getMerchantToken() => authRepo.getMerchantToken();
  String? tempPhoneNumber;
  String? tempOtpRef;
  UserModel? userModel;
  final Rxn<UserModel> currentUser = Rxn<UserModel>();
  final Rxn<MerchantModel> merchantModel = Rxn<MerchantModel>();
  final Rxn<MerchantModel> currentMerchant = Rxn<MerchantModel>();
  String? selectedState;
  String? selectedLga;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
  RequestController requestController = Get.find<RequestController>();
  String? tempUserInput;
  String? tempMerchantInput;


  //MERCHANTS

  Future<void> updateBusinessDetails({
    required List<String> services,
    required String address,
    required String location,
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();

    final response = await authRepo.updateMerchantBusinessDetails(
      servicesOffered: services,
      businessAddress: address,
      businessLocation: location,
    );

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      MySnackBars.success(title: "Success", message: "Business details updated.");
      await loadMerchantProfile(); // Refresh merchant profile if needed
      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: "Failed",
        message: response.body['message'] ?? 'Could not update business details',
      );
    }
  }


  Future<bool> verifyBusiness({
    required File pdfFile,
    required String cacNumber,
    required String firstName,
    required String lastName,
    String? middleName,
    String? ninNumber,
  }) async {
    final response = await authRepo.submitBusinessVerification(
      pdfFile: pdfFile,
      cacNumber: cacNumber,
      firstName: firstName,
      lastName: lastName,
      middleName: middleName,
      ninNumber: ninNumber,
    );

    final body = jsonDecode(response.body);

    if (response.statusCode == 200 && body['code'] == '00') {
      return true;
    } else {
      MySnackBars.failure(title: 'Failed', message: body['message'] ?? 'Verification failed.');
      return false;
    }
  }

  Future<void> requestMerchantOtp(String input) async {
    loader.showLoader();

    final isPhone = RegExp(r'^[0-9]{11}$').hasMatch(input);
    final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);

    Map<String, dynamic> body = {};
    if (isPhone) {
      body = {"number": input};
    } else if (isEmail) {
      body = {"email": input};
    } else {
      loader.hideLoader();
      MySnackBars.failure(
        title: "Invalid input",
        message: "Enter a valid phone number or email",
      );
      return;
    }

    Response response = await authRepo.requestOtpMerchant(body);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      tempMerchantInput = input; // 👈 store merchant input
      tempOtpRef = response.body['data'];

      print('✅ OTP sent successfully. Ref: $tempOtpRef');

      Get.toNamed(
        AppRoutes.merchantVerifyOtpScreen,
        arguments: {
          'input': input,
          'isPhone': isPhone,
          'otpRef': tempOtpRef,
        },
      );
    } else {
      MySnackBars.failure(
        title: 'OTP Request Failed',
        message: 'Please try again',
      );
      ApiChecker.checkApi(response);
    }
  }

  Future<void> resendMerchantOtp() async {
    if (tempMerchantInput == null) {
      MySnackBars.failure(
        title: "Error",
        message: "No previous request found",
      );
      return;
    }

    loader.showLoader();

    final isPhone = RegExp(r'^[0-9]{11}$').hasMatch(tempMerchantInput!);
    Map<String, dynamic> body =
    isPhone ? {"number": tempMerchantInput} : {"email": tempMerchantInput};

    Response response = await authRepo.resendOtpMerchant(body);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      tempOtpRef = response.body['data'];

      print('✅ OTP resent successfully. Ref: $tempOtpRef');

      MySnackBars.success(
        title: 'OTP Sent',
        message: 'OTP resent successfully to $tempMerchantInput',
      );
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> verifyMerchantOtp({required String otp}) async {
    if (tempMerchantInput == null) {
      MySnackBars.failure(
        title: "Error",
        message: "No input found for verification",
      );
      return;
    }

    loader.showLoader();

    final isPhone = RegExp(r'^[0-9]{11}$').hasMatch(tempMerchantInput!);
    final body = {
      if (isPhone) "number": tempMerchantInput,
      if (!isPhone) "email": tempMerchantInput,
      "otp": otp,
      "userType": "merchant", // 👈 fixed
    };

    Response response = await authRepo.verifyOtp(body);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final data = response.body['data'];
      final merchantJson = data['user'];
      final token = data['token'];

      merchantModel.value = MerchantModel.fromJson(merchantJson);

      // Save merchant session
      await storeMerchantSession(merchant: merchantModel.value!, token: token);
      await refreshMerchantProfile();
      await requestController.fetchMerchantRequests();

      // Navigate based on profile completeness
      if (isMerchantProfileComplete(merchantJson)) {
        await sharedPreferences.setBool(AppConstants.isMerchant, true);
        await refreshMerchantProfile();
        Get.offAllNamed(AppRoutes.merchantBottomNav);

        loadMerchantProfile();
      } else {
        Get.offAllNamed(
          AppRoutes.merchantCompleteAuth,
          arguments: merchantJson,
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }


  bool isMerchantProfileComplete(Map<String, dynamic> merchant) {
    return merchant['name'] != null &&
        merchant['email'] != null &&
        merchant['businessName'] != null &&
        merchant['businessAddress'] != null &&
        merchant['nin'] != null &&
        merchant['state'] != null &&
        merchant['lga'] != null &&
        merchant['servicesOffered'] != null &&
        merchant['whatsappNumber'] != null &&
        merchant['name'].toString().trim().isNotEmpty &&
        merchant['email'].toString().trim().isNotEmpty &&
        merchant['businessName'].toString().trim().isNotEmpty &&
        merchant['businessAddress'].toString().trim().isNotEmpty &&
        merchant['nin'].toString().trim().isNotEmpty &&
        merchant['whatsappNumber'].toString().trim().isNotEmpty &&
        (merchant['servicesOffered'] as List).isNotEmpty;
  }





  Future<void> loadMerchantProfile() async {
    loader.showLoader();

    final response = await authRepo.fetchMerchantProfile();

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final merchantJson = response.body['data'];

      try {
        currentMerchant.value = MerchantModel.fromJson(merchantJson);
        await authRepo.cacheMerchantProfile(merchantJson);

        print("📦 Merchant loaded: ${currentMerchant.value?.name}");

        if (currentMerchant.value?.avatar != null && currentMerchant.value!.avatar!.isNotEmpty) {
          _cacheProfileImageIfNeeded(currentMerchant.value!.avatar!);
          await authRepo.cacheMerchantProfile(merchantJson);

        }
      } catch (e) {
        print("❌ Error parsing merchant data: $e");
        MySnackBars.failure(
          title: "Parse Error",
          message: "Failed to load merchant data.",
        );
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }



  Future<void> storeMerchantSession({
    required MerchantModel merchant,
    required String token,
  }) async {
    merchantModel.value = merchant;
    await authRepo.saveMerchantToken(token);
    await authRepo.cacheMerchantProfile(merchant.toJson());
  }

  Future<void> loadCachedMerchantProfile() async {
    final cached = authRepo.getCachedMerchantProfile();
    if (cached != null) {
      merchantModel.value = MerchantModel.fromJson(cached);
      print("📦 Loaded cached merchant: ${merchantModel.value?.name}");
      update();
    } else {
      print("📦 No cached merchant found");
    }
  }

  Future<void> refreshMerchantProfile() async {
    final response = await authRepo.fetchMerchantProfile();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final merchantJson = response.body['data'];
      currentMerchant.value = MerchantModel.fromJson(merchantJson);
      await authRepo.cacheMerchantProfile(merchantJson);
      print("📥 Refreshed merchant: ${currentMerchant.value?.name}");
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> registerMerchant({
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
    loader.showLoader();

    try {
      final result = await authRepo.completeMerchantAuth(
        name: name,
        email: email,
        businessName: businessName,
        businessAddress: businessAddress,
        nin: nin,
        state: state,
        lga: lga,
        servicesOffered: servicesOffered,
        whatsappNumber: whatsappNumber,
        avatar: avatar,
      );

      print("📡 Full API Response: $result");
      loader.hideLoader();

      if (result['success'] == true) {
        final merchantData = result['data']['merchant'];
        final token = result['token'];

        await sharedPreferences.setBool(AppConstants.isMerchant, true);
        await storeMerchantSession(merchant: merchantModel.value!, token: token);
        print("🔐 Token: $token");
        print("👤 Merchant Raw: $merchantData");

        try {
          merchantModel.value = MerchantModel.fromJson(merchantData);
          print("✅ Parsed Merchant Model: ${merchantModel.value?.name}, ${merchantModel.value?.email}");
        } catch (e) {
          print("❌ Error parsing merchant model: $e");
          MySnackBars.failure(title: "Parse Error", message: "Failed to read merchant data.");
          return;
        }

        print("💾 Merchant saved locally");

        MySnackBars.success(message: "Merchant registered successfully", title: 'Success');
        await refreshMerchantProfile();
        Get.offAllNamed(AppRoutes.merchantBottomNav);
      } else {
        final errorMessage = result['message'] ?? "Unknown failure";
        print("❌ API reported failure: $errorMessage");
        MySnackBars.failure(title: "Error", message: errorMessage);
      }
    } catch (e, s) {
      loader.hideLoader();
      print("❌ Exception: $e");
      print("📌 Stack trace:\n$s");
      MySnackBars.failure(title: "Exception", message: "Something went wrong.");
    }
  }



  //USERS

  Future<void> uploadProfileImage(File image) async {
    loader.showLoader();
    final response = await authRepo.updateProfileImage(image);
    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      MySnackBars.success(title: "Success", message: "Profile image updated");

      await loadUserProfile();

      if (currentUser.value?.avatar != null && currentUser.value!.avatar!.isNotEmpty) {
        await _cacheProfileImageAfterUpload(currentUser.value!.avatar!, image);
      }
    } else {
      MySnackBars.failure(
        title: "Failed",
        message: response.body['message'] ?? 'Image upload failed',
      );
    }
  }

  Future<void> _cacheProfileImageAfterUpload(
    String newImageUrl,
    File uploadedFile,
  ) async {
    try {
      final cacheService = ImageCacheService();

      await cacheService.cacheImageFromFile(newImageUrl, uploadedFile);

      debugPrint('✅ Profile image cached immediately after upload');
    } catch (e) {
      debugPrint('🛑 Error caching image after upload: $e');
      try {
        final cacheService = ImageCacheService();
        await cacheService.cacheImageFromUrl(newImageUrl);
        debugPrint('✅ Profile image cached from URL as fallback');
      } catch (fallbackError) {
        debugPrint('🛑 Fallback caching also failed: $fallbackError');
      }
    }
  }

  Future<void> loadUserProfile() async {
    loader.hideLoader();
    final response = await authRepo.fetchUserProfile();
    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final userJson = response.body['data'];
      currentUser.value = UserModel.fromJson(userJson);
      await authRepo.getCachedUserProfile();
      await authRepo.cacheUserProfile(userJson);
      print("📦 User loaded: ${currentUser?.value?.name}");

      if (currentUser.value?.avatar != null && currentUser.value!.avatar!.isNotEmpty) {
        _cacheProfileImageIfNeeded(currentUser.value?.avatar ?? '');
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> _cacheProfileImageIfNeeded(String imageUrl) async {
    try {
      final cacheService = ImageCacheService();

      final isAlreadyCached = await cacheService.isImageCached(imageUrl);

      if (!isAlreadyCached) {
        cacheService
            .cacheImageFromUrl(imageUrl)
            .then((cachedFile) {
              if (cachedFile != null) {
                debugPrint('✅ Profile image cached in background');
              }
            })
            .catchError((error) {
              debugPrint('🛑 Background caching failed: $error');
            });
      } else {
        debugPrint('ℹ️ Profile image already cached, skipping download');
      }
    } catch (e) {
      debugPrint('🛑 Error checking cache status: $e');
    }
  }

/*  Future<void> requestUserOtp(String number) async {
    loader.showLoader();

    Response response = await authRepo.requestOtpUser(number);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      tempPhoneNumber = number;
      tempOtpRef = response.body['data'];

      print('✅ OTP sent successfully. Ref: $tempOtpRef');

      Get.toNamed(
        AppRoutes.userVerifyOtpScreen,
        arguments: {'phone': number, 'otpRef': tempOtpRef},
      );
    } else {
      MySnackBars.failure(title: 'OTP Request Failed', message: 'Pls try again');
      ApiChecker.checkApi(response);
    }
  }

  Future<void> resendUserOtp() async {
    loader.showLoader();

    Response response = await authRepo.resendOtpUser(tempPhoneNumber!);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      tempOtpRef = response.body['data'];

      print('✅ OTP resent successfully. Ref: $tempOtpRef');

      MySnackBars.success(
        title: 'OTP Sent',
        message: 'OTP resent successfully to $tempPhoneNumber',
      );
    } else {
      ApiChecker.checkApi(response);
    }
  }*/


  Future<void> requestUserOtp(String input) async {
    loader.showLoader();

    final isPhone = RegExp(r'^[0-9]{11}$').hasMatch(input);
    final isEmail = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(input);

    Map<String, dynamic> body = {};
    if (isPhone) {
      body = {"number": input};
    } else if (isEmail) {
      body = {"email": input};
    } else {
      loader.hideLoader();
      MySnackBars.failure(
        title: "Invalid input",
        message: "Enter a valid phone number or email",
      );
      return;
    }

    Response response = await authRepo.requestOtpUser(body);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      tempUserInput = input;
      tempOtpRef = response.body['data'];

      print('✅ OTP sent successfully. Ref: $tempOtpRef');

      Get.toNamed(
        AppRoutes.userVerifyOtpScreen,
        arguments: {
          'input': input,
          'isPhone': isPhone,
          'otpRef': tempOtpRef,
        },
      );
    } else {
      MySnackBars.failure(
        title: 'OTP Request Failed',
        message: 'Please try again',
      );
      ApiChecker.checkApi(response);
    }
  }

  Future<void> resendUserOtp() async {
    if (tempUserInput == null) {
      MySnackBars.failure(
        title: "Error",
        message: "No previous request found",
      );
      return;
    }

    loader.showLoader();

    final isPhone = RegExp(r'^[0-9]{11}$').hasMatch(tempUserInput!);
    Map<String, dynamic> body =
    isPhone ? {"number": tempUserInput} : {"email": tempUserInput};

    Response response = await authRepo.resendOtpUser(body);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      tempOtpRef = response.body['data'];

      print('✅ OTP resent successfully. Ref: $tempOtpRef');

      MySnackBars.success(
        title: 'OTP Sent',
        message: 'OTP resent successfully to $tempUserInput',
      );
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> verifyUserOtp({required String otp}) async {
    if (tempUserInput == null) {
      MySnackBars.failure(
        title: "Error",
        message: "No input found for verification",
      );
      return;
    }

    loader.showLoader();

    final isPhone = RegExp(r'^[0-9]{11}$').hasMatch(tempUserInput!);
    final body = {
      if (isPhone) "number": tempUserInput,
      if (!isPhone) "email": tempUserInput,
      "otp": otp,
      "userType": "user",
    };

    Response response = await authRepo.verifyOtp(body);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final data = response.body['data'];
      final userJson = data['user'];
      final token = data['token'];

      userModel = UserModel.fromJson(userJson);

      await authRepo.saveUserToken(token);
      await sharedPreferences.setBool(AppConstants.isMerchant, false);

      if (_isUserProfileComplete(userJson)) {
        await loadUserProfile();
        Get.offAllNamed(AppRoutes.bottomNav);
      } else {
        Get.offAllNamed(AppRoutes.userCompleteAuth, arguments: userJson);
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> completeUserProfile({
    required String name,
    required String email,
    required String state,
    required String lga,
    required String location,
  }) async {
    loader.showLoader();

    final body = {
      "name": name,
      "email": email,
      "state": state,
      "lga": lga,
      "location": location,
    };

    final response = await authRepo.completeUserAuth(body);

    loader.hideLoader();

    if (response.statusCode == 201 && response.body['code'] == '00') {
      final token = response.body['data']['token'];
      final userJson = response.body['data']['foundUser'];

      currentUser.value = UserModel.fromJson(userJson);

      await authRepo.saveUserToken(token);

      print('✅ User profile completed');
      print('User: ${currentUser?.value?.name}');

      await sharedPreferences.setBool(AppConstants.isMerchant, false);

      Get.offAllNamed(AppRoutes.bottomNav);
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> loadCachedUserProfile() async {
    final cached = authRepo.getCachedUserProfile();
    if (cached != null) {
      currentUser.value = UserModel.fromJson(cached);
      print("📦 Loaded cached user: ${currentUser.value?.name}");
    } else {
      print("📦 No cached user found");
    }
  }

  Future<void> refreshUserProfile() async {
    final response = await authRepo.fetchUserProfile();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final userJson = response.body['data'];
      currentUser.value = UserModel.fromJson(userJson);
      await authRepo.cacheUserProfile(userJson);
      print("📥 Refreshed user: ${currentUser.value?.name}");
    } else {
      ApiChecker.checkApi(response);
    }
  }

/*  Future<void> verifyUserOtp({required String otp}) async {
    loader.showLoader();

    final body = {"number": tempPhoneNumber, "otp": otp, "userType": "user"};

    Response response = await authRepo.verifyOtp(body);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final data = response.body['data'];
      final userJson = data['user'];
      final token = data['token'];

      // Convert to UserModel
      userModel = UserModel.fromJson(userJson);

      // Save token
      await authRepo.saveUserToken(token);
      await sharedPreferences.setBool(AppConstants.isMerchant, false);


      // Navigate based on profile completeness
      if (_isUserProfileComplete(userJson)) {
        await loadUserProfile();
        Get.offAllNamed(AppRoutes.bottomNav);
      } else {
        Get.offAllNamed(AppRoutes.userCompleteAuth, arguments: userJson);
      }
    } else {
      ApiChecker.checkApi(response);
    }
  }*/

  Future<void> logout() async {
    await authRepo.clearUserToken();
    Get.offAllNamed(AppRoutes.onboardingScreen);
  }

  bool _isUserProfileComplete(Map<String, dynamic> user) {
    return user['name'] != null &&
        user['name'].toString().trim().isNotEmpty &&
        user['state'] != null &&
        user['lga'] != null;
  }

  Future<void> deleteAccount(String name) async {
    loader.showLoader();
    final response = await authRepo.deleteAccount(name);
    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      MySnackBars.success(
        title: 'Deleted',
        message: 'Account deleted successfully',
      );
      await logout();
    } else {
      print(response.body);
      MySnackBars.failure(
        title: 'Failed',
        message: response.body['message'] ?? 'Name verification failed',
      );
    }
  }



}
