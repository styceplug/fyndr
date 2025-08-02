import 'package:flutter/material.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/dropdown_textfield.dart';
import '../../widgets/ads_card.dart';
import 'package:fyndr/data/services/cleaning_options.dart';
import 'package:get/get.dart';

import '../../controllers/request_controller.dart';
import '../../data/services/states_lga_local.dart';
import '../../widgets/snackbars.dart';

class CleaningForm extends StatefulWidget {
  const CleaningForm({super.key});

  @override
  State<CleaningForm> createState() => _CleaningFormState();
}

class _CleaningFormState extends State<CleaningForm> {
  String? selectedState;
  String? selectedLga;
  String? selectedPropertyType;
  String? selectedRoomCount;
  String? selectedCleaningMode;

  TextEditingController addressController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  final RequestController requestController = Get.find<RequestController>();

  bool acceptTerms = false;

  bool get isFormValid {
    return selectedState != null &&
        selectedLga != null &&
        selectedPropertyType != null &&
        selectedRoomCount != null &&
        selectedCleaningMode != null &&
        addressController.text.trim().isNotEmpty &&
        detailsController.text.trim().isNotEmpty &&
        acceptTerms;
  }


  void policy(){
    setState(() {
      acceptTerms = !acceptTerms;
    });
  }

  void postRequest() async {
    if (!isFormValid) {
      MySnackBars.failure(
        title: "Incomplete",
        message: "Please complete all fields and accept the policy.",
      );
      return;
    }

    final cleaningType = cleaningModes[selectedCleaningMode];

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

              final body = {
                "title": "${selectedPropertyType} Cleaning Request",
                "state": selectedState,
                "lga": selectedLga,
                "propertyLocation": addressController.text.trim(),
                "propertyType": selectedPropertyType,
                "roomNumber": selectedRoomCount,
                "cleaningType": cleaningType,
                "details": detailsController.text.trim(),
              };

              await requestController.createCleaningRequest(body, onSuccess: () {
                setState(() {
                  selectedState = null;
                  selectedLga = null;
                  selectedPropertyType = null;
                  selectedRoomCount = null;
                  selectedCleaningMode = null;
                  acceptTerms = false;
                  addressController.clear();
                  detailsController.clear();
                });
              });
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:  CustomAppbar(
        title: 'Post a Cleaning Request',
        centerTitle: true,
        leadingIcon: BackButton(color: Theme.of(context).dividerColor),
        subtitle: 'Get professional cleaning in your area.',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            AdsCarousel(),
            SizedBox(height: Dimensions.height20),

            /// State & LGA
            Column(
              children: [
                DropdownTextField<String>(
                  label: 'Select State',
                  items: stateLgaMap.keys.toList(),
                  selectedItem: selectedState,
                  onChanged: (value) {
                    setState(() {
                      selectedState = value;
                      selectedLga = null;
                    });
                  },
                  itemToString: (val) => val,
                ),
                SizedBox(height: Dimensions.height20),
                DropdownTextField<String>(
                  label: 'Select LGA',
                  items: selectedState != null
                      ? stateLgaMap[selectedState!] ?? []
                      : [],
                  selectedItem: selectedLga,
                  onChanged: (value) => setState(() => selectedLga = value),
                  itemToString: (val) => val,
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            /// Address
            CustomTextField(
              controller: addressController,
              hintText: 'Input Location',
              labelText: 'Address',
            ),
            SizedBox(height: Dimensions.height20),

            /// Property Type
            DropdownTextField<String>(
              label: 'Property Type',
              items: cleaningPropertyTypes,
              selectedItem: selectedPropertyType,
              onChanged: (value) => setState(() => selectedPropertyType = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            /// Number of Rooms
            DropdownTextField<String>(
              label: 'Number of Rooms',
              items: cleaningRoomCounts,
              selectedItem: selectedRoomCount,
              onChanged: (value) => setState(() => selectedRoomCount = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            /// Cleaning Mode
            DropdownTextField<String>(
              label: 'Cleaning Mode',
              items: cleaningModes.keys.toList(),
              selectedItem: selectedCleaningMode,
              onChanged: (value) => setState(() => selectedCleaningMode = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            /// Additional Details
            CustomTextField(
              controller: detailsController,
              hintText: 'Additional Details',
              maxLines: 5,
            ),
            SizedBox(height: Dimensions.height30),

            /// Accept policy
            InkWell(
              onTap: policy,
              child: Row(
                children: [
                  Icon(
                    acceptTerms
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    color: isDark ? Colors.white70 : Colors.black87,
                  ),
                  SizedBox(width: Dimensions.width5),
                  Expanded(
                    child: Text(
                      'As per our policy a payment of N499 is required to post a request on Fyndr, accept to proceed',
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

            /// Submit Button
            CustomButton(
              isDisabled: !isFormValid,
              text: 'Submit Request',
              onPressed: isFormValid ? postRequest : () {},
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}