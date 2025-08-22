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
import '../../data/services/real_estate_options.dart';
import '../../data/services/states_lga_local.dart';
import '../../widgets/lga_multi-select.dart';
import '../../widgets/snackbars.dart';

class RealEstateForm extends StatefulWidget {
  const RealEstateForm({super.key});

  @override
  State<RealEstateForm> createState() => _RealEstateFormState();
}

class _RealEstateFormState extends State<RealEstateForm> {
  String? selectedIntent; // Rent or Buy
  String? selectedState;
  List<String> selectedLgas = [];
  String? selectedPropertyType;
  String? selectedRoomCount;
  String? selectedCondition;
  RangeValues selectedPriceRange = const RangeValues(0, 500000000);
  TextEditingController detailsController = TextEditingController();

  final RequestController requestController = Get.find<RequestController>();
  bool acceptTerms = false;

  bool get isFormValid {
    return selectedIntent != null &&
        selectedState != null &&
        selectedLgas.isNotEmpty &&
        selectedPropertyType != null &&
        selectedRoomCount != null &&
        selectedCondition != null &&
        detailsController.text.trim().isNotEmpty &&
        acceptTerms;
  }

  void togglePolicy() {
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

              if (selectedIntent == null ||
                  selectedState == null ||
                  selectedLgas.isEmpty ||
                  selectedPropertyType == null ||
                  selectedRoomCount == null ||
                  selectedCondition == null ||
                  detailsController.text.trim().isEmpty) {
                MySnackBars.failure(title: "Incomplete", message: "Please fill all required fields.");
                return;
              }

              final body = {
                "title": "$selectedIntent $selectedPropertyType Request",
                "state": selectedState,
                "axis": selectedLgas,
                "details": detailsController.text.trim(),
                "rentType": selectedIntent?.toLowerCase(),
                "propertyType": selectedPropertyType,
                "roomNumber": selectedRoomCount,
                "propertyCondition": selectedCondition?.toLowerCase(),
                "upperPriceLimit": selectedPriceRange.end.toInt(),
                "lowerPriceLimit": selectedPriceRange.start.toInt(),
              };

              print('🚀 Final Payload: $body');

              requestController.createRealEstateRequest(
                body,
                onSuccess: () {
                  // Reset all values
                  setState(() {
                    selectedIntent = null;
                    selectedState = null;
                    selectedLgas = [];
                    selectedPropertyType = null;
                    selectedRoomCount = null;
                    selectedCondition = null;
                    selectedPriceRange = const RangeValues(0, 500000000);
                    detailsController.clear();
                    acceptTerms = false;
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
      appBar: CustomAppbar(

        title: 'Post a Properties Request',
        centerTitle: true,
      leadingIcon: BackButton(color: Theme.of(context).dividerColor),
      subtitle: 'Find land, homes or rentals.',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsCarousel(),
            SizedBox(height: Dimensions.height20),

            DropdownTextField<String>(
              label: 'Rent or Buy',
              items: ['Rent', 'Buy'],
              selectedItem: selectedIntent,
              onChanged: (value) => setState(() => selectedIntent = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            DropdownTextField<String>(
              label: 'Select State',
              items: stateLgaMap.keys.toList(),
              selectedItem: selectedState,
              onChanged: (value) {
                setState(() {
                  selectedState = value;
                  selectedLgas = [];
                });
              },
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),
            if (selectedState != null)
              LgaMultiSelect(
                state: selectedState!,
                selectedLgas: selectedLgas,
                onChanged: (newList) => setState(() => selectedLgas = newList),
              ),
            SizedBox(height: Dimensions.height20),

            DropdownTextField<String>(
              label: 'Property Type',
              items: propertyTypes,
              selectedItem: selectedPropertyType,
              onChanged: (value) => setState(() => selectedPropertyType = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            DropdownTextField<String>(
              label: 'Number of Rooms',
              items: roomCounts,
              selectedItem: selectedRoomCount,
              onChanged: (value) => setState(() => selectedRoomCount = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            DropdownTextField<String>(
              label: 'Property Condition',
              items: propertyConditions,
              selectedItem: selectedCondition,
              onChanged: (value) => setState(() => selectedCondition = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            PriceRangeInput(
              min: selectedPriceRange.start.toInt(),
              max: selectedPriceRange.end.toInt(),
              onChanged: (range) {
                setState(() {
                  selectedPriceRange = range;
                });
              },
            ),
            SizedBox(height: Dimensions.height20),

            CustomTextField(
              hintText: 'Additional Description (Let the agent know preferred location and other information to help streamline)',
              maxLines: 5,
              controller: detailsController,
            ),
            SizedBox(height: Dimensions.height20),

            InkWell(
              onTap: togglePolicy,
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
                      'As per our policy a payment of N250 is required to post a request on Fyndr, accept to proceed',
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