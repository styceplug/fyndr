import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:get/get.dart';

import '../../main.dart';
import '../../routes/routes.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/profile_avatar.dart';
import '../auth/user/user_complete_auth.dart';

class EmploymentScreen extends StatefulWidget {
  const EmploymentScreen({super.key});

  @override
  State<EmploymentScreen> createState() => _EmploymentScreenState();
}

class _EmploymentScreenState extends State<EmploymentScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Scaffold(
      appBar: CustomAppbar(
        customTitle: Image.asset(
          AppConstants.getPngAsset('logo'),
          height: Dimensions.height65,
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
              child: Icon(
                themeController.isDarkMode.value
                    ? CupertinoIcons.sun_max_fill
                    : CupertinoIcons.moon_fill,
                color:
                    themeController.isDarkMode.value
                        ? Colors.yellow
                        : iconColor,
              ),
            ),
            SizedBox(width: Dimensions.width10),
            InkWell(
              onTap: () => Get.toNamed(AppRoutes.notificationScreen),
              child: Icon(CupertinoIcons.bell_fill, color: iconColor),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height20,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Container(
                height: Dimensions.height100,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage(AppConstants.getPngAsset('hiring')),
                  ),
                ),
              ),
        
              Text(
                'Post or view Job vacancies or register as a job seeker',
                textAlign: TextAlign.center,
                style: TextStyle(color: textColor, fontWeight: FontWeight.w400),
              ),
        
              SizedBox(height: Dimensions.height100),
        
              Text(
                'Are you an',
                style: TextStyle(
                  color: textColor,
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.w500,
                ),
              ),
        
              SizedBox(height: Dimensions.height30),
        
              CustomButton(text: 'Employer', onPressed: () {
                Get.toNamed(AppRoutes.employerScreen);
              }),
              SizedBox(height: Dimensions.height20),
              Text('OR', style: TextStyle(color: textColor)),
              SizedBox(height: Dimensions.height20),
              CustomButton(text: 'Job Seeker', onPressed: () {
                Get.toNamed(AppRoutes.jobSeekerScreen);

              }),
              Spacer()
            ],
          ),
        ),
      ),
    );
  }
}
