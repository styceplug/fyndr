import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyndr/controllers/auth_controller.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:iconsax/iconsax.dart';

class VerifyOtp extends StatefulWidget {
  const VerifyOtp({super.key});

  @override
  State<VerifyOtp> createState() => _VerifyOtpState();
}

class _VerifyOtpState extends State<VerifyOtp> {
  final AuthController authController = Get.find<AuthController>();

  final TextEditingController firstOtp = TextEditingController();
  final TextEditingController secondOtp = TextEditingController();
  final TextEditingController thirdOtp = TextEditingController();
  final TextEditingController fourthOtp = TextEditingController();

  final FocusNode firstFocus = FocusNode();
  final FocusNode secondFocus = FocusNode();
  final FocusNode thirdFocus = FocusNode();
  final FocusNode fourthFocus = FocusNode();

  bool isButtonEnabled = false;

  void checkIfAllFilled() {
    setState(() {
      isButtonEnabled =
          firstOtp.text.isNotEmpty &&
          secondOtp.text.isNotEmpty &&
          thirdOtp.text.isNotEmpty &&
          fourthOtp.text.isNotEmpty;
    });
  }

  Future<void> verifyOtp() async {
    final otpCode =
        firstOtp.text.trim() +
        secondOtp.text.trim() +
        thirdOtp.text.trim() +
        fourthOtp.text.trim();

    if (otpCode.length == 4) {
      await authController.verifyUserOtp(otp: otpCode);
    }
  }

  void resendOtp(){
    authController.resendUserOtp();
  }

  @override
  void dispose() {
    firstOtp.dispose();
    secondOtp.dispose();
    thirdOtp.dispose();
    fourthOtp.dispose();

    firstFocus.dispose();
    secondFocus.dispose();
    thirdFocus.dispose();
    fourthFocus.dispose();

    super.dispose();
  }

  Widget otpBox(
      BuildContext context,
      TextEditingController controller,
      FocusNode focusNode,
      FocusNode? nextFocus,
      ) {
    final theme = Theme.of(context);

    return SizedBox(
      width: Dimensions.width50,
      height: Dimensions.height50,
      child: TextField(
        controller: controller,
        focusNode: focusNode,
        maxLength: 1,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: Dimensions.font20,
          fontWeight: FontWeight.bold,
          color: theme.textTheme.bodyLarge?.color,
        ),
        decoration: InputDecoration(
          counterText: '',
          filled: true,
          fillColor: theme.inputDecorationTheme.fillColor ??
              (theme.brightness == Brightness.dark
                  ? Colors.grey.shade900
                  : Colors.grey.shade100),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius10),
            borderSide: BorderSide(color: theme.dividerColor),
          ),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && nextFocus != null) {
            FocusScope.of(context).requestFocus(nextFocus);
          }
          checkIfAllFilled();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          children: [
            SizedBox(height: Dimensions.height50 * 2.5),

            Text(
              'Verify OTP',
              style: TextStyle(
                fontSize: Dimensions.font26,
                fontWeight: FontWeight.w700,
                color: theme.textTheme.titleLarge?.color,
              ),
            ),
            SizedBox(height: Dimensions.height15),

            Text(
              'Input code received via WhatsApp',
              style: TextStyle(
                fontSize: Dimensions.font17,
                fontWeight: FontWeight.w400,
                color: theme.textTheme.bodyMedium?.color,
              ),
            ),
            SizedBox(height: Dimensions.height30),

            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                otpBox(context, firstOtp, firstFocus, secondFocus),
                otpBox(context, secondOtp, secondFocus, thirdFocus),
                otpBox(context, thirdOtp, thirdFocus, fourthFocus),
                otpBox(context, fourthOtp, fourthFocus, null),
              ],
            ),

            SizedBox(height: Dimensions.height50),

            InkWell(
              onTap: resendOtp,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Iconsax.refresh, size: Dimensions.iconSize16, color: theme.iconTheme.color),
                  SizedBox(width: Dimensions.width5),
                  Text(
                    'Resend OTP',
                    style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                  ),
                ],
              ),
            ),

            const Spacer(),

            CustomButton(
              text: 'Verify OTP',
              isDisabled: !isButtonEnabled,
              onPressed: verifyOtp,
            ),
            SizedBox(height: Dimensions.height50),
          ],
        ),
      ),
    );
  }
}
