import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../models/message_model.dart';
import '../../utils/dimensions.dart';
import '../../controllers/auth_controller.dart';
import '../utils/app_constants.dart';

class MessageBubble extends StatelessWidget {
  final MessageModel message;
  final bool isFromMe;

  const MessageBubble({Key? key, required this.message, required this.isFromMe}) : super(key: key);

  bool get isMessageFromMe {
    final auth = Get.find<AuthController>();
    final prefs = Get.find<SharedPreferences>();
    final isMerchant = prefs.getBool(AppConstants.isMerchant) ?? false;

    final myId = isMerchant
        ? auth.currentMerchant.value?.id
        : auth.currentUser.value?.id;

    // ✅ Check senderId string against your ID
    return message.sender?.senderId?.id.toString() == myId;
  }


  @override
  Widget build(BuildContext context) {
    final isTemp = message.isSending == true;
    final isFromMe = isMessageFromMe;

    final time = message.createdAt != null
        ? DateFormat.jm().format(message.createdAt!)
        : '';

    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bubbleColor = isTemp
        ? (isDark ? Colors.grey.shade700 : Colors.grey.shade400)
        : isFromMe
        ? (isDark ? Colors.green.shade600 : Colors.green.shade400)
        : (isDark ? Colors.grey.shade800 : Colors.grey.shade300);

    final textColor = isDark ? Colors.white : Colors.black87;
    final timeColor = isDark ? Colors.white70 : Colors.black45;

    return Align(
      alignment: isFromMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 6, horizontal: 12),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 14),
        constraints: const BoxConstraints(maxWidth: 300),
        decoration: BoxDecoration(
          color: bubbleColor,
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(16),
            topRight: const Radius.circular(16),
            bottomLeft: Radius.circular(isFromMe ? 16 : 4),
            bottomRight: Radius.circular(isFromMe ? 4 : 16),
          ),
        ),
        child: Column(
          crossAxisAlignment:
          isFromMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message.content ?? '',
              style: TextStyle(fontSize: 15, color: textColor),
            ),
            const SizedBox(height: 4),
            Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 11,
                    color: timeColor,
                  ),
                ),
                if (isFromMe) ...[
                  const SizedBox(width: 6),
                  if (isTemp)
                    SizedBox(
                      height: 12,
                      width: 12,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: isDark ? Colors.white : Colors.black,
                      ),
                    )
                  else
                    Icon(
                      Icons.done_all,
                      size: 16,
                      color: isDark ? Colors.white : Colors.black54,
                    ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }}