import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/controllers/theme_controller.dart';
import 'package:fyndr/widgets/app_bar_avatar.dart';
import 'package:fyndr/widgets/profile_avatar.dart';
import 'package:get/get.dart';
import 'package:fyndr/data/services/home_marque.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/ads_card.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/service_card.dart';
import 'package:fyndr/widgets/snackbars.dart';
import 'package:marquee/marquee.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String combinedText = marqueTexts.join('                 ');
  final AuthController authController = Get.find<AuthController>();
  final ThemeController themeController = Get.find<ThemeController>();

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
                  height: Dimensions.height65,
                ),
                centerTitle: true,
                leadingIcon: AppBarAvatar(
                  avatarUrl: authController.currentUser.value?.avatar,
                ),

                actionIcon: Row(
                  children: [
                    InkWell(
                      onTap: () => themeController.toggleTheme(),
                      child: Obx(() {
                        final isDark =
                            themeController.themeMode.value == ThemeMode.dark;
                        return Icon(
                          isDark
                              ? CupertinoIcons.sun_max_fill
                              : CupertinoIcons.moon_fill,
                          color: isDark ? Colors.yellow : iconColor,
                        );
                      }),
                    ),

                    SizedBox(width: Dimensions.width10),
                    InkWell(
                      onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                      child: Icon(CupertinoIcons.bell_fill, color: iconColor),
                    ),
                  ],
                ),
              ),

              SizedBox(height: Dimensions.height20),

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

              SizedBox(height: Dimensions.height30),

              // First row of services
              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ServiceCard(
                      iconName: 'realEst',
                      title: 'Real Estate',
                      onTap: () => Get.toNamed(AppRoutes.realEstateForm),
                    ),
                    ServiceCard(
                      iconName: 'parts',
                      title: 'Car Parts',
                      onTap: () => Get.toNamed(AppRoutes.carPartsForm),
                    ),
                    ServiceCard(
                      iconName: 'employ',
                      title: 'Employment',
                      onTap: () => Get.toNamed(AppRoutes.employmentScreen),
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
                      onTap: () => Get.toNamed(AppRoutes.cleaningForm),
                    ),
                    ServiceCard(
                      iconName: 'autos',
                      title: 'Automobiles',
                      onTap: () => Get.toNamed(AppRoutes.automobileForm),
                    ),
                    InkWell(
                      onTap: () {
                        Get.toNamed(AppRoutes.moreServicesScreen);
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

              Padding(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
                child: AdsCarousel(),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
