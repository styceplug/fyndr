import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:fyndr/widgets/dropdown_textfield.dart';
import 'package:fyndr/widgets/custom_button.dart';
import '../../widgets/ads_card.dart';

import '../../data/services/car_data.dart';
import '../../data/services/states_lga_local.dart';
import '../../controllers/request_controller.dart';
import '../../widgets/snackbars.dart';

class CarHireForm extends StatefulWidget {
  const CarHireForm({super.key});

  @override
  State<CarHireForm> createState() => _CarHireFormState();
}

class _CarHireFormState extends State<CarHireForm> {
  final TextEditingController pickupLocationController = TextEditingController();
  final TextEditingController durationController = TextEditingController();
  final TextEditingController additionalDetailsController = TextEditingController();

  String? selectedState;
  String? selectedCarType;
  String? selectedAirport; // Should be "Yes"/"No"
  String? selectedTravel;  // Should be "Yes"/"No"

  bool acceptTerms = false;

  final RequestController requestController = Get.find<RequestController>();

  @override
  void initState() {
    super.initState();
    pickupLocationController.addListener(() => setState(() {}));
    durationController.addListener(() => setState(() {}));
    additionalDetailsController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    pickupLocationController.dispose();
    durationController.dispose();
    additionalDetailsController.dispose();
    super.dispose();
  }

  bool get isFormValid {
    return selectedState != null &&
        selectedCarType != null &&
        pickupLocationController.text.trim().isNotEmpty &&
        durationController.text.trim().isNotEmpty &&
        selectedAirport != null &&
        selectedTravel != null &&
        additionalDetailsController.text.trim().isNotEmpty &&
        acceptTerms;
  }

  void policy() {
    setState(() => acceptTerms = !acceptTerms);
  }


  void submitRequest() async {
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

              final hireDuration = int.tryParse(durationController.text.trim());
              if (hireDuration == null || hireDuration <= 0) {
                MySnackBars.failure(
                  title: "Invalid Duration",
                  message: "Please enter a valid duration in hours.",
                );
                return;
              }

              final body = {
                "title": '${selectedCarType} Hire Request',
                "state": selectedState,
                "carType": selectedCarType,
                "pickupLocation": pickupLocationController.text.trim(),
                "hireDuration": hireDuration,
                "airportPickup": selectedAirport == "Yes",
                "travel": selectedTravel == "Yes",
                "details": additionalDetailsController.text.trim(),
              };

              await requestController.createCarHireRequest(
                body,
                onSuccess: () {
                  setState(() {
                    selectedState = null;
                    selectedCarType = null;
                    selectedAirport = null;
                    selectedTravel = null;
                    acceptTerms = false;
                    pickupLocationController.clear();
                    durationController.clear();
                    additionalDetailsController.clear();
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
        customTitle: Text('Post a Car Hire Request'),
        centerTitle: true,
        leadingIcon: BackButton(color: Theme.of(context).dividerColor),
        subtitle: 'Hire vehicles for in-town or out-of-town use.',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsCarousel(),
            SizedBox(height: Dimensions.height20),

            DropdownTextField<String>(
              label: 'Select State',
              items: stateLgaMap.keys.toList(),
              selectedItem: selectedState,
              onChanged: (value) => setState(() => selectedState = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            DropdownTextField<String>(
              label: 'Type of Car',
              items: carTypes,
              selectedItem: selectedCarType,
              onChanged: (value) => setState(() => selectedCarType = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            Row(
              children: [
                Expanded(
                  child: CustomTextField(
                    controller: pickupLocationController,
                    hintText: 'Pickup Location',
                    maxLines: 1,
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: CustomTextField(
                    controller: durationController,
                    hintText: 'Duration (in hrs)',
                    keyboardType: TextInputType.number,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            Row(
              children: [
                Expanded(
                  child: DropdownTextField<String>(
                    label: 'Airport Pickup?',
                    items: ["Yes", "No"],
                    selectedItem: selectedAirport,
                    onChanged: (val) => setState(() => selectedAirport = val),
                    itemToString: (val) => val,
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                Expanded(
                  child: DropdownTextField<String>(
                    label: 'Out-of-Town Travel?',
                    items: ["Yes", "No"],
                    selectedItem: selectedTravel,
                    onChanged: (val) => setState(() => selectedTravel = val),
                    itemToString: (val) => val,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            CustomTextField(
              controller: additionalDetailsController,
              hintText: 'Additional Details',
              maxLines: 5,
            ),
            SizedBox(height: Dimensions.height30),

            InkWell(
              onTap: policy,
              child: Row(
                children: [
                  Icon(
                    acceptTerms
                        ? Icons.check_box_outlined
                        : Icons.check_box_outline_blank,
                    color: acceptTerms ? Colors.green : Colors.grey,
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

            CustomButton(
              isDisabled: !isFormValid,
              text: 'Submit Request',
              onPressed: isFormValid ? submitRequest : () {},
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}
