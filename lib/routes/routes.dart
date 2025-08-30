import 'package:fyndr/screens/guest/guest_automobile_form.dart';
import 'package:fyndr/screens/guest/guest_bottom_nav.dart';
import 'package:fyndr/screens/guest/guest_car_hire_form.dart';
import 'package:fyndr/screens/guest/guest_car_parts_form.dart';
import 'package:fyndr/screens/guest/guest_cleaning_form.dart';
import 'package:fyndr/screens/guest/guest_real_estate_form.dart';
import 'package:fyndr/screens/main_menu/merchant/merchant_notification.dart';
import 'package:fyndr/screens/main_menu/merchant/verify_merchant.dart';
import 'package:fyndr/screens/main_menu/user/more_services_screen.dart';
import 'package:fyndr/screens/main_menu/user/navigation.dart';
import 'package:fyndr/screens/main_menu/user/notification_screen.dart';
import 'package:fyndr/screens/others/employer_screen.dart';
import 'package:fyndr/screens/others/employment_screen.dart';
import 'package:fyndr/screens/others/job_seeker_screen.dart';
import 'package:fyndr/screens/others/post_cv_screen.dart';
import 'package:fyndr/screens/others/post_job_screen.dart';
import 'package:fyndr/screens/request_forms/beauty_form.dart';
import 'package:fyndr/screens/request_forms/carpentry_form.dart';
import 'package:fyndr/screens/request_forms/event_form.dart';
import 'package:fyndr/screens/request_forms/electrician_form.dart';
import 'package:fyndr/screens/request_forms/employment_form.dart';
import 'package:fyndr/screens/request_forms/hospitality_form.dart';
import 'package:fyndr/screens/request_forms/mechanic_form.dart';
import 'package:fyndr/screens/request_forms/media_form.dart';
import 'package:fyndr/screens/request_forms/plumbing_form.dart';
import 'package:fyndr/screens/request_forms/software_development_form.dart';
import 'package:fyndr/screens/splash_onboard/no_internet_screen.dart';
import 'package:fyndr/screens/splash_onboard/update_app_screen.dart';
import 'package:get/get.dart';
import 'package:fyndr/screens/auth/merchant/merchant_auth_screen.dart';
import 'package:fyndr/screens/auth/merchant/merchant_complete_auth.dart';
import 'package:fyndr/screens/auth/user/user_auth_screen.dart';
import 'package:fyndr/screens/auth/user/user_complete_auth.dart';
import 'package:fyndr/screens/auth/user/user_verify_otp.dart';
import 'package:fyndr/screens/main_menu/merchant/merchant_message.dart';
import 'package:fyndr/screens/main_menu/merchant/merchant_profile.dart';
import 'package:fyndr/screens/main_menu/merchant/request_board.dart';
import 'package:fyndr/screens/main_menu/user/home_screen.dart';
import 'package:fyndr/screens/main_menu/user/messages_screen.dart';
import 'package:fyndr/screens/main_menu/user/profile_screen.dart';
import 'package:fyndr/screens/main_menu/user/request_screen.dart';
import 'package:fyndr/screens/request_forms/automobile_form.dart';
import 'package:fyndr/screens/request_forms/car_hire_form.dart';
import 'package:fyndr/screens/request_forms/car_parts_form.dart';
import 'package:fyndr/screens/request_forms/cleaning_form.dart';
import 'package:fyndr/screens/request_forms/real_estate_form.dart';
import 'package:fyndr/screens/splash_onboard/onboarding_screen.dart';
import 'package:fyndr/widgets/bottom_nav.dart';
import 'package:fyndr/widgets/merchant_bottom_nav.dart';
import '../screens/auth/merchant/merchant_verify_otp.dart';
import '../screens/main_menu/merchant/merchant_request_details_screen.dart';
import '../screens/main_menu/merchant/update_business.dart';
import '../screens/others/cv_details_screen.dart';
import '../screens/others/job_details_screen.dart';
import '../screens/splash_onboard/splash_screen.dart';

class AppRoutes {
  static const String bottomNav = '/bottom-nav';
  static const String merchantBottomNav = '/merchant-bottom-nav';
  static const String guestBottomNav = '/guest-bottom-nav';
  static const String splashScreen = '/splash-screen';
  static const String onboardingScreen = '/onboarding-screen';

  static const String userAuthScreen = '/user-auth-screen';
  static const String userVerifyOtpScreen = '/verify-otp';
  static const String userCompleteAuth = '/user-complete-auth';

  static const String merchantAuthScreen = '/merchant-auth-screen';
  static const String merchantVerifyOtpScreen = '/merchant-verify-otp';
  static const String merchantCompleteAuth = '/merchant-complete-auth';

  static const String updateAppScreen = '/update-app-screen';
  static const String noInternetScreen = '/no-internet-screen';

  static const String homeScreen = '/home-screen';
  static const String messagesScreen = '/messages-screen';
  static const String profileScreen = '/profile-screen';
  static const String requestScreen = '/request-screen';
  static const String automobileForm = '/automobile-form';
  static const String beautyForm = '/beauty-form';
  static const String carHireForm = '/car-hire-form';
  static const String carPartsForm = '/car-parts-form';
  static const String carpentryForm = '/carpentry-form';
  static const String cateringForm = '/catering-form';
  static const String cleaningForm = '/cleaning-form';
  static const String electricianForm = '/electrician-form';
  static const String employmentForm = '/employment-form';
  static const String hospitalityForm = '/hospitality-form';
  static const String mechanicForm = '/mechanic-form';
  static const String mediaForm = '/media-form';
  static const String plumbingForm = '/plumbing-form';
  static const String realEstateForm = '/real-estate-form';
  static const String softwareDevelopmentForm = '/software-development-form';
  static const String notificationScreen = '/notification-screen';
  static const String moreServicesScreen = '/more-services-screen';
  static const String employmentScreen = '/employment-screen';
  static const String employerScreen = '/employer-screen';
  static const String jobSeekerScreen = '/job-seeker-screen';
  static const String postJobScreen = '/post-job-screen';
  static const String postCvScreen = '/post-cv-screen';
  static const String jobDetailsScreen = '/job-details-screen';
  static const String cvDetailsScreen = '/cv-details-screen';


  static const String merchantMessageScreen = '/merchant-message';
  static const String merchantProfileScreen = '/merchant-profile';
  static const String merchantRequestBoard = '/request-board';
  static const String verifyMerchantScreen = '/verify-merchant';
  static const String merchantRequestDetails = '/merchant-request-details';
  static const String merchantUpdateDetails = '/merchant-update-details';
  static const String merchantNotificationScreen =
      '/merchant-notification-details';

  static const String guestAutomobileForm = '/guest-automobile-form';
  static const String guestCarHireForm = '/guest-car-hire-form';
  static const String guestCarPartsForm = '/guest-car-parts-form';
  static const String guestCleaningForm = '/guest-cleaning-form';
  static const String guestRealEstateForm = '/guest-real-estate-form';

  static final routes = [

    //forms
    GetPage(
      name: automobileForm,
      page: () {
        return const AutomobileForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: beautyForm,
      page: () {
        return const BeautyForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: carHireForm,
      page: () {
        return const CarHireForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: carPartsForm,
      page: () {
        return const CarPartsForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cateringForm,
      page: () {
        return const EventForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cleaningForm,
      page: () {
        return const CleaningForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: electricianForm,
      page: () {
        return const ElectricianForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: employmentForm,
      page: () {
        return const EmploymentForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: mechanicForm,
      page: () {
        return const MechanicForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: mediaForm,
      page: () {
        return const MediaForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: plumbingForm,
      page: () {
        return const PlumbingForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: realEstateForm,
      page: () {
        return const RealEstateForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: softwareDevelopmentForm,
      page: () {
        return const SoftwareDevelopmentForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: carpentryForm,
      page: () {
        return const CarpentryForm();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: hospitalityForm,
      page: () {
        return const HospitalityForm();
      },
      transition: Transition.fadeIn,
    ),

    //splash && onboard && miscellaneous
    GetPage(
      name: updateAppScreen,
      page: () {
        return UpdateAppScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: noInternetScreen,
      page: () {
        return NoInternetScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: splashScreen,
      page: () {
        return const SplashScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: onboardingScreen,
      page: () {
        return const OnBoardingScreen();
      },
      transition: Transition.fadeIn,
    ),

    //merchants
    GetPage(
      name: merchantRequestDetails,
      page: () {
        return MerchantRequestDetailsScreen();
      },
    ),
    GetPage(
      name: verifyMerchantScreen,
      page: () {
        return VerifyMerchantScreen();
      },
    ),
    GetPage(
      name: merchantUpdateDetails,
      page: () {
        return MerchantUpdateDetails();
      },
    ),
    GetPage(
      name: merchantNotificationScreen,
      page: () {
        return MerchantNotificationScreen();
      },
    ),
    GetPage(
      name: merchantMessageScreen,
      page: () {
        return const MerchantMessage();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: merchantProfileScreen,
      page: () {
        return const MerchantProfile();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: merchantRequestBoard,
      page: () {
        return const RequestBoard();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: merchantAuthScreen,
      page: () {
        return const MerchantAuthScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: merchantCompleteAuth,
      page: () {
        return const MerchantCompleteAuth();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: merchantVerifyOtpScreen,
      page: () {
        return const MerchantVerifyOtp();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: merchantBottomNav,
      page: () {
        return const MerchantBottomNav();
      },
      transition: Transition.fadeIn,
    ),

    //guests
    GetPage(
      name: guestBottomNav,
      page: () {
        return GuestBottomNav();
      },
    ),
    GetPage(
      name: guestAutomobileForm,
      page: () {
        return GuestAutomobileForm();
      },
    ),
    GetPage(
      name: guestCarHireForm,
      page: () {
        return GuestCarHireForm();
      },
    ),
    GetPage(
      name: guestCarPartsForm,
      page: () {
        return GuestCarPartsForm();
      },
    ),
    GetPage(
      name: guestCleaningForm,
      page: () {
        return GuestCleaningForm();
      },
    ),
    GetPage(
      name: guestRealEstateForm,
      page: () {
        return GuestRealEstateForm();
      },
    ),

    //user
    GetPage(
      name: moreServicesScreen,
      page: () {
        return MoreServicesScreen();
      },
    ),
    GetPage(
      name: userAuthScreen,
      page: () {
        return const UserAuthScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: userVerifyOtpScreen,
      page: () {
        return const VerifyOtp();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: userCompleteAuth,
      page: () {
        return const UserCompleteAuth();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: homeScreen,
      page: () {
        return const HomeScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: messagesScreen,
      page: () {
        return const MessagesScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: profileScreen,
      page: () {
        return const ProfileScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: requestScreen,
      page: () {
        return const RequestScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: notificationScreen,
      page: () {
        return NotificationScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: bottomNav,
      page: () {
        return const Navigation();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: employmentScreen,
      page: () {
        return const EmploymentScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: employerScreen,
      page: () {
        return const EmployerScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: jobSeekerScreen,
      page: () {
        return const JobSeekerScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: postJobScreen,
      page: () {
        return const PostJobScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: postCvScreen,
      page: () {
        return const PostCvScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: jobDetailsScreen,
      page: () {
        return  JobDetailsScreen();
      },
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: cvDetailsScreen,
      page: () {
        return const CvDetailsScreen();
      },
      transition: Transition.fadeIn,
    ),


  ];
}
