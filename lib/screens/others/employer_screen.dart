import 'package:flutter/material.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:fyndr/widgets/cv_card.dart';
import 'package:get/get.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../controllers/request_controller.dart';
import '../../models/job_model.dart';
import '../../widgets/empty_state_widget.dart';

class EmployerScreen extends StatefulWidget {
  const EmployerScreen({super.key});

  @override
  State<EmployerScreen> createState() => _EmployerScreenState();
}

class _EmployerScreenState extends State<EmployerScreen> {

  RequestController requestController = Get.find<RequestController>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestController.fetchCvs();
    });
    super.initState();
  }
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Employers Screen',
        centerTitle: true,
        leadingIcon: BackButton(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async {
            requestController.fetchCvs();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            child: SingleChildScrollView(
              child: Container(
                height: Dimensions.screenHeight,
                child: Column(
                  children: [
                    CustomButton(
                      text: 'Post a Job',
                      onPressed: () {
                        Get.toNamed(AppRoutes.postJobScreen);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    CustomTextField(
                      hintText: 'Filter by Role',
                      prefixIcon: Icons.search,
                      controller: searchController,
                      onChanged: (value){
                        requestController.filterCvs(value);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),

                    Expanded(
                      child: GetBuilder<RequestController>(
                        builder: (controller) {
                          if (controller.filteredCvs.isEmpty) {
                            return const EmptyState(message: "No jobs available");
                          }

                          return ListView.builder(
                            itemCount: controller.filteredCvs.length,
                            itemBuilder: (context, index) {
                              CvModel cv = controller.filteredCvs[index];

                              return CvCard(cv: cv,
                                avatar: cv.profileImage ?? '',
                                firstName: cv.firstName,
                                lastName: cv.lastName,
                                state: cv.state,
                                educationMajor: cv.educationDetails.educationMajor,
                                timePosted: timeago.format(cv.createdAt),
                              );
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
