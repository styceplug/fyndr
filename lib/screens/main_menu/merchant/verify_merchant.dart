import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:fyndr/models/merchant_model.dart';

import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/snackbars.dart';
import '../../auth/user/user_complete_auth.dart';

class VerifyMerchantScreen extends StatefulWidget {
  @override
  State<VerifyMerchantScreen> createState() => _VerifyMerchantScreenState();
}

class _VerifyMerchantScreenState extends State<VerifyMerchantScreen> {
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController middleName = TextEditingController();
  final TextEditingController cacNumber = TextEditingController();
  final TextEditingController ninNumber = TextEditingController();

  late MerchantModel merchantModel;

  File? selectedPdf;

  Future<void> pickPdf() async {
    final result = await FilePicker.platform.pickFiles(type: FileType.custom, allowedExtensions: ['pdf']);
    if (result != null && result.files.single.path != null) {
      setState(() {
        selectedPdf = File(result.files.single.path!);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = theme.scaffoldBackgroundColor;
    final cardColor = theme.cardColor;
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final fadedText = textColor.withOpacity(0.7);

    return Scaffold(
      backgroundColor: bgColor,
      appBar: CustomAppbar(
        title: "Verify Business",
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CustomTextField(
                controller: firstName,
                hintText: "First Name",
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                controller: middleName,
                hintText: "Middle Name (optional)",
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                controller: lastName,
                hintText: "Last Name",
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                controller: cacNumber,
                hintText: "CAC Number",
              ),
              SizedBox(height: Dimensions.height10),
              CustomTextField(
                controller: ninNumber,
                hintText: "NIN Number",
              ),
              SizedBox(height: Dimensions.height20),

              // PDF Upload Button
              InkWell(
                onTap: pickPdf,
                borderRadius: BorderRadius.circular(Dimensions.radius10),
                child: Container(
                  padding: EdgeInsets.all(Dimensions.height15),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                    color: cardColor,
                  ),
                  child: Row(
                    children: [
                      Icon(Icons.picture_as_pdf, color: Colors.red),
                      SizedBox(width: 10),
                      Text(
                        selectedPdf != null
                            ? 'PDF selected'
                            : 'Upload Business Document',
                        style: TextStyle(
                          color: fadedText,
                          fontSize: Dimensions.font14,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              SizedBox(height: Dimensions.height30),
              CustomButton(
                text: "Submit Verification",
                onPressed: () async {
                  if (selectedPdf == null) {
                    MySnackBars.failure(
                      title: "Missing File",
                      message: "Please upload a business document.",
                    );
                    return;
                  }

                  final success = await authController.verifyBusiness(
                    pdfFile: selectedPdf!,
                    firstName: firstName.text.trim(),
                    lastName: lastName.text.trim(),
                    middleName: middleName.text.trim(),
                    cacNumber: cacNumber.text.trim(),
                    ninNumber: ninNumber.text.trim(),
                  );

                  if (success) {
                    // ✅ Clear input fields and PDF selection
                    firstName.clear();
                    lastName.clear();
                    middleName.clear();
                    cacNumber.clear();
                    ninNumber.clear();
                    setState(() {
                      selectedPdf = null;
                    });

                    MySnackBars.success(
                      title: "Submitted",
                      message:
                      "Your business verification has been submitted successfully.",
                    );
                  }
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
