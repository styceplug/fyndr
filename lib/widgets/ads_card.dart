import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:iconsax/iconsax.dart';

import '../utils/app_constants.dart';
import '../utils/dimensions.dart';

class AdsCard extends StatelessWidget {
  final String title;
  final String subtitle;
  final String phoneNumber;
  final String imageName;
  final String avatar;
  final int activeIndex;
  final int totalIndicators;

  const AdsCard({
    super.key,
    required this.title,
    required this.avatar,
    required this.subtitle,
    required this.phoneNumber,
    required this.imageName,
    this.activeIndex = 0,
    this.totalIndicators = 3,
  });


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Column(
      children: [
        // Ad Card
        Expanded(
          child: Container(
            alignment: Alignment.topCenter,
            height: Dimensions.height100 * 5,
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            // margin: EdgeInsets.symmetric(horizontal: Dimensions.width20),
            decoration: BoxDecoration(
              color: isDark ? theme.cardColor : AppColors.green3,
              border: Border.all(color: theme.dividerColor),
              borderRadius: BorderRadius.circular(Dimensions.radius15),
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(AppConstants.getPngAsset(imageName)),
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(Dimensions.radius30 * 2),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
                child: Container(
                  alignment: Alignment.center,
                  height: Dimensions.height10 * 8,
                  decoration: BoxDecoration(
                    color: theme.cardColor.withOpacity(0.25),
                    border: Border.all(color: theme.dividerColor.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(Dimensions.radius30 * 2),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Avatar
                      Container(
                        height: Dimensions.height10 * 8,
                        width: Dimensions.width10 * 8,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: AssetImage(AppConstants.getPngAsset(avatar)),
                          ),
                        ),
                      ),
                      SizedBox(width: Dimensions.width15),
                      // Details
                      Expanded(
                        child: SizedBox(
                          height: Dimensions.height10 * 8,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                title,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                                style: TextStyle(
                                  color: theme.textTheme.bodyLarge?.color,
                                  fontSize: Dimensions.font16,
                                  fontWeight: FontWeight.bold,
                                  shadows: [
                                    Shadow(
                                      color: Colors.black26,
                                      offset: Offset(1, 1),
                                      blurRadius: 2,
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: Dimensions.height5 / 2),
                              // Rating Row
                              Row(
                                children: [
                                  Text(
                                    '4.5',
                                    style: TextStyle(
                                      color: theme.textTheme.bodyLarge?.color,
                                      fontSize: Dimensions.font14,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width5),
                                  ...List.generate(
                                    4,
                                        (index) => Icon(
                                      Icons.star,
                                      color: Colors.amber,
                                      size: Dimensions.iconSize16,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: Dimensions.height5 / 2),
                              // Location & Phone
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      'FCT Abuja',
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: theme.textTheme.bodyMedium?.color,
                                        fontSize: Dimensions.font13,
                                      ),
                                    ),
                                  ),
                                  SizedBox(width: Dimensions.width5),
                                  Flexible(
                                    child: Text(
                                      phoneNumber,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        color: theme.textTheme.bodyMedium?.color,
                                        fontSize: Dimensions.font13,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        SizedBox(height: Dimensions.height5),
        // Indicators
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            totalIndicators,
                (index) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: EdgeInsets.symmetric(horizontal: Dimensions.width5),
              height: Dimensions.height10,
              width: index == activeIndex ? Dimensions.width20 : Dimensions.width10,
              decoration: BoxDecoration(
                color: index == activeIndex
                    ? AppColors.green1
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(Dimensions.radius20),
                border: Border.all(color: AppColors.green1),
              ),
            ),
          ),
        ),
      ],
    );
  }}

class AdsCarousel extends StatefulWidget {
  const AdsCarousel({super.key});

  @override
  State<AdsCarousel> createState() => _AdsCarouselState();
}

class _AdsCarouselState extends State<AdsCarousel> {
  int _currentPage = 0;

  final List<Map<String, String>> _ads = [
    {
      'title': 'Omega 9 Laundry Services',
      'subtitle': 'Dry Cleaning and Cleaning Services',
      'phone': '234 123 4556 432',
      'image': 'food',
      'avatar': 'ad',
    },
    {
      'title': 'Swift Car Rentals',
      'subtitle': 'Affordable, Reliable Rentals',
      'phone': '234 111 222 333',
      'image': 'food',
      'avatar': 'ad',
    },
    {
      'title': 'Fresh Farm Market',
      'subtitle': 'Organic Produce Delivered',
      'phone': '234 888 999 000',
      'image': 'food',
      'avatar': 'ad',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: Dimensions.height50 * 5,
          child: PageView.builder(
            itemCount: _ads.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final ad = _ads[index];
              return AdsCard(
                title: ad['title']!,
                subtitle: ad['subtitle']!,
                phoneNumber: ad['phone']!,
                imageName: ad['image']!,
                avatar: ad['avatar']!,
                activeIndex: _currentPage,
                totalIndicators: _ads.length,
              );
            },
          ),
        ),
      ],
    );
  }
}
