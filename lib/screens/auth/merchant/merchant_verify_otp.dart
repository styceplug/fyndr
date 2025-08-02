import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:iconsax/iconsax.dart';

import '../../../controllers/auth_controller.dart';
import '../../../routes/routes.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';

class MerchantVerifyOtp extends StatefulWidget {
  const MerchantVerifyOtp({super.key});

  @override
  State<MerchantVerifyOtp> createState() => _MerchantVerifyOtpState();
}

class _MerchantVerifyOtpState extends State<MerchantVerifyOtp> {
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
      await authController.verifyMerchantOtp(otp: otpCode);
    }
  }

  void clearOtp() {
    firstOtp.clear();
    secondOtp.clear();
    thirdOtp.clear();
    fourthOtp.clear();
  }

  void resendOtp() {
    authController.resendMerchantOtp();
    clearOtp();
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
    TextEditingController controller,
    FocusNode focusNode,
    FocusNode? nextFocus,
  ) {
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
        ),
        decoration: InputDecoration(
          counterText: '',
          contentPadding: EdgeInsets.zero,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(Dimensions.radius10),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.blueAccent, width: 2),
            borderRadius: BorderRadius.circular(Dimensions.radius10),
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
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.height50),

              Text(
                'Verify OTP',
                style: TextStyle(
                  fontSize: Dimensions.font26,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: Dimensions.height10),

              Text(
                'Enter the 4-digit code sent to your WhatsApp',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  color: Colors.grey.shade600,
                ),
              ),

              SizedBox(height: Dimensions.height40),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  otpBox(firstOtp, firstFocus, secondFocus),
                  otpBox(secondOtp, secondFocus, thirdFocus),
                  otpBox(thirdOtp, thirdFocus, fourthFocus),
                  otpBox(fourthOtp, fourthFocus, null),
                ],
              ),

              SizedBox(height: Dimensions.height30),

              GestureDetector(
                onTap: resendOtp,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Iconsax.refresh,
                      size: Dimensions.iconSize16,
                      color: Colors.blue,
                    ),
                    SizedBox(width: Dimensions.width5),
                    Text(
                      'Resend OTP',
                      style: TextStyle(
                        fontSize: Dimensions.font14,
                        color: Colors.blue,
                        fontWeight: FontWeight.w500,
                      ),
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

              SizedBox(height: Dimensions.height30),
            ],
          ),
        ),
      ),
    );
  }
}
