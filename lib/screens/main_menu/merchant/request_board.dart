import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:fyndr/widgets/empty_state_widget.dart';
import 'package:fyndr/widgets/request_card.dart';
import 'package:fyndr/widgets/snackbars.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../../data/services/profile_data.dart';
import '../../../data/services/states_lga_local.dart';
import '../../../widgets/merchant_request_card.dart';

class RequestBoard extends StatefulWidget {
  const RequestBoard({super.key});

  @override
  State<RequestBoard> createState() => _RequestBoardState();
}

class _RequestBoardState extends State<RequestBoard> {
  RequestController requestController = Get.find<RequestController>();
  String? selectedService;
  String? selectedState;
  String? selectedLga;
  DateTime? selectedDate;
  String searchText = '';
  bool showFilters = false;

  InputDecoration _filterDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey.shade300,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(Dimensions.radius20),
        borderSide: BorderSide.none,
      ),
      contentPadding: EdgeInsets.only(
        right: Dimensions.width20,
        left: Dimensions.width20,
        top: Dimensions.height10,
        bottom: Dimensions.height10,
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    /*WidgetsBinding.instance.addPostFrameCallback((_) {
      requestController.fetchMerchantRequests();
    });*/
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textColor = theme.textTheme.bodyLarge?.color ?? Colors.black;
    final fadedText = textColor.withOpacity(0.7);
    final cardColor = theme.cardColor;

    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: CustomAppbar(
        centerTitle: true,
        title: 'Open Requests',
        actionIcon: InkWell(
          onTap: () {
            Get.toNamed(AppRoutes.merchantNotificationScreen);
          },
          child: Icon(Icons.notifications_active, color: textColor),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: CustomTextField(
                      hintText: 'Search',
                      prefixIcon: Icons.search,
                      onChanged: (value) {
                        setState(() {
                          searchText = value;
                        });
                      },
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  InkWell(
                    onTap: () {
                      setState(() {
                        if (showFilters) {
                          selectedService = null;
                          selectedState = null;
                          selectedLga = null;
                          selectedDate = null;
                        }
                        showFilters = !showFilters;
                      });
                    },
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.width15),
                      decoration: BoxDecoration(
                        color: showFilters
                            ? theme.colorScheme.primary
                            : theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(Dimensions.radius10),
                      ),
                      child: Icon(
                        showFilters ? Icons.close : Icons.tune,
                        color: showFilters ? Colors.white : textColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),
              Row(
                children: [
                  InkWell(
                    onTap: () async {
                      await requestController.fetchMerchantRequests();
                    },
                    borderRadius: BorderRadius.circular(Dimensions.radius10),
                    child: Container(
                      padding: EdgeInsets.all(Dimensions.width15),
                      decoration: BoxDecoration(
                        color: theme.colorScheme.surfaceVariant,
                        borderRadius: BorderRadius.circular(Dimensions.radius10),
                      ),
                      child: Icon(Icons.refresh, color: textColor),
                    ),
                  ),
                  SizedBox(width: Dimensions.width10),
                  Expanded(
                    child: CustomButton(
                      text: 'Create Request',
                      onPressed: () {
                        MySnackBars.processing(
                          title: 'Coming Soon',
                          message:
                          'This Feature is coming soon for Merchants, Stay Tuned',
                        );
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: Dimensions.height20),

              // Filter Section
              AnimatedCrossFade(
                duration: Duration(milliseconds: 300),
                crossFadeState: showFilters
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
                firstChild: Column(
                  children: [
                    Row(
                      children: [
                        IntrinsicWidth(
                          child: DropdownButtonFormField<String>(
                            value: selectedService,
                            decoration: _filterDecoration(),
                            hint: Text('Service'),
                            items: merchantServicesMap.entries.map((e) {
                              return DropdownMenuItem(
                                value: e.value,
                                child: Text(e.key),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedService = value;
                              });
                            },
                          ),
                        ),
                        SizedBox(width: Dimensions.width10),
                        Expanded(
                          child: InkWell(
                            onTap: () async {
                              final picked = await showDatePicker(
                                context: context,
                                initialDate: DateTime.now(),
                                firstDate: DateTime(2023),
                                lastDate:
                                DateTime.now().add(Duration(days: 365)),
                                builder: (context, child) {
                                  return Theme(
                                    data: theme.copyWith(
                                      colorScheme: theme.colorScheme.copyWith(
                                        primary: theme.colorScheme.primary,
                                      ),
                                    ),
                                    child: child!,
                                  );
                                },
                              );
                              if (picked != null) {
                                setState(() {
                                  selectedDate = picked;
                                });
                              }
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: Dimensions.width15,
                                vertical: Dimensions.height15,
                              ),
                              decoration: BoxDecoration(
                                borderRadius:
                                BorderRadius.circular(Dimensions.radius20),
                                color: theme.colorScheme.surfaceVariant,
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      selectedDate != null
                                          ? DateFormat('dd MMM')
                                          .format(selectedDate!)
                                          : 'Date',
                                      style: TextStyle(color: fadedText),
                                    ),
                                  ),
                                  Icon(Icons.calendar_today_outlined, size: 18),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                secondChild: SizedBox.shrink(),
              ),
              SizedBox(height: Dimensions.height20),

              // Request List
              Container(
                height: Dimensions.height100 * 4.8,
                child: Obx(() {
                  final requests = [...requestController.merchantRequests];

                  // Sort
                  requests.sort((a, b) =>
                  b.createdAt?.compareTo(a.createdAt ?? DateTime(0)) ?? 0);

                  // Filter
                  final filteredRequests = requests.where((request) {
                    final matchesService = selectedService == null ||
                        request.category == selectedService;
                    final matchesState = selectedState == null ||
                        request.targetState == selectedState;
                    final matchesLga = selectedLga == null ||
                        (request.targetAxis?.contains(selectedLga) ?? false);
                    final matchesDate = selectedDate == null ||
                        (request.createdAt != null &&
                            request.createdAt!.year == selectedDate!.year &&
                            request.createdAt!.month == selectedDate!.month &&
                            request.createdAt!.day == selectedDate!.day);
                    final matchesSearch = request.title
                        ?.toLowerCase()
                        .contains(searchText.toLowerCase()) ??
                        false;

                    return matchesService &&
                        matchesState &&
                        matchesLga &&
                        matchesDate &&
                        matchesSearch;
                  }).toList();

                  if (requests.isEmpty) {
                    return Center(
                      child: EmptyState(
                        message:
                        "No open requests at the moment, check back later.",
                      ),
                    );
                  }

                  return ListView.separated(
                    itemCount: filteredRequests.length,
                    separatorBuilder: (_, __) =>
                        SizedBox(height: Dimensions.height15),
                    itemBuilder: (_, index) {
                      final request = filteredRequests[index];
                      return MerchantRequestCard(
                        requestId: request.id ?? '',
                        title: request.title ?? 'Request',
                        category: request.category ?? '',
                        date: request.createdAt,
                        serviceType: request.category ?? '',
                        address:
                        '${request.targetState ?? ''} ${request.targetAxis?.join(', ') ?? ''}'
                            .trim(),
                        description: request.additionalDetails ?? '',
                      );
                    },
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
