import 'package:flutter/material.dart';
import 'package:fyndr/screens/auth/user/user_complete_auth.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/empty_state_widget.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/request_controller.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/snackbars.dart';

class RequestDetailsScreen extends StatefulWidget {
  final String requestId;

  const RequestDetailsScreen({super.key, required this.requestId});

  @override
  State<RequestDetailsScreen> createState() => _RequestDetailsScreenState();
}

class _RequestDetailsScreenState extends State<RequestDetailsScreen> {
  final RequestController requestController = Get.find<RequestController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestController.fetchSingleRequest(widget.requestId);
    });
  }

  Widget _info(String label, dynamic value, TextTheme textTheme) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        '$label: ${capitalize(value?.toString() ?? 'N/A')}',
        style: textTheme.bodyMedium,
      ),
    );
  }

  void _confirmCancel(String? id) {
    if (id == null) return;
    Get.defaultDialog(
      title: 'Cancel Request',
      middleText: 'Are you sure you want to cancel this request?',
      textCancel: 'No',
      textConfirm: 'Yes',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        requestController.cancelRequest(id);
      },
    );
  }

  void _confirmComplete(String? id) {
    if (id == null) return;
    Get.defaultDialog(
      title: 'Complete Request',
      middleText: 'Mark this request as completed?',
      textCancel: 'No',
      textConfirm: 'Yes',
      confirmTextColor: Colors.white,
      onConfirm: () {
        Get.back();
        requestController.closeRequest(id);
      },
    );
  }

  void _handlePayment(String? id) {
    final token = authController.getUserToken();
    if (id != null && token != null) {
      final url = 'https://fyndr-bay.vercel.app/payment?id=$id&token=$token';
      launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      MySnackBars.failure(
        title: "Missing Info",
        message: "Unable to initiate payment. Missing token or request ID.",
      );
    }
  }

  @override
  void dispose() {
    requestController.singleRequest.value = null;
    super.dispose();
  }

  String _formatCategory(String value) {
    if (value.isEmpty) return '';
    return value
        .split('-')
        .map((word) => word[0].toUpperCase() + word.substring(1))
        .join(' ');
  }

  String capitalize(String? text) {
    if (text == null || text.isEmpty) return 'N/A';
    return text[0].toUpperCase() + text.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final cardColor = theme.cardColor;
    final scaffoldColor = theme.scaffoldBackgroundColor;
    final fadedText =
        textTheme.bodyMedium?.color?.withOpacity(0.7) ?? Colors.grey;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: CustomAppbar(title: 'Request Details', centerTitle: true),
        backgroundColor: scaffoldColor,
        body: Column(
          children: [
            Obx(() {
              final count =
                  requestController
                      .singleRequest
                      .value
                      ?.interestedMerchants
                      ?.length ??
                  0;
              return TabBar(
                labelColor: theme.colorScheme.primary,
                unselectedLabelColor: fadedText,
                indicatorColor: theme.colorScheme.primary,
                tabs: [
                  const Tab(text: 'Details'),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Merchants'),
                        if (count > 0) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.all(6),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$count',
                              style: textTheme.labelSmall?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  const Tab(text: 'Payment'),
                ],
              );
            }),
            Expanded(
              child: Obx(() {
                final request = requestController.singleRequest.value;
                if (request == null) {
                  return Center(
                    child: Text(
                      'Request not found',
                      style: textTheme.bodyMedium,
                    ),
                  );
                }

                return TabBarView(
                  children: [
                    /// --- DETAILS TAB
                    ListView(
                      padding: EdgeInsets.all(Dimensions.width20),
                      children: [
                        Text(
                          "Title: ${capitalize(request.title)}",
                          style: textTheme.titleMedium,
                        ),
                        Text(
                          "Category: ${_formatCategory(request.category ?? '')}",
                          style: textTheme.bodyMedium,
                        ),
                        Text(
                          "State: ${request.targetState}",
                          style: textTheme.bodyMedium,
                        ),
                        Text(
                          "Axis: ${request.targetAxis?.join(', ') ?? 'General'}",
                          style: textTheme.bodyMedium,
                        ),
                        Text(
                          "Additional Description: ${request.additionalDetails}",
                          style: textTheme.bodyMedium,
                        ),
                        const SizedBox(height: 20),

                        // Categorical Conditional Info
                        if (request.category == 'car-hire') ...[
                          _info(
                            "Car Type",
                            request.carHire?.carType,
                            textTheme,
                          ),
                          _info(
                            "Pickup Location",
                            request.carHire?.pickupLocation,
                            textTheme,
                          ),
                          _info(
                            "Duration",
                            "${request.carHire?.hireDuration} hours",
                            textTheme,
                          ),
                          _info(
                            "Airport",
                            request.carHire?.airportPickup,
                            textTheme,
                          ),
                          _info(
                            "Travel",
                            request.carHire?.travel == true ? 'Yes' : 'No',
                            textTheme,
                          ),
                        ],
                        if (request.category == 'cleaning') ...[
                          _info(
                            "Property Type",
                            request.cleaning?.propertyType,
                            textTheme,
                          ),
                          _info(
                            "Location",
                            request.cleaning?.propertyLocation,
                            textTheme,
                          ),
                          _info(
                            "Number of rooms",
                            request.cleaning?.roomNumber,
                            textTheme,
                          ),
                          _info(
                            "Type",
                            request.cleaning?.cleaningType,
                            textTheme,
                          ),
                        ],
                        if (request.category == 'real-estate') ...[
                          _info(
                            "Rent or Purchase",
                            request.realEstate?.type,
                            textTheme,
                          ),
                          _info(
                            "Property Type",
                            request.realEstate?.propertyType,
                            textTheme,
                          ),
                          _info(
                            "Number of Rooms",
                            request.realEstate?.roomCount,
                            textTheme,
                          ),
                          _info(
                            "Condition",
                            request.realEstate?.propertyCondition,
                            textTheme,
                          ),
                          _info(
                            "Price Range",
                            "₦${request.realEstate?.lowerPriceLimit} - ₦${request.realEstate?.upperPriceLimit}",
                            textTheme,
                          ),
                        ],
                        if (request.category == 'car-parts') ...[
                          _info("Make", request.carPart?.carMake, textTheme),
                          _info("Model", request.carPart?.carModel, textTheme),
                          _info("Year", request.carPart?.carYear, textTheme),
                          _info(
                            "Current Location",
                            request.carPart?.currentLocation,
                            textTheme,
                          ),
                          _info(
                            "Sourcing Location",
                            request.carPart?.sourcingLocation,
                            textTheme,
                          ),
                        ],
                        if (request.category == 'automobile') ...[
                          _info("Make", request.automobile?.carMake, textTheme),
                          _info(
                            "Model",
                            request.automobile?.carModel,
                            textTheme,
                          ),
                          _info(
                            "Year Range",
                            "${request.automobile?.carYearFrom} - ${request.automobile?.carYearTo}",
                            textTheme,
                          ),
                          _info(
                            "Transmission",
                            request.automobile?.transmission,
                            textTheme,
                          ),
                          _info(
                            "Location",
                            request.automobile?.location,
                            textTheme,
                          ),
                          _info(
                            "Price Range",
                            "₦${request.automobile?.lowerPriceLimit} - ₦${request.automobile?.upperPriceLimit}",
                            textTheme,
                          ),
                        ],

                        SizedBox(height: Dimensions.height50),

                        /// ACTION BUTTONS
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                text: 'Cancel Request',
                                onPressed: () => _confirmCancel(request.id),
                              ),
                            ),
                            SizedBox(width: Dimensions.width10),
                            Expanded(
                              child: CustomButton(
                                text: 'Mark as Completed',
                                onPressed: () => _confirmComplete(request.id),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    /// --- MERCHANTS TAB
                    request.interestedMerchants?.isEmpty == true
                        ? const Center(
                          child: EmptyState(message: 'No merchant offers yet'),
                        )
                        : ListView.builder(
                          padding: EdgeInsets.all(Dimensions.width20),
                          itemCount: request.interestedMerchants?.length ?? 0,
                          itemBuilder: (_, index) {
                            final interested =
                                request.interestedMerchants![index];
                            final merchant = interested.merchant;
                            final message = interested.message;

                            return Card(
                              color: cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                  Dimensions.radius10,
                                ),
                              ),
                              child: ListTile(
                                contentPadding: EdgeInsets.all(
                                  Dimensions.width10,
                                ),
                                leading: CircleAvatar(
                                  radius: Dimensions.radius30,
                                  backgroundImage: NetworkImage(
                                    merchant?.avatar ?? '',
                                  ),
                                  backgroundColor: theme.dividerColor,
                                ),
                                title: Row(
                                  children: [
                                    Expanded(
                                      child: Text(
                                        merchant?.businessName?.toUpperCase() ??
                                            'Business Name',
                                        style: textTheme.titleSmall?.copyWith(
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    if (merchant?.idVerified == true)
                                      Padding(
                                        padding: EdgeInsets.only(
                                          left: Dimensions.width10,
                                        ),
                                        child: Image.asset(
                                          AppConstants.getPngAsset('verified'),
                                          height:
                                              Dimensions.height20 +
                                              Dimensions.height5,
                                        ),
                                      ),
                                  ],
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      '${merchant?.state ?? ''} State, ${merchant?.lga ?? ''}',
                                      style: textTheme.bodySmall,
                                    ),
                                    Text(
                                      message?.content ??
                                          'No message available',
                                      style: textTheme.bodySmall?.copyWith(
                                        fontSize: Dimensions.font13,
                                      ),
                                    ),
                                    SizedBox(height: Dimensions.height10),
                                    InkWell(
                                      onTap: () {
                                        if (interested.isAccepted != true) {
                                          requestController
                                              .acceptMerchantInterest(
                                                requestId: request.id ?? '',
                                                interestId: interested.id ?? '',
                                              );
                                        }
                                      },
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: Dimensions.width20,
                                          vertical: Dimensions.height10,
                                        ),
                                        decoration: BoxDecoration(
                                          color:
                                              interested.isAccepted == true
                                                  ? Colors.grey
                                                  : AppColors.primary,
                                          borderRadius: BorderRadius.circular(
                                            Dimensions.radius10,
                                          ),
                                        ),
                                        child: Text(
                                          interested.isAccepted == true
                                              ? 'Interviewing..'
                                              : 'Choose Merchant',
                                          style: textTheme.bodySmall?.copyWith(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),

                    /// --- PAYMENT TAB
                    Padding(
                      padding: EdgeInsets.all(Dimensions.width20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _info(
                            "Transaction ID",
                            request.transactionId,
                            textTheme,
                          ),
                          _info(
                            "Reference ID",
                            request.transactionReference,
                            textTheme,
                          ),
                          _info(
                            "Payment Method",
                            request.paymentMethod,
                            textTheme,
                          ),
                          _info("Status", request.transactionStatus, textTheme),
                          SizedBox(height: Dimensions.height50),
                          CustomButton(
                            text: 'Initiate Payment',
                            isDisabled:
                                request.transactionStatus?.toLowerCase() ==
                                'completed',
                            onPressed: () => _handlePayment(request.id),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
