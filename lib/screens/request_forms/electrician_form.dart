import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../controllers/request_controller.dart';

import '../../data/services/states_lga_local.dart';
import '../../utils/dimensions.dart';
import '../../widgets/ads_card.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';
import '../../widgets/dropdown_textfield.dart';

class ElectricianForm extends StatefulWidget {
  const ElectricianForm({super.key});

  @override
  State<ElectricianForm> createState() => _ElectricianFormState();
}

class _ElectricianFormState extends State<ElectricianForm> {
  String? selectedState;
  DateTime? selectedDate;
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

  bool get isFormValid {
    return selectedState != null &&

        selectedDate != null &&

        locationController.text.trim().isNotEmpty &&
        descriptionController.text.trim().isNotEmpty &&
        acceptTerms;
  }

  /* void submitRequest() async {
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

              final body = {
                "title": "${selectedMake ?? ''} ${selectedModel ?? ''} Request",
                "state": selectedState,
                "details": descriptionController.text.trim(),
                "location": locationController.text.trim(),
                "carMake": selectedMake,
                "carModel": selectedModel,
                "carYearFrom": int.tryParse(selectedYearFrom ?? '0') ?? 0,
                "carYearTo": int.tryParse(selectedYearTo ?? '0') ?? 0,
                "transmission": selectedTransmission?.toLowerCase(),
                "upperPriceLimit": selectedPriceRange.end.toInt(),
                "lowerPriceLimit": selectedPriceRange.start.toInt(),
              };

              await requestController.createAutomobileRequest(body, onSuccess: () {
                setState(() {
                  selectedState = null;
                  selectedMake = null;
                  selectedModel = null;
                  selectedYearFrom = null;
                  selectedYearTo = null;
                  selectedTransmission = null;
                  selectedPriceRange = const RangeValues(0, 1000000);
                  locationController.clear();
                  descriptionController.clear();
                  acceptTerms = false;
                });
              });
            },
            child: Text("I Understand"),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }*/

  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;


    return Scaffold(
      appBar:  CustomAppbar(
        title: 'Post an Electrician Request',
        centerTitle: true,
        leadingIcon: BackButton(color: Theme.of(context).dividerColor),
        subtitle: 'Electrician Services',
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
            CustomTextField(hintText: 'Input Target Location',controller: locationController,maxLines: 1),
            SizedBox(height: Dimensions.height20),

            //date needed
            GestureDetector(
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: selectedDate ?? DateTime.now(),
                  firstDate: DateTime.now(),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  setState(() => selectedDate = picked);
                }
              },
              child: AbsorbPointer(
                child: CustomTextField(
                  hintText: '01/12/2020',
                  labelText: 'Date Needed',
                  maxLines: 1,
                  controller: TextEditingController(
                    text: selectedDate != null
                        ? DateFormat('dd/MM/yyyy').format(selectedDate!)
                        : '',
                  ),
                ),
              ),
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
                // submitRequest();
              },
            ),
            SizedBox(height: Dimensions.height30),
          ],
        ),
      ),


    );
  }
}
