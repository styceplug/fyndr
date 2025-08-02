import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/models/request_model.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:get/get.dart';

import '../screens/request_forms/request_details_screen.dart';

class RequestCard extends StatelessWidget {
  final String title;
  final String category;
  final DateTime? date;
  final String serviceType;
  final String requestId;
  final VoidCallback? onTap;

   RequestCard({
    super.key,
    required this.title,
    required this.category,
    this.date,
    required this.serviceType,
    required this.requestId,
    this.onTap,
  });

  RequestController requestController = Get.find<RequestController>();

  String _formatCategory(String value) {
    if (value.isEmpty) return '';
    return value
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String _formatTimeAgo(DateTime? date) {
    if (date == null) return '';
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) {
      if (diff.inHours < 1) return '${diff.inMinutes}m ago';
      return '${diff.inHours}h ago';
    } else if (diff.inDays == 1) {
      return 'Yesterday';
    } else if (diff.inDays < 7) {
      return '${diff.inDays}d ago';
    } else if (diff.inDays < 30) {
      return '${(diff.inDays / 7).floor()}w ago';
    } else if (diff.inDays < 365) {
      return '${(diff.inDays / 30).floor()}mo ago';
    } else {
      return '${(diff.inDays / 365).floor()}y ago';
    }
  }

  String _getIconNameFromServiceType(String type) {
    switch (type.toLowerCase()) {
      case 'automobile':
        return 'automobile';
      case 'car-hire':
        return 'carHire';
      case 'car-parts':
        return 'carParts';
      case 'cleaning':
        return 'cleaning';
      case 'real-estate':
        return 'realEstate';
      default:
        return 'default_service';
    }
  }

  @override
  Widget build(BuildContext context) {
    final iconName = _getIconNameFromServiceType(serviceType);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: () {
        Get.to(() => RequestDetailsScreen(requestId: requestId));
      },
      child: Container(
        height: Dimensions.height10 * 8,
        padding: EdgeInsets.symmetric(vertical: Dimensions.height10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Icon box
            Container(
              height: Dimensions.height10 * 6,
              width: Dimensions.width10 * 6,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.width10,
                vertical: Dimensions.height10,
              ),
              decoration: BoxDecoration(
                color: theme.colorScheme.secondary.withOpacity(0.2),
                borderRadius: BorderRadius.circular(Dimensions.radius10),
              ),
              child: Image.asset(
                AppConstants.getPngAsset(iconName),
                fit: BoxFit.fitWidth,
                color: isDark ? Colors.white : Colors.black,
              ),
            ),
            SizedBox(width: Dimensions.width10),

            // Info
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontSize: Dimensions.font17,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _formatCategory(category),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: Dimensions.font15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      SizedBox(width: Dimensions.width10),
                      Text(
                        _formatTimeAgo(date),
                        style: theme.textTheme.bodyMedium?.copyWith(
                          fontSize: Dimensions.font15,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Icon(
              CupertinoIcons.chevron_forward,
              color: theme.iconTheme.color,
            ),
          ],
        ),
      ),
    );
  }
}
