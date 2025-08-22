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
import '../../routes/routes.dart';
import '../../widgets/snackbars.dart';

class GuestCarHireForm extends StatefulWidget {
  const GuestCarHireForm({super.key});

  @override
  State<GuestCarHireForm> createState() => _GuestCarHireFormState();
}

class _GuestCarHireFormState extends State<GuestCarHireForm> {
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

  void onItemTapped() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 24.0),
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


  void policy() {
    setState(() => acceptTerms = !acceptTerms);
  }



  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Scaffold(
      appBar:  CustomAppbar(
        title: 'Post a Car Hire Request',
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
                      'As per our policy a payment of N250 is required to post a request on Fyndr, accept to proceed',
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
              onPressed: isFormValid ? onItemTapped : () {},
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}
