import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/chat_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../models/message_model.dart';
import '../../../widgets/message_bubble.dart';



class ChatScreen extends StatefulWidget {
  final String chatId;
  const ChatScreen({super.key, required this.chatId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final ChatController chatController = Get.find<ChatController>();
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController messageController = TextEditingController();

  Timer? _pollingTimer;

  bool shouldRefresh = true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.fetchSingleChat(widget.chatId); // Initial fetch
    });

    _pollingTimer = Timer.periodic(Duration(seconds: 10), (_) {
      if(shouldRefresh)
      chatController.fetchSingleChat(widget.chatId);
    });
  }

  @override
  void dispose() {
    _pollingTimer?.cancel();
    messageController.dispose();
    chatController.selectedChat.value = null;
    super.dispose();
  }

  void sendMessage()async {
    final text = messageController.text.trim();
    if (text.isEmpty) return;
    setState(() {
      shouldRefresh = false;
    });
    await chatController.sendTextMessage(widget.chatId, text);
    messageController.clear();
    setState(() {
      shouldRefresh = true;
    });
  }

  bool isMessageFromMe(MessageModel msg) {
    final isMerchant = chatController.isMerchant;
    final currentUserId = isMerchant
        ? authController.currentMerchant.value?.id
        : authController.currentUser.value?.id;

    return msg.sender?.senderId?.id == currentUserId;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final inputBgColor = theme.cardColor;
    final iconColor = theme.iconTheme.color;

    final user = authController.currentUser.value;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        elevation: 0.5,
        title: Obx(() {
          final chat = chatController.selectedChat.value;
          final isMerchant = chatController.isMerchant;
          final userName = chat?.user?.name ?? 'User';
          final merchantName = chat?.merchant?.businessName ?? 'Merchant';

          return Text(
            isMerchant ? userName.toUpperCase() : merchantName.toUpperCase(),
            style: TextStyle(
              color: theme.textTheme.titleLarge?.color,
              fontWeight: FontWeight.w600,
            ),
            overflow: TextOverflow.ellipsis,
          );
        }),
        centerTitle: true,
        iconTheme: IconThemeData(color: iconColor),
      ),
      body: Obx(() {
        final chat = chatController.selectedChat.value;
        final messages = chat?.messages ?? [];

        return Column(
          children: [
            Expanded(
              child: ListView.builder(
                reverse: true,
                itemCount: messages.length,
                itemBuilder: (_, index) {
                  final msg = messages[messages.length - 1 - index];
                  final isFromMe = isMessageFromMe(msg);

                  return MessageBubble(message: msg, isFromMe: isFromMe);
                },
              ),
            ),

            // Message input
            Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  color: inputBgColor,
                  child: Row(
                    children: [
                      Expanded(
                        child: CustomTextField(
                          hintText: 'Type your message...',
                          controller: messageController,
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.send, color: iconColor),
                        onPressed: sendMessage,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: Dimensions.height30),
              ],
            ),
          ],
        );
      }),
    );
  }
}