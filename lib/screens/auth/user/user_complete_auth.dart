import 'package:flutter/material.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/controllers/notification_controller.dart';
import 'package:fyndr/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:fyndr/widgets/state_lga_dropdown.dart';

class UserCompleteAuth extends StatefulWidget {
  const UserCompleteAuth({super.key});

  @override
  State<UserCompleteAuth> createState() => _UserCompleteAuthState();
}

TextEditingController fullNameController = TextEditingController();
TextEditingController emailController = TextEditingController();
TextEditingController addressController = TextEditingController();

AuthController authController = Get.find<AuthController>();
NotificationController notificationController = Get.find<NotificationController>();

void createAccount() {
  final name = fullNameController.text.trim();
  final email = emailController.text.trim();
  final state = authController.selectedState ?? '';
  final lga = authController.selectedLga ?? '';
  final address = addressController.text.trim();

  if (name.isEmpty ||
      email.isEmpty ||
      state.isEmpty ||
      lga.isEmpty ||
      address.isEmpty) {
    MySnackBars.failure(
      message: 'Please fill all fields',
      title: 'Missing Info',
    );
    return;
  }

  authController.completeUserProfile(
    name: name,
    email: email,
    state: state,
    lga: lga,
    location: address,
  );
}

class _UserCompleteAuthState extends State<UserCompleteAuth> {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(
          horizontal: Dimensions.width20,
          vertical: Dimensions.height20,
        ),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height50 * 2.5),

            Text(
              'Complete Authentication',
              style: TextStyle(
                fontSize: Dimensions.font26,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: Dimensions.height15),

            Text(
              'Fill Required Information',
              style: TextStyle(
                fontSize: Dimensions.font17,
                fontWeight: FontWeight.w400,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: Dimensions.height15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Input Full Name",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                CustomTextField(
                  hintText: 'Enter your Name',
                  controller: fullNameController,
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Input Email Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                CustomTextField(
                  hintText: 'Enter your Email Address',
                  controller: emailController,
                ),
              ],
            ),
            SizedBox(height: Dimensions.height15),

            StateLgaDropdown(
              selectedState: authController.selectedState,
              selectedLga: authController.selectedLga,
              onStateChanged: (val) => setState(() {
                authController.selectedState = val;
              }),
              onLgaChanged: (val) => setState(() {
                authController.selectedLga = val;
              }),
            ),
            SizedBox(height: Dimensions.height15),

            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Enter Address",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: theme.textTheme.bodyLarge?.color,
                  ),
                ),
                SizedBox(height: Dimensions.height5),
                CustomTextField(
                  hintText: 'Enter Address',
                  controller: addressController,
                ),
              ],
            ),

            const Spacer(),

            CustomButton(
              text: 'Submit Details',
              onPressed: () {
                createAccount();
              },
            ),

            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}
