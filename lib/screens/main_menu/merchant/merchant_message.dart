import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/chat_controller.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/empty_state_widget.dart';
import '../../../widgets/message_card.dart';

class MerchantMessage extends StatefulWidget {
  const MerchantMessage({super.key});

  @override
  State<MerchantMessage> createState() => _MerchantMessageState();
}

class _MerchantMessageState extends State<MerchantMessage> {
  final ChatController chatController = Get.find<ChatController>();

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
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final now = DateTime.now();

    final filteredChats = chatController.chats.where((chat) {
      final lastMessageTime = chat.messages?.last.createdAt;
      return lastMessageTime != null &&
          now.difference(lastMessageTime).inDays <= 7;
    }).toList()
      ..sort((a, b) {
        final aTime = a.messages?.last.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bTime = b.messages?.last.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bTime.compareTo(aTime); // 🔽 Most recent first
      });

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(
        title: 'Messages',
        centerTitle: true,
      ),
      body: Obx(() {
        if (chatController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        if (filteredChats.isEmpty) {
          return Center(
            child: EmptyState(
              message: 'No messages yet',
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          itemCount: filteredChats.length,
          itemBuilder: (context, index) {
            final chat = filteredChats[index];
            final user = chat.user;

            return MessageCard(
              chat: chat,
              avatarAsset: user?.avatar ?? '',
              userName: '${user?.name} - ${chat.request?.title}',
              messagePreview: chat.messages?.last.content ?? 'No message',
              time: timeAgo(chat.messages?.last.createdAt),
              rating: null,
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
