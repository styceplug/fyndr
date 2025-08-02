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
      final phone = phoneController.text.trim();
      final isValid = phone.length == 10 && RegExp(r'^[0-9]+$').hasMatch(phone);
      if (isValid != isButtonEnabled) {
        setState(() => isButtonEnabled = isValid);
      }
    });
  }

  void requestOtp() {
    final phoneNumber = '+234${phoneController.text.trim()}';
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
              'Input WhatsApp active number, we will send a code via WhatsApp',
              style: TextStyle(
                fontSize: Dimensions.font17,
                fontWeight: FontWeight.w400,
                color: theme.textTheme.bodyMedium?.color,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: Dimensions.height30),

            Row(
              children: [
                Container(
                  width: Dimensions.width50,
                  child: Text(
                    '+234',
                    style: TextStyle(
                      fontSize: Dimensions.font17,
                      color: theme.textTheme.bodyLarge?.color,
                    ),
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: CustomTextField(
                    keyboardType: TextInputType.number,
                    controller: phoneController,
                    hintText: 'Enter your phone number',
                  ),
                ),
              ],
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
