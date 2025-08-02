import 'package:flutter/material.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/utils/dimensions.dart';

class ServiceCard extends StatelessWidget {
  final String iconName; // Example: 'delivery' or 'bike'
  final String title;
  final VoidCallback? onTap;

  const ServiceCard({
    super.key,
    required this.iconName,
    required this.title,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;

    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            alignment: Alignment.center,
            height: Dimensions.height20 * 5,
            width: Dimensions.width20 * 5,
            padding: EdgeInsets.all(Dimensions.height20),
            decoration: BoxDecoration(
              // color: Colors.white.withOpacity(0.05),
              color: AppColors.green3,
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              border: Border.all(color: Colors.white.withOpacity(0.8)),
              image: DecorationImage(
                image: AssetImage(AppConstants.getPngAsset(iconName)),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height5),
          Text(
            title,
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: textColor,
              fontSize: Dimensions.font13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
