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
import '../../routes/routes.dart';
import '../../widgets/snackbars.dart';

class GuestCleaningForm extends StatefulWidget {
  const GuestCleaningForm({super.key});

  @override
  State<GuestCleaningForm> createState() => _GuestCleaningFormState();
}

class _GuestCleaningFormState extends State<GuestCleaningForm> {
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


  void onItemTapped() {
    showDialog(
      context: context,
      barrierDismissible: false,
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar:  CustomAppbar(
        title: 'Post a Cleaning Request',
        centerTitle: true,
        leadingIcon: BackButton(color: Theme.of(context).dividerColor),
        subtitle: 'Get professional cleaning in your area.',
      ),
      body: SingleChildScrollView(
        padding:  EdgeInsets.all(20),
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

            /// Submit Button
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