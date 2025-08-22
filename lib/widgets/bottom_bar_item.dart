import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils/app_constants.dart';
import '../utils/colors.dart';
import '../utils/dimensions.dart';

class BottomBarItem extends StatefulWidget {
  final IconData image;
  final String name;
  final bool isActive;
  final Function() onClick;

  const BottomBarItem({
    super.key,
    required this.image,
    required this.name,
    required this.isActive,
    required this.onClick,
  });

  @override
  State<BottomBarItem> createState() => _BottomBarItemState();
}

class _BottomBarItemState extends State<BottomBarItem> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: Dimensions.width70 + Dimensions.width10,
      child: InkWell(
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onClick();
        },
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // icon

            Icon(
              widget.image,
              size: Dimensions.iconSize16*1.65,
              color:
                  widget.isActive
                      ? Colors.white
                      : Colors.white.withOpacity(0.4),
            ),
            // space
            SizedBox(height: Dimensions.height5),
            // name
            Text(
              widget.name,
              maxLines: 1,
              style: TextStyle(
                color:
                    widget.isActive
                        ? AppColors.secondary
                        : Colors.white.withOpacity(0.4),
                fontWeight: FontWeight.w400,
                fontSize: Dimensions.font14,
                fontFamily: 'Mulish',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
