import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/widgets/empty_state_widget.dart';
import 'package:fyndr/widgets/job_post_card.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import '../../models/job_model.dart';
import '../../utils/app_constants.dart';
import '../../utils/dimensions.dart';
import '../../widgets/custom_appbar.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class JobSeekerScreen extends StatefulWidget {
  const JobSeekerScreen({super.key});

  @override
  State<JobSeekerScreen> createState() => _JobSeekerScreenState();
}

class _JobSeekerScreenState extends State<JobSeekerScreen> {
  RequestController requestController = Get.find<RequestController>();
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      requestController.fetchJobListings();
    });
    super.initState();
  }

  @override
  void dispose() {
    searchController.dispose;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme
        .of(context)
        .brightness == Brightness.dark;
    final backgroundColor = Theme
        .of(context)
        .scaffoldBackgroundColor;
    final textColor =
        Theme
            .of(context)
            .textTheme
            .bodyLarge
            ?.color ?? Colors.black;
    final iconColor = Theme
        .of(context)
        .iconTheme
        .color ?? Colors.black;

    return Scaffold(
      appBar: CustomAppbar(
        title: 'Job Seekers Screen',
        leadingIcon: BackButton(),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: ()async {
            requestController.fetchJobListings();
          },
          child: Padding(
            padding: EdgeInsets.symmetric(
              horizontal: Dimensions.width20,
              vertical: Dimensions.height20,
            ),
            child: Column(
              children: [
                CustomButton(
                  text: 'Create CV',
                  onPressed: () {
                    Get.toNamed(AppRoutes.postCvScreen);
                  },
                ),
                SizedBox(height: Dimensions.height20),
                CustomTextField(
                  hintText: 'Filter by Job Title',
                  prefixIcon: Icons.search,
                  controller: searchController,
                  onChanged: (value) {
                    requestController.filterJobs(value);
                  },
                ),
                SizedBox(height: Dimensions.height20),
                Expanded(
                  child: GetBuilder<RequestController>(
                    builder: (controller) {
                      if (controller.filteredJobs.isEmpty) {
                        return const EmptyState(message: "No jobs available");
                      }

                      return ListView.builder(
                        itemCount: controller.filteredJobs.length,
                        itemBuilder: (context, index) {
                          JobModel job = controller.filteredJobs[index];
                          final time =
                          job.createdAt != null
                              ? timeago.format(job.createdAt!)
                              : '';
                          return JobPostCard(
                            id: job.id ?? '',
                            companyImage: job.employerDetails?.companyImage ??
                                '',
                            companyName: job.employerDetails?.company ??
                                'Not Specified',
                            occupation:
                            job.jobDetails?.title ?? "Not specified",
                            location: job.jobDetails?.location ?? "N/A",
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
    );
  }
}
