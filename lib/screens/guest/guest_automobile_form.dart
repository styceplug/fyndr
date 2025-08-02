import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/widgets/price_range_input.dart';
import 'package:get/get.dart';

import '../../data/services/car_data.dart';
import '../../data/services/states_lga_local.dart';
import '../../routes/routes.dart';
import '../../utils/dimensions.dart';
import '../../widgets/ads_card.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/dropdown_textfield.dart';
import '../../widgets/snackbars.dart';
import 'guest_car_parts_form.dart';

class GuestAutomobileForm extends StatefulWidget {
  const GuestAutomobileForm({super.key});

  @override
  State<GuestAutomobileForm> createState() => _GuestAutomobileFormState();
}

class _GuestAutomobileFormState extends State<GuestAutomobileForm> {

  String? selectedMake;
  String? selectedState;
  String? selectedModel;
  String? selectedYearFrom;
  String? selectedYearTo;
  String? selectedTransmission;
  RangeValues selectedPriceRange = const RangeValues(0, 1000000);
  TextEditingController locationController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  RequestController requestController = Get.find<RequestController>();


  bool acceptTerms = false;

  void policy(){
    setState(() {
      acceptTerms = !acceptTerms;
    });
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

  bool get isFormValid {
    return selectedState != null &&
        selectedMake != null &&
        selectedModel != null &&
        selectedYearFrom != null &&
        selectedYearTo != null &&
        selectedTransmission != null &&
        locationController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        acceptTerms;
  }


  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;


    return Scaffold(
      appBar:  CustomAppbar(
        title: 'Post an Automobile Request',
        centerTitle: true,
        leadingIcon: BackButton(color: Theme.of(context).dividerColor),
        subtitle: 'Get vehicles for sale around you.',
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AdsCarousel(),
            SizedBox(height: Dimensions.height20),

            // Current State
            DropdownTextField<String>(
              label: 'Your State',
              items: stateLgaMap.keys.toList(),
              selectedItem: selectedState,
              onChanged: (value) {
                setState(() => selectedState = value);
              },
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            //input location
            CustomTextField(hintText: 'Input Search Location',controller: locationController,maxLines: 1),
            SizedBox(height: Dimensions.height20),



            //car details
            DropdownTextField<String>(
              label: 'Make',
              hintText: 'Make',
              items: carMakes,
              selectedItem: selectedMake,
              onChanged: (value) {
                setState(() {
                  selectedMake = value;
                  selectedModel = null;
                });
              },
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20,),
            DropdownTextField<String>(
              label: 'Model',
              hintText: 'Model',
              items: selectedMake != null ? carModels[selectedMake!] ?? [] : [],
              selectedItem: selectedModel,
              onChanged: (value) => setState(() => selectedModel = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            Row(
              children: [
                Expanded(
                  child: DropdownTextField<String>(
                    label: 'Year From',
                    hintText: 'From',
                    items: carYears,
                    selectedItem: selectedYearFrom,
                    onChanged: (value) => setState(() => selectedYearFrom = value),
                    itemToString: (val) => val,
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: DropdownTextField<String>(
                    label: 'Year To',
                    hintText: 'To',
                    items: carYears,
                    selectedItem: selectedYearTo,
                    onChanged: (value) => setState(() => selectedYearTo = value),
                    itemToString: (val) => val,
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height20),

            // Transmission(automatic or manual)
            DropdownTextField<String>(
              label: 'Transmission',
              hintText: 'Select Transmission',
              items: transmissions,
              selectedItem: selectedTransmission,
              onChanged: (value) => setState(() => selectedTransmission = value),
              itemToString: (val) => val,
            ),
            SizedBox(height: Dimensions.height20),

            SizedBox(height: Dimensions.height20),

            //price slider

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

            // Additional Notes
            CustomTextField(
              hintText: 'Additional Details',
              maxLines: 5,
              controller: descriptionController,
            ),
            SizedBox(height: Dimensions.height30),


            //accept policy
            InkWell(
              onTap: policy,
              child: Row(
                children: [
                  Icon(acceptTerms? Icons.check_box_outlined : Icons.check_box_outline_blank ),
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

            // Submit
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
