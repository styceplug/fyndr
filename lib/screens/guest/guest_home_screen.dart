import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:marquee/marquee.dart';

import '../../controllers/auth_controller.dart';
import '../../controllers/theme_controller.dart';
import '../../data/services/home_marque.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/colors.dart';
import '../../utils/dimensions.dart';
import '../../widgets/ads_card.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/profile_avatar.dart';
import '../../widgets/service_card.dart';

class GuestHomeScreen extends StatefulWidget {
  const GuestHomeScreen({super.key});

  @override
  State<GuestHomeScreen> createState() => _GuestHomeScreenState();
}

class _GuestHomeScreenState extends State<GuestHomeScreen> {



  @override
  final String combinedText = marqueTexts.join('                 ');
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

  void onItemTapped() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20.0,
            vertical: 24.0,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.lock_outline, size: 48, color: Colors.orange),
              const SizedBox(height: 16),
              Text(
                'Create an Account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'You need an account to access this feature. Sign up now to continue.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.grey[700],
                        side: BorderSide(color: Colors.grey.shade300),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Cancel'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pop(context);
                        Get.offAllNamed(AppRoutes.onboardingScreen);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: Text('Sign Up'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Stack(
      children: [
        // bg image layer
        Container(
          height: Dimensions.screenHeight,
          width: Dimensions.screenWidth,
          decoration: BoxDecoration(
            image: DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage(AppConstants.getPngAsset('homeBg')),
            ),
          ),
        ),
        // color overlay
        Container(
          height: Dimensions.screenHeight,
          width: Dimensions.screenWidth,
          color: backgroundColor,
        ),
        Container(
          height: Dimensions.screenHeight,
          width: Dimensions.screenWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CustomAppbar(
                customTitle: Image.asset(
                  AppConstants.getPngAsset('logo'),
                  height: Dimensions.height40,
                ),
                centerTitle: true,
                leadingIcon: ProfileAvatar(
                  avatarUrl: authController.currentUser.value?.avatar,
                ),

                actionIcon: Row(
                  children: [
                    // Theme toggle
                    InkWell(
                      onTap: () => themeController.toggleTheme(),
                      child: Obx(() {
                        final isDark = themeController.themeMode.value == ThemeMode.dark;
                        return Icon(
                          isDark ? CupertinoIcons.sun_max_fill : CupertinoIcons.moon_fill,
                          color: isDark ? Colors.yellow : iconColor,
                        );
                      }),
                    ),
                    SizedBox(width: Dimensions.width10),
                    InkWell(
                      onTap: onItemTapped,
                      child: Icon(CupertinoIcons.bell_fill, color: iconColor),
                    ),
                  ],
                ),
              ),

              // Marquee
              Container(
                height: Dimensions.height28,
                alignment: Alignment.center,
                decoration: BoxDecoration(color: AppColors.green3),
                child: Marquee(
                  text: combinedText,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  style: TextStyle(
                    fontSize: Dimensions.font15,
                    color: Colors.white,
                  ),
                  blankSpace: Dimensions.width100,
                  velocity: 50,
                ),
              ),

              SizedBox(height: Dimensions.height50),

              // First row of services
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ServiceCard(
                      iconName: 'realEst',
                      title: 'Real Estate',
                      onTap: () => Get.toNamed(AppRoutes.guestRealEstateForm),
                    ),
                    ServiceCard(
                      iconName: 'parts',
                      title: 'Car Parts',
                      onTap: () => Get.toNamed(AppRoutes.guestCarPartsForm),
                    ),
                    ServiceCard(
                      iconName: 'employ',
                      title: 'Employment',
                      onTap: onItemTapped,
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // Second row of services
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ServiceCard(
                      iconName: 'cleani',
                      title: 'Cleaning',
                      onTap: () => Get.toNamed(AppRoutes.guestCleaningForm),
                    ),
                    ServiceCard(
                      iconName: 'autos',
                      title: 'Automobiles',
                      onTap: () => Get.toNamed(AppRoutes.guestAutomobileForm),
                    ),
                    InkWell(
                      onTap: () {
                        onItemTapped();
                      },
                      child: Column(
                        children: [
                          Container(
                            alignment: Alignment.center,
                            height: Dimensions.height20 * 5,
                            width: Dimensions.width20 * 5,
                            padding: EdgeInsets.all(Dimensions.height20),
                            decoration: BoxDecoration(
                              color:
                              isDark
                                  ? Colors.white.withOpacity(0.05)
                                  : Colors.white70,
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius15,
                              ),
                              border: Border.all(
                                color:
                                isDark
                                    ? Colors.white.withOpacity(0.2)
                                    : Colors.black.withOpacity(0.2),
                              ),
                            ),
                            child: Image.asset(
                              color: textColor,
                              AppConstants.getPngAsset('app'),
                            ),
                          ),
                          SizedBox(height: Dimensions.height5),
                          Text(
                            'More',
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: TextStyle(color: textColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              // Section title
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Featured Service Providers',
                      style: TextStyle(color: textColor),
                    ),
                    Text('See all', style: TextStyle(color: textColor)),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

              AdsCarousel(),
            ],
          ),
        ),
      ],
    );
  }
}
