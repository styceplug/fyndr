import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:get/get.dart';

import '../../../controllers/chat_controller.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/message_card.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({super.key});

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  ChatController chatController = Get.find<ChatController>();

  Timer? pollingTimer;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      chatController.loadCachedChats();
    });
    pollingTimer = Timer.periodic(Duration(seconds: 5), (_) {
      chatController.fetchChats();
    });
  }

  @override
  void dispose() {
    pollingTimer?.cancel();
    chatController.loadCachedChats();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: const CustomAppbar(
        title: 'Messages',
        centerTitle: true,
      ),
      body: Obx(() {
        if (chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        final chats = chatController.chats.reversed.toList();

        if (chats.isEmpty) {
          return const Center(
            child: EmptyState(message: 'No messages yet'),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          itemCount: chats.length,
          itemBuilder: (context, index) {
            final chat = chats[index];

            return MessageCard(
              avatarAsset: chat.merchant?.avatar ?? '',
              userName:
              '${chat.merchant?.businessName} - ${chat.request?.title}',
              messagePreview: chat.messages?.last.content ?? '',
              time: timeAgo(chat.messages?.last.createdAt),
              rating: chat.merchant?.rating?.average?.toDouble() ?? 0.0,
              onTap: () {
                // TODO: Navigate to chat details screen
              },
              chat: chat,
            );
          },
        );
      }),
    );
  }

  String timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}
