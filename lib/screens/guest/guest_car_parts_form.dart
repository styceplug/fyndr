import 'dart:io';
import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:fyndr/widgets/dropdown_textfield.dart';
import '../../widgets/ads_card.dart';
import 'package:fyndr/widgets/price_range_input.dart';
import 'package:get/get.dart';
import '../../data/services/car_data.dart';
import '../../data/services/states_lga_local.dart';
import '../../routes/routes.dart';
import '../../widgets/attach_media_btn.dart';
import '../../widgets/snackbars.dart';

class GuestCarPartsForm extends StatefulWidget {
  const GuestCarPartsForm({super.key});

  @override
  State<GuestCarPartsForm> createState() => _GuestCarPartsFormState();
}

class _GuestCarPartsFormState extends State<GuestCarPartsForm> {
  String? selectedState;
  String? selectedMake;
  String? selectedModel;
  String? selectedYear;
  bool acceptTerms = false;
  File? selectedImage;

  final TextEditingController currentLocationController =
      TextEditingController();
  final TextEditingController sourcingLocationController =
      TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  final TextEditingController titleController = TextEditingController();

  final RequestController requestController = Get.find<RequestController>();

  void policy() {
    setState(() {
      acceptTerms = !acceptTerms;
    });
  }

  bool get isFormValid {
    return selectedState != null &&
        selectedMake != null &&
        selectedModel != null &&
        selectedYear != null &&
        currentLocationController.text.trim().isNotEmpty &&
        sourcingLocationController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        titleController.text.trim().isNotEmpty &&
        selectedImage != null &&
        acceptTerms;
  }

  void onItemTapped() {
    showDialog(
      context: context,
      barrierDismissible: false, // optional: prevent accidental dismiss
      builder:
          (context) => Dialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            backgroundColor: Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20.0,
                vertical: 24.0,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.lock_outline, size: 48, color: Colors.orange),
                  const SizedBox(height: 16),
                  Text(
                    'Create an Account',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'You need an account to access this feature. Sign up now to continue.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.grey[700],
                            side: BorderSide(color: Colors.grey.shade300),
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            Get.offAllNamed(AppRoutes.onboardingScreen);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: Text('Sign Up'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Post a Car Parts Request',
        centerTitle: true,
        leadingIcon: BackButton(color: Theme.of(context).dividerColor),
        subtitle: 'Find quality parts from verified sellers.',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsCarousel(),
            SizedBox(height: Dimensions.height20),

            // Title
            CustomTextField(
              controller: titleController,
              hintText: 'E.g. Brake Disc for Toyota Camry',
              labelText: 'Common name of part needed',
            ),
            SizedBox(height: Dimensions.height20),

            DropdownTextField<String>(
              label: 'Select State',
              items: stateLgaMap.keys.toList(),
              selectedItem: selectedState,
              onChanged: (value) => setState(() => selectedState = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            CustomTextField(
              controller: currentLocationController,
              hintText: 'E.g. Ikorodu Lagos',
              labelText: 'Current Location',
            ),
            SizedBox(height: Dimensions.height20),

            CustomTextField(
              controller: sourcingLocationController,
              hintText: 'E.g. Ladipo Market',
              labelText: 'Sourcing Location',
            ),
            SizedBox(height: Dimensions.height20),

            // Car details
            DropdownTextField<String>(
              label: 'Make',
              hintText: 'Make',
              items: carMakes,
              selectedItem: selectedMake,
              onChanged:
                  (value) => setState(() {
                    selectedMake = value;
                    selectedModel = null;
                  }),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),
            DropdownTextField<String>(
              label: 'Model',
              hintText: 'Model',
              items: selectedMake != null ? carModels[selectedMake!] ?? [] : [],
              selectedItem: selectedModel,
              onChanged: (value) => setState(() => selectedModel = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),
            DropdownTextField<String>(
              label: 'Year',
              hintText: 'Year',
              items: carYears,
              selectedItem: selectedYear,
              onChanged: (value) => setState(() => selectedYear = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            CustomTextField(
              controller: descriptionController,
              hintText: 'Describe part needed (e.g. ABS sensor, front left)',
              maxLines: 5,
              labelText: 'Part Description',
            ),
            SizedBox(height: Dimensions.height20),

            MediaAttachmentWidget(
              onImageSelected: (file) => setState(() => selectedImage = file),
            ),
            SizedBox(height: Dimensions.height20),

            InkWell(
              onTap: policy,
              child: Row(
                children: [
                  Icon(
                    acceptTerms
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                  ),
                  SizedBox(width: Dimensions.width5),
                  Expanded(
                    child: Text(
                      'A ₦499 fee is required to post this request. Accept the policy to proceed.',
                      style: TextStyle(
                        fontSize: 10,
                        color: textColor?.withOpacity(0.8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height30),

            CustomButton(
              isDisabled: !isFormValid,
              text: 'Submit Request',
              onPressed: () {
                onItemTapped();
              },
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}
