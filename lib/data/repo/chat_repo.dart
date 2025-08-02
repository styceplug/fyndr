import 'package:get/get.dart';
import '../../utils/app_constants.dart';
import '../api/api_client.dart';

class ChatRepo {
  final ApiClient apiClient;
  ChatRepo({required this.apiClient});

  Future<Response> getUserChats() async {
    return await apiClient.getData(AppConstants.GET_USER_CHATS);
  }

  Future<Response> getSingleChat(String chatId) async {
    return await apiClient.getData('/v1/chat/$chatId');
  }

  Future<Response> sendTextMessage({
    required String chatId,
    required String content,
    required String senderType,
  }) async {
    final body = {
      "chatId": chatId,
      "senderType": senderType,
      "content": content,
    };

    return await apiClient.postData(AppConstants.SEND_TEXT, body);
  }
}