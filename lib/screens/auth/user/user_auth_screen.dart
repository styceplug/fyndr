import 'package:flutter/material.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:get/get.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/custom_textfield.dart';

class UserAuthScreen extends StatefulWidget {
  const UserAuthScreen({super.key});

  @override
  State<UserAuthScreen> createState() => _UserAuthScreenState();
}

class _UserAuthScreenState extends State<UserAuthScreen> {
  TextEditingController phoneController = TextEditingController();
  AuthController authController = Get.find<AuthController>();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    phoneController.addListener(() {
      final input = phoneController.text.trim();

      final isPhoneValid = input.length == 11 && RegExp(r'^[0-9]+$').hasMatch(input);

      final isEmailValid = RegExp(
          r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$'
      ).hasMatch(input);

      final isValid = isPhoneValid || isEmailValid;

      if (isValid != isButtonEnabled) {
        setState(() => isButtonEnabled = isValid);
      }
    });  }

  void requestOtp() {
    final phoneNumber = phoneController.text.trim();
    authController.requestUserOtp(phoneNumber);
  }

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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: Dimensions.height50 * 2.5),

            Text(
              'Welcome to Rheel Compare',
              style: TextStyle(
                fontSize: Dimensions.font26,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: Dimensions.height10),

            Text(
              'Input active phone number or email address, we will send a code to your inbox',
              style: TextStyle(
                fontSize: Dimensions.font17,
                fontWeight: FontWeight.w400,
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimensions.height30),

            Expanded(
              child: CustomTextField(
                keyboardType: TextInputType.emailAddress,
                controller: phoneController,
                maxLines: 1,
                hintText: 'Phone number or email address',
              ),
            ),

            const Spacer(),

            CustomButton(
              isDisabled: !isButtonEnabled,
              text: 'Request OTP Code',
              onPressed: requestOtp,
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}
