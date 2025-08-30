import 'dart:ffi';

class AppConstants {

  // basic
  static const String APP_NAME = 'FYNDR';


  // static const String BASE_URL = 'http://fyndr.ng:5002/api';
  // static const String BASE_URL = 'https://rheel-compare.onrender.com/api';
  static const String BASE_URL = 'https://api.fyndr.ng/api';

  //TOKEN
  static const authToken = 'authToken';
  static const header = 'header';
  static const String lastVersionCheck = 'lastVersionCheck';

  static const String UPDATE_DEVICE_TOKEN = '/v1/user/device-token';
  static const String UPDATE_MERCHANT_DEVICE_TOKEN = '/v1/merchant/device-token';

  static const String isMerchant = 'isMerchant';


  static const String VERSION_CHECK = '/version-check';


  static const String VERIFY_OTP = '/v1/auth/otp/verify';


  static const String SEND_TEXT = '/v1/message';







  //users
  static const String USER_REQUEST_OTP = '/v1/auth/otp/user';
  static const String USER_RESEND_OTP = '/v1/auth/otp/user/resend';
  static const String USER_REGISTER = '/v1/auth/register/user';
  static const String DELETE_USER = '/v1/user/destroy';
  static const String GET_NOTIFICATIONS = '/v1/notification';

  static const String USER_PROFILE = '/v1/user/profile';
  static const String UPDATE_USER_PROFILE_IMAGE = '/v1/user/profile-image';




  static const String GET_REQUESTS = '/v1/request/user';
  static const String GET_SINGLE_REQUEST = '/v1/request/user/{requestId}';
  static const String CANCEL_REQUEST = '/v1/request/user/{requestId}/cancel';
  static const String COMPLETE_REQUEST = '/v1/request/user/{requestId}/close';
  static const String CHOOSE_MERCHANT = '/v1/request/user/{requestId}/interest';


  static const String GET_USER_CHATS= '/v1/chat';
  static const String GET_USER_SINGLE_CHATS= '/v1/chat/{chatId}';



  //employment
  static const String GET_JOB_LISTINGS= '/v1/job';
  static const String GET_ALL_CV= '/v1/cv';
  static const String POST_OPEN_JOB = '/v1/job';
  static const String GET_SINGLE_JOB = '/v1/job/single/{jobId}';
  static const String POST_CV = '/v1/cv';
  static const String GET_SINGLE_CV = '/v1/cv/single/{cvId}';
  static const String GET_USER_CV = '/v1/cv/personal';
  static const String POST_PROPOSAL = '/v1/job/single/{jobId}';





  static const String POST_CARPART_REQUESTS = '/v1/request/car-part';
  static const String POST_REALESTATE_REQUESTS = '/v1/request/real-estate';
  static const String POST_CLEANING_REQUESTS = '/v1/request/cleaning';
  static const String POST_CARHIRE_REQUESTS = '/v1/request/car-hire';
  static const String POST_AUTOMOBILE_REQUESTS = '/v1/request/automobile';
  static const String POST_BEAUTY_REQUESTS = '/v1/request/beauty';
  static const String POST_CATERING_REQUESTS = '/v1/request/catering';
  static const String POST_CARPENTRY_REQUESTS = '/v1/request/carpenter';
  static const String POST_ELECTRICAL_REQUESTS = '/v1/request/electrician';
  static const String POST_IT_REQUESTS = '/v1/request/it';
  static const String POST_MECHANIC_REQUESTS = '/v1/request/mechanic';
  static const String POST_MEDIA_REQUESTS = '/v1/request/media';
  static const String POST_PLUMBING_REQUESTS = '/v1/request/plumber';
  static const String POST_HOSPITALITY_REQUESTS = '/v1/request/hospitality';
  static const String POST_EVENT_MANAGEMENT_REQUESTS = '/v1/request/event-management';








  //merchants
  static const String MERCHANT_REQUEST_OTP = '/v1/auth/otp/merchant';
  static const String MERCHANT_RESEND_OTP = '/v1/auth/otp/merchant/resend';
  static const String MERCHANT_REGISTER = '/v1/auth/register/merchant';

  static const String MERCHANT_PROFILE = '/v1/merchant/profile';
  static const String DELETE_MERCHANT = '/v1/merchant/destroy';
  static const String UPDATE_MERCHANT_PROFILE_IMAGE = '/v1/merchant/profile-image';
  static const String UPDATE_MERCHANT_BUSINESS_DETAILS = '/v1/merchant/update/business';
  static const String VERIFY_BUSINESS = '/v1/merchant/verify';



  static const String START_CHAT = '/v1/chat';
  static const String GET_MERCHANT_NOTIFICATION = '/v1/notification/merchant';




  static const String GET_MERCHANT_REQUESTS = '/v1/request/merchant';
  static const String GET_SINGLE_MERCHANT_REQUEST = '/v1/request/merchant/{requestId}';










  static const String FIRST_INSTALL = 'first-install';
  static const String REMEMBER_KEY = 'remember-me';



  static String getPngAsset(String image) {
    return 'assets/images/$image.png';
  }
  static String getGifAsset(String image) {
    return 'assets/gifs/$image.gif';
  }
  static String getMenuIcon(String image) {
    return 'assets/menu_icons/$image.png';
  }

}
