import 'dart:convert';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/models/merchant_model.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/repo/request_repo.dart';
import '../../models/request_model.dart';
import '../data/api/api_checker.dart';
import '../helpers/global_loader_controller.dart';
import '../models/job_model.dart';
import '../widgets/snackbars.dart';

class RequestController extends GetxController {

  @override
  void onInit() {
    // fetchJobListings();
    // fetchCvs();
    // fetchUserRequests();
    super.onInit();
  }
  final RequestRepo requestRepo;
  final loader = Get.find<GlobalLoaderController>();

  RequestController({required this.requestRepo});

  var userRequests = <RequestModel>[].obs;
  var merchantRequests = <RequestModel>[].obs;
  var singleRequest = Rxn<RequestModel>();
  Rxn<RequestModel> selectedMerchantRequest = Rxn<RequestModel>();
  Rxn<InterestedMerchant> interestedMerchant = Rxn<InterestedMerchant>();
  var isSending = false.obs;
  final RxBool isLoadingUserRequests = false.obs;
  List<JobModel> jobList = [];
  List<JobModel> filteredJobs = [];
  var cvList = <CvModel>[].obs;

  AuthController? _authController;

  AuthController get authController {
    _authController ??= Get.find<AuthController>();
    return _authController!;
  }


  Future<void> fetchJobListings() async {
    try {
      loader.showLoader();
      update();

      Response response = await requestRepo.getJobListings();

      if (response.statusCode == 200 && response.body != null) {
        final data = response.body["data"] as List;
        jobList = data.map((e) => JobModel.fromJson(e)).toList();
        filteredJobs = jobList;
      } else {
        jobList = [];
      }
    } catch (e) {
      print("❌ Error fetching jobs: $e");
      jobList = [];
    } finally {
      loader.hideLoader();
      update();
    }
  }

  void filterJobs(String query) {
    if (query.isEmpty) {
      filteredJobs = jobList;
    } else {
      filteredJobs = jobList
          .where((job) => job.jobDetails?.title
          ?.toLowerCase()
          .contains(query.toLowerCase()) ?? false)
          .toList();
    }
    update();
  }

  Future<void> postJobListing(Map<String, dynamic> body) async {
    loader.showLoader();
    final response = await requestRepo.postJobListing(body);
    loader.hideLoader();

    final resBody = response.body;
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        resBody != null &&
        resBody['code'] == '00') {
      await fetchUserRequests();
      print(resBody);
      MySnackBars.success(
        title: 'Success',
        message: resBody['message'] ?? 'Job Posting created successfully',
      );
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody?['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> postCv(Map<String, dynamic> body) async {
    loader.showLoader();
    final response = await requestRepo.postCV(body);
    loader.hideLoader();

    final resBody = response.body;
    if ((response.statusCode == 200 || response.statusCode == 201) &&
        resBody != null &&
        resBody['code'] == '00') {
      await fetchUserRequests();
      print(resBody);
      MySnackBars.success(
        title: 'Success',
        message: resBody['message'] ?? 'CV Posted successfully',
      );
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody?['message'] ?? 'Request failed',
      );
    }
  }


  Future<void> fetchCvs() async {
    loader.showLoader();
    final response = await requestRepo.getAllCv();
    if (response.statusCode == 200 && response.body['code'] == "00") {
      List data = response.body['data'];
      cvList.value = data.map((e) => CvModel.fromJson(e)).toList();
      update();
    }
    loader.hideLoader();
  }

  //MERCHANTS

  Future<void> fetchMerchantRequests() async {
    loader.showLoader();
    final response = await requestRepo.getMerchantRequests();
    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final data = response.body['data'] as List;
      merchantRequests.value =
          data.map((e) => RequestModel.fromJson(e)).toList();
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> fetchSingleMerchantRequest(String requestId) async {
    selectedMerchantRequest.value = null;

    loader.showLoader();

    final response = await requestRepo.fetchSingleMerchantRequest(requestId);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final data = response.body['data'];
      selectedMerchantRequest.value = RequestModel.fromJson(data);
      Get.toNamed(AppRoutes.merchantRequestDetails, arguments: requestId);
    } else {
      ApiChecker.checkApi(response);
    }
  }

  Future<void> sendProposal({
    required String requestId,
    required String proposal,
  }) async {
    loader.showLoader();

    final response = await requestRepo.startChat(
      requestId: requestId,
      proposal: proposal,
    );

    loader.hideLoader();

    if (response.statusCode == 201 && response.body['code'] == '00') {
      MySnackBars.success(
        title: 'Success',
        message: 'Proposal sent successfully',
      );
      Get.back(); // Close modal
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: response.body['message'] ?? 'Unable to send proposal',
      );
    }
  }

  //USERS

  Future<void> acceptMerchantInterest({
    required String requestId,
    required String interestId,
  }) async {
    loader.showLoader();
    final response = await requestRepo.chooseMerchant(requestId, interestId);
    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      await fetchSingleRequest(requestId);

      MySnackBars.success(
        title: "Success",
        message: response.body['message'] ?? 'Merchant accepted',
      );
      Get.toNamed(AppRoutes.bottomNav, arguments: 2);
    } else {
      MySnackBars.failure(
        title: "Error",
        message: response.body['message'] ?? 'Could not accept merchant',
      );
    }
  }

  Future<void> fetchUserRequests({bool showLoader = true}) async {
    // return;
    if (showLoader) loader.showLoader();

    final response = await requestRepo.getUserRequests();

    if (showLoader) loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      userRequests.value =
          (response.body['data'] as List)
              .map((e) => RequestModel.fromJson(e))
              .toList();
    } else {
      MySnackBars.failure(
        title: "Error",
        message: response.body['message'] ?? 'Could not fetch requests',
      );
    }
  }

  Future<void> fetchSingleRequest(String requestId) async {
    loader.showLoader();
    final response = await requestRepo.getSingleRequest(requestId);
    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      singleRequest.value = RequestModel.fromJson(response.body['data']);
    } else {
      MySnackBars.failure(
        title: "Error",
        message: response.body['message'] ?? 'Request not found',
      );
    }
  }

  Future<void> cancelRequest(String requestId) async {
    loader.showLoader();

    final response = await requestRepo.cancelUserRequest(requestId);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      await fetchUserRequests(); // Optional: refresh list
      MySnackBars.success(
        title: 'Cancelled',
        message: 'Request cancelled successfully',
      );
      Get.offAllNamed(AppRoutes.bottomNav, arguments: 1);
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: response.body['message'] ?? 'Could not cancel request',
      );
    }
  }

  Future<void> closeRequest(String requestId) async {
    loader.showLoader();

    final response = await requestRepo.closeUserRequest(requestId);

    loader.hideLoader();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      await fetchUserRequests(); // Optional: refresh list
      MySnackBars.success(
        title: 'Closed',
        message: 'Request closed successfully',
      );
      Get.offAllNamed(AppRoutes.bottomNav, arguments: 1);
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: response.body['message'] ?? 'Could not close request',
      );
    }
  }

  Future<void> createCarPartRequest({
    required File image,
    required Map<String, dynamic> fields,
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postCarPartRequest(
      carPartImage: image,
      fields: fields,
    );
    loader.hideLoader();

    try {
      final bodyString = response.body;
      Map<String, dynamic>? body;

      if (bodyString is String) {
        body = json.decode(bodyString);
      } else if (bodyString is Map<String, dynamic>) {
        body = bodyString;
      }

      if (response.statusCode == 201 && body?['code'] == '00') {
        await fetchUserRequests();
        MySnackBars.success(
          title: 'Success',
          message: body?['message'] ?? 'Car part request created successfully',
        );

        final requestId = body?['data']?['_id'];
        final token = authController.getUserToken();

        if (requestId != null && token != null) {
          final url =
              'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
          if (await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        }

        onSuccess?.call();
      } else {
        MySnackBars.failure(
          title: 'Failed',
          message: body?['message'] ?? 'Request failed',
        );
      }
    } catch (e, s) {
      MySnackBars.failure(title: "Error", message: "Unexpected error: $e");
      if (kDebugMode) {
        print("❌ Exception: $e\n$s");
      }
    }
  }

  Future<void> createRealEstateRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postRealEstateRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message:
            resBody['message'] ??
            'Real estate request created successfully, proceed to make payment',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> createCleaningRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();

    try {
      final response = await requestRepo.postCleaningRequest(body);
      loader.hideLoader();

      final resBody = response.body;
      if (response.statusCode == 201 && resBody?['code'] == '00') {
        await fetchUserRequests();
        MySnackBars.success(
          title: 'Success',
          message:
              resBody?['message'] ?? 'Cleaning request created successfully',
        );

        final requestId = resBody?['data']?['_id'];
        final token = authController.getUserToken();

        print('To redirect to the page $requestId, $token');

        if (requestId != null && token != null) {
          final url =
              'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
          if (await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        }

        onSuccess?.call();
      } else {
        final message = resBody?['message'] ?? 'Request failed';
        MySnackBars.failure(title: 'Failed', message: message);
      }
    } catch (e, s) {
      loader.hideLoader();
      print('❌ Exception: $e\n📍 StackTrace: $s');
      MySnackBars.failure(title: 'Error', message: 'Something went wrong.');
    }
  }

  Future<void> createCarHireRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postCarHireRequest(body);
    loader.hideLoader();

    try {
      final bodyString = response.body;
      Map<String, dynamic>? parsedBody;

      if (bodyString is String) {
        parsedBody = json.decode(bodyString);
      } else if (bodyString is Map<String, dynamic>) {
        parsedBody = bodyString;
      }

      if (response.statusCode == 201 &&
          parsedBody != null &&
          parsedBody['code'] == '00') {
        await fetchUserRequests();
        MySnackBars.success(
          title: 'Success',
          message:
              parsedBody['message'] ?? 'Car hire request created successfully',
        );

        final requestId = parsedBody['data']?['_id'];
        final token = authController.getUserToken();

        if (requestId != null && token != null) {
          final url =
              'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
          if (await canLaunchUrl(Uri.parse(url))) {
            launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
          }
        }

        onSuccess?.call();
      } else {
        final errorMessage = parsedBody?['message'] ?? 'Request failed';
        MySnackBars.failure(title: 'Failed', message: errorMessage);
      }
    } catch (e, s) {
      MySnackBars.failure(title: "Error", message: "Unexpected error: $e");
      if (kDebugMode) {
        print("❌ Car Hire Exception: $e\n$s");
      }
    }
  }

  Future<void> createAutomobileRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postAutomobileRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message:
            resBody['message'] ?? 'Automobile request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> createBeautyRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postBeautyRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message:
            resBody['message'] ?? 'Automobile request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> createCateringRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postCateringRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message: resBody['message'] ?? 'Catering request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> createCarpentryRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postCarpentryRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message: resBody['message'] ?? 'Carpentry request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> createElectricianRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postElectricianRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message:
            resBody['message'] ?? 'Electrician request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> createITRequest(
    Map<String, dynamic> body, {
    VoidCallback? onSuccess,
  }) async {
    loader.showLoader();
    final response = await requestRepo.postITRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message: resBody['message'] ?? 'IT request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }


  Future<void> createEventManagementRequest(
      Map<String, dynamic> body, {
        VoidCallback? onSuccess,
      }) async {
    loader.showLoader();
    final response = await requestRepo.postEventManagementRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message: resBody['message'] ?? 'Event Management request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }


  Future<void> createHospitalityRequest(
      Map<String, dynamic> body, {
        VoidCallback? onSuccess,
      }) async {
    loader.showLoader();
    final response = await requestRepo.postHospitalityRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message:
        resBody['message'] ?? 'Hospitality request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> createMediaRequest(
      Map<String, dynamic> body, {
        VoidCallback? onSuccess,
      }) async {
    loader.showLoader();
    final response = await requestRepo.postMediaRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message:
        resBody['message'] ?? 'Media request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }

  Future<void> createPlumbingRequest(
      Map<String, dynamic> body, {
        VoidCallback? onSuccess,
      }) async {
    loader.showLoader();
    final response = await requestRepo.postPlumbingRequest(body);
    loader.hideLoader();

    final resBody = response.body;
    if (response.statusCode == 201 && resBody['code'] == '00') {
      await fetchUserRequests();
      MySnackBars.success(
        title: 'Success',
        message:
        resBody['message'] ?? 'Plumbing request created successfully',
      );

      final requestId = resBody['data']?['_id'];
      final token = authController.getUserToken();

      if (requestId != null && token != null) {
        final url =
            'https://fyndr-bay.vercel.app/payment?id=$requestId&token=$token';
        if (await canLaunchUrl(Uri.parse(url))) {
          launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
        }
      }

      onSuccess?.call();
    } else {
      MySnackBars.failure(
        title: 'Failed',
        message: resBody['message'] ?? 'Request failed',
      );
    }
  }
}
