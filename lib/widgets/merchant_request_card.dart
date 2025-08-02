import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:get/get.dart';
import '../models/request_model.dart';
import '../routes/routes.dart';
import '../screens/main_menu/merchant/merchant_request_details_screen.dart';
import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class MerchantRequestCard extends StatelessWidget {
  final String requestId; // Add this field
  final String title;
  final String category;
  final DateTime? date;
  final String serviceType;
  final String address;
  final String description;

  const MerchantRequestCard({
    super.key,
    required this.requestId, // Add this to constructor
    required this.title,
    required this.category,
    required this.date,
    required this.serviceType,
    required this.address,
    required this.description,
  });


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
    final requestController = Get.find<RequestController>();
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      padding: EdgeInsets.all(Dimensions.height12),
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(Dimensions.radius10),
        color: theme.cardColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon box
          Container(
            height: Dimensions.height10 * 6,
            width: Dimensions.width10 * 6,
            padding: EdgeInsets.all(Dimensions.height10),
            decoration: BoxDecoration(
              color: AppColors.secondary.withOpacity(isDark ? 0.2 : 1),
              borderRadius: BorderRadius.circular(Dimensions.radius10),
            ),
            child: Image.asset(
              AppConstants.getPngAsset(iconName),
              fit: BoxFit.contain,
              color: isDark ? Colors.white : Colors.black,
            ),
          ),
          SizedBox(width: Dimensions.width10),

          // Info section
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontSize: Dimensions.font17,
                    fontWeight: FontWeight.w600,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Dimensions.height5),

                Text(
                  address,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: Dimensions.font14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.7),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: Dimensions.height5),

                Text(
                  description,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontSize: Dimensions.font14,
                    color: theme.textTheme.bodyMedium?.color?.withOpacity(0.6),
                  ),
                ),
                SizedBox(height: Dimensions.height10),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (date != null)
                      Text(
                        _formatTimeAgo(date),
                        style: theme.textTheme.bodySmall?.copyWith(
                          fontSize: Dimensions.font13,
                          color: theme.textTheme.bodySmall?.color?.withOpacity(0.6),
                        ),
                      ),
                    ElevatedButton(
                      onPressed: () {
                        requestController.fetchSingleMerchantRequest(requestId);
                      },
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(
                          horizontal: Dimensions.width20,
                          vertical: Dimensions.height10,
                        ),
                        backgroundColor: AppColors.primary,
                      ),
                      child: const Text(
                        'More Details',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}