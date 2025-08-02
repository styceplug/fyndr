import 'package:flutter/material.dart';

import '../../../data/services/profile_data.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_button.dart';
import '../../../widgets/custom_textfield.dart';
import '../../auth/user/user_complete_auth.dart';

class MerchantUpdateDetails extends StatefulWidget {
  @override
  State<MerchantUpdateDetails> createState() => _MerchantUpdateDetailsState();
}

class _MerchantUpdateDetailsState extends State<MerchantUpdateDetails> {
  final TextEditingController addressController = TextEditingController();
  final TextEditingController locationController = TextEditingController();



  final List<String> selectedServices = [];

  final services = merchantServicesMap.entries.toList();

  @override
  void initState() {
    super.initState();

    final merchant = authController.currentMerchant.value;
    if (merchant != null) {
      selectedServices.addAll(merchant.servicesOffered ?? []);
      addressController.text = merchant.businessAddress ?? '';
      locationController.text = merchant.businessLocation ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black87;
    final fadedText = textColor.withOpacity(0.7);
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(
        title: "Business Info",
        centerTitle: true,
      ),
      body: Padding(
        padding: EdgeInsets.all(Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Services Offered",
              style: TextStyle(
                fontSize: Dimensions.font16,
                fontWeight: FontWeight.w600,
                color: textColor,
              ),
            ),
            SizedBox(height: Dimensions.height10),
            Wrap(
              spacing: 10,
              children: services.map((e) {
                final selected = selectedServices.contains(e.value);
                return FilterChip(
                  label: Text(
                    e.key,
                    style: TextStyle(
                      color: selected ? Colors.white : fadedText,
                    ),
                  ),
                  selected: selected,
                  selectedColor: theme.colorScheme.primary,
                  backgroundColor: cardColor,
                  onSelected: (_) {
                    setState(() {
                      selected
                          ? selectedServices.remove(e.value)
                          : selectedServices.add(e.value);
                    });
                  },
                );
              }).toList(),
            ),
            SizedBox(height: Dimensions.height20),
            CustomTextField(
              controller: addressController,
              hintText: 'Business Address',
            ),
            /*SizedBox(height: Dimensions.height20),
          CustomTextField(
            controller: locationController,
            hintText: 'Business Location',
          ),*/
            SizedBox(height: Dimensions.height30),
            CustomButton(
              text: "Update Business Info",
              onPressed: () async {
                await authController.updateBusinessDetails(
                  services: selectedServices,
                  address: addressController.text.trim(),
                  location: locationController.text.trim(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
