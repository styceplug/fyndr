import 'package:flutter/material.dart';

import '../utils/app_constants.dart';
import '../utils/dimensions.dart';

class EmptyState extends StatelessWidget {
  final String message;

  const EmptyState({super.key, required this.message});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return SizedBox(
      height: Dimensions.screenHeight,
      width: Dimensions.screenWidth,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            height: Dimensions.height100 * 2,
            width: Dimensions.width100 * 2,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage(AppConstants.getPngAsset('empty')),
              ),
            ),
          ),
          SizedBox(height: Dimensions.height10),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              height: 22 / 14,
              fontWeight: FontWeight.normal,
              color: textColor.withOpacity(0.8),
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: Dimensions.height20 * 10),
        ],
      ),
    );
  }
}
