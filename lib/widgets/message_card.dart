import 'package:flutter/material.dart';
import 'package:fyndr/controllers/chat_controller.dart';
import 'package:fyndr/models/chat_model.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../screens/main_menu/user/chat_screen.dart';

class MessageCard extends StatelessWidget {
  final ChatModel chat;
  final String avatarAsset;
  final String userName;
  final String messagePreview;
  final String time;
  final double? rating;
  final VoidCallback? onTap;

  const MessageCard({
    super.key,
    required this.chat,
    required this.avatarAsset,
    required this.userName,
    required this.messagePreview,
    required this.time,
    this.rating,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isMerchant = Get.find<SharedPreferences>().getBool(AppConstants.isMerchant) ?? false;
    final ChatController chatController = Get.find<ChatController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final int unreadCount = isMerchant
        ? chat.merchantUnreadCount ?? 0
        : chat.userUnreadCount ?? 0;

    final bool hasUnread = unreadCount > 0;

    return InkWell(
      onTap: () async {
        await chatController.fetchSingleChat(chat.id ?? '');
        Get.to(() => ChatScreen(chatId: chat.id ?? ''));
      },
      child: Container(
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        child: Row(
          children: [
            // Avatar with badge
            Stack(
              clipBehavior: Clip.none,
              children: [
                Container(
                  height: Dimensions.height50,
                  width: Dimensions.width50,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                      image: NetworkImage(avatarAsset),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                if (hasUnread)
                  Positioned(
                    top: -4,
                    right: -4,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.redAccent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: theme.scaffoldBackgroundColor,
                          width: 1.5,
                        ),
                      ),
                      constraints: const BoxConstraints(minWidth: 20, minHeight: 20),
                      child: Center(
                        child: Text(
                          unreadCount > 99 ? '99+' : '$unreadCount',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
              ],
            ),
            SizedBox(width: Dimensions.width10),

            // Name & Preview
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: Dimensions.font16,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                  Text(
                    messagePreview,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontWeight: hasUnread ? FontWeight.bold : FontWeight.w300,
                      fontSize: Dimensions.font14,
                      color: theme.textTheme.bodyMedium?.color?.withOpacity(0.8),
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(width: Dimensions.width10),

            // Rating & Time
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                if (!isMerchant)
                  Row(
                    children: [
                      Icon(
                        Icons.star_border_outlined,
                        color: isDark ? Colors.amber.shade300 : Colors.brown,
                        size: Dimensions.iconSize20,
                      ),
                      SizedBox(width: 2),
                      Text(
                        rating?.toStringAsFixed(1) ?? '0.0',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: theme.textTheme.bodySmall?.color,
                        ),
                      ),
                    ],
                  ),
                Text(
                  time,
                  style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: Dimensions.font13,
                    color: theme.textTheme.bodySmall?.color?.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}