import 'dart:convert';

import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/helpers/global_loader_controller.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/repo/chat_repo.dart';
import '../models/chat_model.dart';
import '../models/message_model.dart';
import '../utils/app_constants.dart';
import '../widgets/snackbars.dart';

class ChatController extends GetxController {
  final ChatRepo chatRepo;
  final SharedPreferences sharedPreferences = Get.find<SharedPreferences>();
  final loader = Get.find<GlobalLoaderController>();

  ChatController({required this.chatRepo});

  var chats = <ChatModel>[].obs;
  var isLoading = false.obs;
  Rxn<ChatModel> selectedChat = Rxn<ChatModel>();
  static const _chatCacheKey = 'cachedChats';
  static String _singleChatCacheKey(String chatId) => 'cached_chat_$chatId';
  AuthController authController = Get.find<AuthController>();



  @override
  void onInit() {
    super.onInit();
    loadCachedChats();
    fetchChats();
  }

  bool get isMerchant {
    return sharedPreferences.getBool(AppConstants.isMerchant) ?? false;
  }

  void cacheSingleChat(String chatId, ChatModel chat) {
    final encoded = jsonEncode(chat.toJson());
    sharedPreferences.setString(_singleChatCacheKey(chatId), encoded);
  }

  ChatModel? getCachedSingleChat(String chatId) {
    final raw = sharedPreferences.getString(_singleChatCacheKey(chatId));
    if (raw != null) {
      try {
        final decoded = jsonDecode(raw);
        return ChatModel.fromJson(decoded);
      } catch (e) {
        print("❌ Failed to decode cached chat: $e");
      }
    }
    return null;
  }

  void loadCachedChats() {
    final cached = sharedPreferences.getString(_chatCacheKey);
    print("🔍 Raw cached string: $cached");

    if (cached != null) {
      try {
        final decoded = jsonDecode(cached);
        if (decoded is List) {
          final validList = decoded.whereType<Map<String, dynamic>>().toList();
          final loadedChats = validList.map((e) => ChatModel.fromJson(e)).toList();

          chats.value = loadedChats;
          print("✅ Loaded chats from cache");

          // 🔄 Pre-cache each individual chat
          for (var chat in loadedChats) {
            if (chat.id != null) {
              cacheSingleChat(chat.id!, chat);
            }
          }
        } else {
          print("⚠️ Cached data is not a List. Skipping load.");
        }
      } catch (e) {
        print("❌ Failed to decode cached chats: $e");
      }
    }
  }

  Future<void> fetchChats() async {
    final response = await chatRepo.getUserChats();

    if (response.statusCode == 200 && response.body['code'] == '00') {
      final List data = response.body['data'];
      final newChats = data.map((e) => ChatModel.fromJson(e)).toList();
      chats.value = newChats;

      // ✅ Encode the list of ChatModels properly
      final cachedJson = jsonEncode(newChats.map((e) => e.toJson()).toList());
      await sharedPreferences.setString(_chatCacheKey, cachedJson);

      print("💾 Chats cached");
    } else {
      chats.clear();
    }
  }

  Future<void> fetchSingleChat(String chatId) async {

    /*final cached = getCachedSingleChat(chatId);
    if (cached != null) {
      selectedChat.value = cached;
      print("✅ Loaded single chat from cache");
    }*/
    // return;

    try {
      // loader.showLoader();
      final response = await chatRepo.getSingleChat(chatId);
      // loader.hideLoader();

      if (response.statusCode == 200 && response.body['code'] == '00') {
        final chat = ChatModel.fromJson(response.body['data']);
        selectedChat.value = chat;
        cacheSingleChat(chatId, chat); // 💾 Save to cache
        print("💾 Chat $chatId cached");
      } else {
        if (selectedChat.value == null) {
          selectedChat.value = null;
        }
        MySnackBars.failure(
          title: 'Error',
          message: response.body['message'] ?? 'Failed to load chat',
        );
      }
    } catch (e) {
      loader.hideLoader();
      print('❌ Exception while fetching chat: $e');
    }
  }

  Future<void> sendTextMessage(String chatId, String content) async {
    if (content.trim().isEmpty) return;

    final isMerchant = sharedPreferences.getBool(AppConstants.isMerchant) ?? false;
    final senderType = isMerchant ? 'Merchant' : 'User';
    final currentUserId = isMerchant
        ? authController.currentMerchant.value?.id
        : authController.currentUser.value?.id;

    final String messageId = '$chatId-$currentUserId-temp';


    final tempMessage = MessageModel(
      id: messageId,
      content: content.trim(),
      sender: Sender(
        senderType: senderType,
        senderId: SenderId(id: currentUserId),
      ),
      createdAt: DateTime.now(),
      isSending: true,
    );


    if (selectedChat.value != null) {
      final updatedMessages = List<MessageModel>.from(selectedChat.value!.messages ?? []);
      updatedMessages.add(tempMessage);

      selectedChat.value = selectedChat.value!.copyWith(messages: updatedMessages);
    }


    try {
      final response = await chatRepo.sendTextMessage(
        chatId: chatId,
        content: content.trim(),
        senderType: senderType,
      );

      if (response.statusCode == 201 && response.body['code'] == '00') {
        // final newMessage = MessageModel.fromJson(response.body['data']);
        //
        //
        // List<MessageModel> messages = List<MessageModel>.from(selectedChat.value!.messages ?? []);
        // int lastIndex = messages.indexWhere((msg) => msg.id == messageId);
        // messages[lastIndex] = newMessage;
        //
        //
        // selectedChat.value = selectedChat.value!.copyWith(
        //   messages: messages,
        //   lastMessage: newMessage,
        // );
        //
        // cacheSingleChat(chatId, selectedChat.value!);
        print('💾 Cached updated chat');
        print('✅ Message sent');
      } else {
        _markLastMessageAsFailed();
      }
    } catch (e) {
      print('❌ Error sending message: $e');
      _markLastMessageAsFailed();
    }
  }

  void _markLastMessageAsFailed() {
    if (selectedChat.value != null) {
      final messages = List<MessageModel>.from(selectedChat.value!.messages ?? []);
      final last = messages.last.copyWith(isSending: false, hasError: true);
      messages[messages.length - 1] = last;

      selectedChat.value = selectedChat.value!.copyWith(messages: messages);
    }
  }

}