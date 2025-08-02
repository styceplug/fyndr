import 'package:flutter/material.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/widgets/rating_widget.dart';
import 'package:get/get.dart';

import '../../../utils/app_constants.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/profile_avatar.dart';
import '../../../widgets/snackbars.dart';

class MerchantProfile extends StatefulWidget {
  const MerchantProfile({super.key});

  @override
  State<MerchantProfile> createState() => _MerchantProfileState();
}

class _MerchantProfileState extends State<MerchantProfile> {
  final AuthController authController = Get.find<AuthController>();
  final TextEditingController nameController = TextEditingController();

  @override
  void initState() {
    super.initState();

    if (authController.currentMerchant == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        authController.loadMerchantProfile();
      });
      setState(() {

      });
    }
  }

  void logOut() => authController.logout();

  void showDeleteAccountDialog(BuildContext context, String fullName) {
    nameController.clear();

    Get.dialog(
      AlertDialog(
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
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              if (nameController.text.trim() == fullName.trim()) {
                Get.back();
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
      ),
    );
  }

  void promoteBusinessDialog(){
    Get.dialog(
      AlertDialog(
        title: const Text("To Promote Your Business"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("We have promotional packages and plan mapped out specially for you"),
            const SizedBox(height: 10),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {},
            child:  Row(children: [
              Icon(Icons.chat),
              Text("Whatsapp", style: TextStyle(color: Colors.red))
            ],),
          ),
        ],
      ),
    );

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final currentMerchant = authController.currentMerchant;
    final avatarUrl = currentMerchant.value?.avatar;
    final fullName = currentMerchant.value?.name ?? '';

    return Scaffold(
      appBar: CustomAppbar(title: 'Profile', centerTitle: true),
      body: Container(
        width: Dimensions.screenWidth,
        height: Dimensions.screenHeight,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Avatar
              ProfileAvatar(avatarUrl: avatarUrl),
              SizedBox(height: Dimensions.height20),

              // Name + verified
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    fullName,
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(width: Dimensions.width5),
                  if (currentMerchant.value?.idVerified == true)
                    Container(
                      height: Dimensions.height10*2.5,
                      width: Dimensions.width25,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage(AppConstants.getPngAsset('verified')),
                        ),
                      ),
                    ),
                ],
              ),
              SizedBox(height: Dimensions.height5),

              // Rating
              buildRatingRow(currentMerchant.value?.rating),

              // Member since
              Text(
                'Merchant since ${currentMerchant.value?.createdAt?.year ?? ''}',
                style: theme.textTheme.bodySmall,
              ),
              SizedBox(height: Dimensions.height30),

              // Section Title
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Account Settings',
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
              SizedBox(height: Dimensions.height20),

              // Menu Items
              _buildSettingItem(
                context,
                label: 'Delete Account',
                onTap: () {
                  if (fullName.isNotEmpty) {
                    showDeleteAccountDialog(context, fullName);
                  }
                },
              ),
              _buildSettingItem(
                context,
                label: 'Verify Business',
                onTap: () => Get.toNamed(AppRoutes.verifyMerchantScreen),
              ),
              _buildSettingItem(
                context,
                label: 'Update Business Details',
                onTap: () => Get.toNamed(AppRoutes.merchantUpdateDetails),
              ),
              _buildSettingItem(
                context,
                label: 'Promote your business',
                onTap: promoteBusinessDialog,
              ),
              _buildSettingItem(
                context,
                label: 'Privacy Policy',
                onTap: () {}, // Implement
              ),
              _buildSettingItem(
                context,
                label: 'Terms and Conditions',
                onTap: () {}, // Implement
              ),

              SizedBox(height: Dimensions.height30),

              // Logout Button
              CustomButton(
                text: 'Log Out',
                onPressed: logOut,
              ),

              SizedBox(height: Dimensions.height100 * 2),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, {required String label, required VoidCallback onTap}) {
    final theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: Dimensions.height70,
        width: Dimensions.screenWidth,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: theme.textTheme.bodyLarge,
            ),
            Icon(Icons.chevron_right, color: theme.iconTheme.color),
          ],
        ),
      ),
    );
  }
}
