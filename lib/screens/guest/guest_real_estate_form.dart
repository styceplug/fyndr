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
import '../../routes/routes.dart';
import '../../widgets/lga_multi-select.dart';
import '../../widgets/snackbars.dart';

class GuestRealEstateForm extends StatefulWidget {
  const GuestRealEstateForm({super.key});

  @override
  State<GuestRealEstateForm> createState() => _GuestRealEstateFormState();
}

class _GuestRealEstateFormState extends State<GuestRealEstateForm> {
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
              onPressed: onItemTapped,
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),
    );
  }
}