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
import '../../widgets/attach_media_btn.dart';
import '../../widgets/snackbars.dart';

class CarPartsForm extends StatefulWidget {
  const CarPartsForm({super.key});

  @override
  State<CarPartsForm> createState() => _CarPartsFormState();
}

class _CarPartsFormState extends State<CarPartsForm> {
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

  void postRequest() async {
    if (!isFormValid) {
      MySnackBars.failure(
        title: "Incomplete",
        message: "Please complete all fields and accept the policy.",
      );
      return;
    }

    // Show Disclaimer Dialog
    Get.dialog(
      AlertDialog(
        title: Text("Disclaimer"),
        content: SingleChildScrollView(
          child: Text(
            "Fyndr acts solely as a platform to ensure your request is delivered to your selected service providers. "
            "We are not affiliated with, nor do we endorse or partner with, any of the service providers listed on the platform. "
            "Our involvement ends once communication begins between you and the service provider. "
            "The fee paid is strictly for facilitating the delivery of your request and does not guarantee the outcome or success of any transaction.",
            style: TextStyle(fontSize: 14, height: 1.4),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(), // dismiss
            child: Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () async {
              Get.back(); // dismiss dialog first

              print("📏 Image size (bytes): ${await selectedImage!.length()}");

              final fields = {
                "title": titleController.text.trim(),
                "state": selectedState,
                "details": descriptionController.text.trim(),
                "currentLocation": currentLocationController.text.trim(),
                "sourcingLocation": sourcingLocationController.text.trim(),
                "carMake": selectedMake,
                "carModel": selectedModel,
                "carYear": (int.tryParse(selectedYear ?? '0') ?? 0).toString(),
              };

              requestController.createCarPartRequest(
                image: selectedImage!,
                fields: fields,
                onSuccess: () {
                  setState(() {
                    selectedState = null;
                    selectedMake = null;
                    selectedModel = null;
                    selectedYear = null;
                    selectedImage = null;
                    acceptTerms = false;
                    currentLocationController.clear();
                    sourcingLocationController.clear();
                    descriptionController.clear();
                    titleController.clear();
                  });
                },
              );
            },
            child: Text("I Understand"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar:  CustomAppbar(
        customTitle: Text('Post a Car Parts Request'),
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
                      style: TextStyle(fontSize: 10,
                        color: textColor?.withOpacity(0.8),),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: Dimensions.height30),

            CustomButton(
              isDisabled: !isFormValid,
              text: 'Submit Request',
              onPressed: postRequest,
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}
