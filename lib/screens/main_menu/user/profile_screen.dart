import 'package:flutter/material.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/profile_avatar.dart';
import 'package:get/get.dart';

import '../../../widgets/snackbars.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  AuthController authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    if (authController.currentUser == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authController.loadUserProfile();
        setState(() {});
      });
    }
  }

  void logOut() {
    authController.logout();
  }

  Widget showDeleteAccountDialog(
    BuildContext context,
    String fullName,
    AuthController authController,
  ) {
    final TextEditingController nameController = TextEditingController();

    return AlertDialog(
      title: const Text("Confirm Deletion"),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text("Type your full name to confirm account deletion:"),
          const SizedBox(height: 10),
          TextField(
            controller: nameController,
            decoration: const InputDecoration(hintText: "Full Name"),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () {
            if (nameController.text.trim() == fullName.trim()) {
              Navigator.pop(context);
              authController.deleteAccount(fullName);
            } else {
              MySnackBars.failure(
                title: "Error",
                message: "Name does not match.",
              );
            }
          },
          child: const Text("Delete", style: TextStyle(color: Colors.red)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final currentUser = authController.currentUser;
    final avatarUrl = currentUser.value?.avatar;
    final fadedColor = textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Profile',
        centerTitle: true,
      ),
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        width: Dimensions.screenWidth,
        height: Dimensions.screenHeight,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileAvatar(avatarUrl: avatarUrl),
            SizedBox(height: Dimensions.height20),

            // Username
            Text(
              currentUser.value?.name ?? '',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
                fontSize: Dimensions.font18,
              ),
            ),
            SizedBox(height: Dimensions.height5),

            // Member since
            Text(
              'Member since ${currentUser.value?.createdAt?.year ?? ''}',
              style: textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.w400,
                color: fadedColor,
              ),
            ),
            SizedBox(height: Dimensions.height30),

            // Section header
            SizedBox(
              width: Dimensions.screenWidth,
              child: Text(
                'Account Settings',
                textAlign: TextAlign.left,
                style: textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w600,
                  fontSize: Dimensions.font16,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height20),

            // Delete account
            _settingsTile(
              title: 'Delete Account',
              onTap: () {
                final fullName = currentUser.value?.name ?? '';
                Get.dialog(showDeleteAccountDialog(context, fullName, authController));
              },
            ),

            // Privacy Policy
            _settingsTile(
              title: 'Privacy Policy',
              onTap: () {
                // Open Privacy Policy
              },
            ),

            // Terms and Conditions
            _settingsTile(
              title: 'Terms and Conditions',
              onTap: () {
                // Open T&Cs
              },
            ),

            SizedBox(height: Dimensions.height30),

            // Logout button
            CustomButton(
              text: 'Log Out',
              onPressed: logOut,
            ),
          ],
        ),
      ),
    );
  }


  Widget _settingsTile({required String title, required VoidCallback onTap}) {
    final theme = Theme.of(Get.context!);
    final iconColor = theme.iconTheme.color;
    final textColor = theme.textTheme.bodyLarge?.color;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Dimensions.radius10),
      child: SizedBox(
        height: Dimensions.height70,
        width: Dimensions.screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(color: textColor),
            ),
            Icon(Icons.chevron_right, color: iconColor),
          ],
        ),
      ),
    );
  }
}
