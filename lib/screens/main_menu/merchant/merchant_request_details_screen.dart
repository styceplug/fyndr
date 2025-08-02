import 'package:flutter/material.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../controllers/request_controller.dart';

import '../../../utils/colors.dart';
import '../../../utils/dimensions.dart';
import '../../../widgets/custom_appbar.dart';
import '../../../widgets/custom_textfield.dart';
import '../../../widgets/snackbars.dart';

class MerchantRequestDetailsScreen extends StatefulWidget {
  const MerchantRequestDetailsScreen({super.key}); // Remove required requestId

  @override
  State<MerchantRequestDetailsScreen> createState() =>
      _MerchantRequestDetailsScreenState();
}

class _MerchantRequestDetailsScreenState
    extends State<MerchantRequestDetailsScreen> {
  final requestController = Get.find<RequestController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // Get requestId from arguments
      final requestId = Get.arguments as String?;
      if (requestId != null) {
        requestController.fetchSingleMerchantRequest(requestId);
      }
    });
  }

  String _capitalizeText(String input) {
    return input
        .split(' ')
        .map((word) =>
    word.isNotEmpty ? word[0].toUpperCase() + word.substring(1).toLowerCase() : '')
        .join(' ');
  }

  Widget _buildSection(BuildContext context, String title, String content) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
        ),
        SizedBox(height: Dimensions.height5),
        Text(
          _capitalizeText(content),
          style: theme.textTheme.bodyMedium,
        ),
        SizedBox(height: Dimensions.height15),
      ],
    );
  }

  void showBottomModal(BuildContext context) {
    final theme = Theme.of(context);
    final TextEditingController proposalController = TextEditingController();

    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      isScrollControlled: true,
      backgroundColor: theme.dialogBackgroundColor,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Send Proposal',
                style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              CustomTextField(
                controller: proposalController,
                hintText: 'Your Message',
                maxLines: 4,
              ),
              SizedBox(height: 20),
              CustomButton(
                text: 'Send Proposal',
                onPressed: () async {
                  final proposal = proposalController.text.trim();
                  if (proposal.isEmpty) {
                    MySnackBars.failure(
                      title: 'Missing Fields',
                      message: 'Please fill out empty fields.',
                    );
                    return;
                  }
                  await requestController.sendProposal(
                    requestId: requestController.selectedMerchantRequest.value?.id ?? '',
                    proposal: proposal,
                  );
                  Get.back();
                  MySnackBars.success(
                    title: 'Sent',
                    message: 'Your proposal has been sent!',
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppbar(
        title: "Request Details",
        centerTitle: true,

        leadingIcon: InkWell(
          onTap: () {
            Get.back();
          },
          child: Icon(Icons.chevron_left),
        ),
      ),
      body: Obx(() {
        final request = requestController.selectedMerchantRequest.value;

        return SingleChildScrollView(
          padding: EdgeInsets.all(Dimensions.height20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                request?.title ?? 'Request Title',
                style: TextStyle(
                  fontSize: Dimensions.font20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: Dimensions.height10),

              Text(
                request?.category?.toUpperCase() ?? 'Request Category',
                style: TextStyle(
                  fontSize: Dimensions.font16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.primary,
                ),
              ),
              SizedBox(height: Dimensions.height20),

              _buildSection(context, 'Request ID', request?.id ?? '0000000000'),
              _buildSection(context,
                'Request Status',
                request?.requestStatus ?? 'Processing...',
              ),
              _buildSection(
                context,
                'Created At',
                request?.createdAt != null
                    ? DateFormat(
                      'EEEE, dd MMMM yyyy • h:mm a',
                    ).format(request!.createdAt!.toLocal())
                    : '01/01/2000',
              ),
              _buildSection(
                context,
                'Target State',
                request?.targetState ?? 'Processing...',
              ),
              _buildSection(
                context,
                'Target Axis',
                request?.targetAxis?.join(', ') ?? 'Loading...',
              ),
              _buildSection(
                context,
                'Details',
                request?.additionalDetails ?? 'No additional details',
              ),

              SizedBox(height: Dimensions.height20),

              /// Payment Info
              Text(
                "🔐 Payment Info",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: Dimensions.font16,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              _buildSection(
                context,
                'Transaction Status',
                request?.transactionStatus ?? 'N/A',
              ),
              _buildSection(
                context,
                'Transaction Reference',
                request?.transactionReference ?? 'N/A',
              ),
              _buildSection(context,'Payment Method', request?.paymentMethod ?? 'N/A'),

              // _buildSection('Payment Attempts', request?.paymentAttempt ?? '0'),
              if (request?.acceptedMerchant != null) ...[
                SizedBox(height: Dimensions.height20),
                Text(
                  "🤝 Merchant Info",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16,
                  ),
                ),
                _buildSection(
                  context,
                  'Accepted Merchant ID',
                  request!.acceptedMerchant!,
                ),
              ],

              SizedBox(height: Dimensions.height20),
              Divider(),
              SizedBox(height: Dimensions.height20),

              /// Category-Specific Info
              if (request?.cleaning != null) ...[
                Text(
                  "🧼 Cleaning Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16,
                  ),
                ),
                _buildSection(
                  context,
                  'Cleaning Type',
                  request?.cleaning!.cleaningType ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Property Type',
                  request?.cleaning!.propertyType ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Property Location',
                  request?.cleaning!.propertyLocation ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Room Number',
                  '${request?.cleaning!.roomNumber ?? '-'}',
                ),
              ],

              if (request?.realEstate != null) ...[
                Text(
                  "🏠 Real Estate Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16,
                  ),
                ),
                _buildSection(context,'Rent Type', request?.realEstate!.type ?? 'N/A'),
                _buildSection(
                  context,
                  'Property Type',
                  request?.realEstate!.propertyType ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Room Count',
                  request?.realEstate!.roomCount ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Condition',
                  request?.realEstate!.propertyCondition ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Price Range',
                  '₦${request?.realEstate!.lowerPriceLimit?.toStringAsFixed(0) ?? '0'} - ₦${request?.realEstate!.upperPriceLimit?.toStringAsFixed(0) ?? '0'}',
                ),
              ],

              if (request?.carHire != null) ...[
                Text(
                  "🚗 Car Hire Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16,
                  ),
                ),
                _buildSection(context,'Car Type', request?.carHire!.carType ?? 'N/A'),
                _buildSection(
                  context,
                  'Duration (days)',
                  '${request?.carHire!.hireDuration ?? 0}',
                ),
                _buildSection(
                  context,
                  'Driving Area',
                  request?.carHire!.targetDrivingArea ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Pickup Location',
                  request?.carHire!.pickupLocation ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Airport Pickup',
                  request?.carHire!.airportPickup == true ? 'Yes' : 'No',
                ),
                _buildSection(
                  context,
                  'Travel',
                  request?.carHire!.travel == true ? 'Yes' : 'No',
                ),
              ],

              if (request?.carPart != null) ...[
                Text(
                  "🧩 Car Part Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16,
                  ),
                ),
                Container(
                  height: Dimensions.height20 * 5,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(request?.carPart?.image ?? ''),
                    ),
                  ),
                ),
                _buildSection(context,'Make', request?.carPart!.carMake ?? 'N/A'),
                _buildSection(context,'Model', request?.carPart!.carModel ?? 'N/A'),
                _buildSection(context,'Year', '${request?.carPart!.carYear ?? 'N/A'}'),
                _buildSection(
                  context,
                  'Current Location',
                  request?.carPart!.currentLocation ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Part Description',
                  request?.carPart!.partDescription ?? 'N/A',
                ),
              ],

              if (request?.automobile != null) ...[
                Text(
                  "🚘 Automobile Details",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: Dimensions.font16,
                  ),
                ),
                _buildSection(
                  context,
                  'Car Make',
                  request?.automobile!.carMake ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Car Model',
                  request?.automobile!.carModel ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Year Range',
                  '${request?.automobile!.carYearFrom} - ${request?.automobile!.carYearTo}',
                ),
                _buildSection(
                  context,
                  'Transmission',
                  request?.automobile!.transmission ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Location',
                  request?.automobile!.location ?? 'N/A',
                ),
                _buildSection(
                  context,
                  'Budget',
                  '₦${request?.automobile!.lowerPriceLimit?.toStringAsFixed(0)} - ₦${request?.automobile!.upperPriceLimit?.toStringAsFixed(0)}',
                ),
              ],

              SizedBox(height: Dimensions.height20),

              CustomButton(
                text: 'Send a Proposal',
                onPressed: () {
                  showBottomModal(context);
                },
                // isDisabled: request?.requestStatus == 'submitted',
              ),

              SizedBox(height: Dimensions.height70),
            ],
          ),
        );
      }),
    );
  }
}
