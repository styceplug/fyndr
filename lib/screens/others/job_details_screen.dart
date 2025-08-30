import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/custom_textfield.dart';
import 'package:fyndr/widgets/empty_state_widget.dart';
import 'package:fyndr/widgets/job_post_card.dart';
import 'package:get/get.dart';

import '../../data/services/employment_data.dart';

class JobDetailsScreen extends StatefulWidget {
  @override
  State<JobDetailsScreen> createState() => _JobDetailsScreenState();
}

class _JobDetailsScreenState extends State<JobDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return GetBuilder<RequestController>(
      builder: (controller) {
        final job = controller.selectedJob;
        if (job == null) {
          return Scaffold(
            appBar: CustomAppbar(title: "Job Details"),
            body: Center(child: EmptyState(message: "No job found")),
          );
        }

        return Scaffold(
          appBar: CustomAppbar(title: 'Job Details', leadingIcon: BackButton()),
          body: Padding(
            padding: EdgeInsets.all(Dimensions.width20),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        height: Dimensions.height20 * 3,
                        width: Dimensions.width20 * 3,
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Theme.of(context).primaryColor,
                            width: Dimensions.width5 / Dimensions.width5,
                          ),
                          shape: BoxShape.circle,
                          color: Theme.of(
                            context,
                          ).dividerColor.withOpacity(0.05),
                          image:
                              job.employerDetails?.companyImage != null &&
                                      job
                                          .employerDetails!
                                          .companyImage!
                                          .isNotEmpty
                                  ? DecorationImage(
                                    image: NetworkImage(
                                      job.employerDetails!.companyImage!,
                                    ),
                                    fit: BoxFit.contain,
                                  )
                                  : null,
                        ),
                        clipBehavior: Clip.antiAlias,
                        child:
                            (job.employerDetails?.companyImage == null ||
                                    job.employerDetails!.companyImage!.isEmpty)
                                ? Icon(
                                  Icons.business,
                                  size: Dimensions.height20 * 2,
                                  color: Colors.grey,
                                )
                                : null,
                      ),
                      SizedBox(width: Dimensions.width10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Text(
                            job.employerDetails?.company!
                                    .capitalizeEachWord() ??
                                '',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.w700),
                            overflow: TextOverflow.ellipsis,
                          ),
                          Row(
                            children: [
                              Text(
                                job.employerDetails?.firstName!
                                        .capitalizeEachWord() ??
                                    '',
                                overflow: TextOverflow.ellipsis,

                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  fontSize: Dimensions.font14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(width: Dimensions.width5),
                              Text(
                                job.employerDetails?.lastName!
                                        .capitalizeEachWord() ??
                                    '',
                                overflow: TextOverflow.ellipsis,

                                style: Theme.of(
                                  context,
                                ).textTheme.titleSmall?.copyWith(
                                  fontSize: Dimensions.font14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    job.jobDetails?.title ?? '',
                    style: TextStyle(
                      fontSize: Dimensions.font22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.green3,
                    ),
                  ),
                  SizedBox(height: Dimensions.height10),

                  Text(
                    "${job.jobDetails?.location!.capitalizeFirst}  •  ${job.jobDetails?.type!.capitalizeFirst}  •  ${timeAgo(job.createdAt)}",
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    "Salary: ${job.jobDetails?.salaryCurrency} ${job.jobDetails?.salary}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    "Benefits",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.height5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:
                        job.jobDetails!.benefits!.map((slug) {
                          final readable =
                              benefitMap[slug] ??
                              slug.replaceAll('-', ' ').capitalizeEachWord();
                          return Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: Dimensions.width5,
                              vertical: Dimensions.height5,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(
                                context,
                              ).dividerColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(
                                Dimensions.radius5,
                              ),
                            ),
                            margin: EdgeInsets.only(right: Dimensions.width10),
                            child: Text(
                              readable.capitalizeEachWord(),
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          );
                        }).toList(),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text(
                    "Vacancy: ${job.jobDetails?.availableVacancy}",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: Dimensions.height20),
                  Text("Description: ${job.jobDetails?.description}"),
                  SizedBox(height: Dimensions.height20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: CustomButton(
                          text: 'Apply',
                          onPressed: () {
                            showProposalDialog(context);
                          },
                        ),
                      ),
                      SizedBox(width: Dimensions.width20),
                      Expanded(
                        child: CustomButton(
                          text: 'Back to Jobs',
                          onPressed: () {
                            Get.back();
                          },
                          backgroundColor:
                              Theme.of(context).scaffoldBackgroundColor,
                          borderColor: AppColors.green3,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String timeAgo(DateTime? dt) {
    if (dt == null) return '';
    final diff = DateTime.now().difference(dt);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    return '${diff.inDays}d ago';
  }
}

Future<void> showProposalDialog(BuildContext context) async {
  final TextEditingController proposalController = TextEditingController();
  final jobController = Get.find<RequestController>();

  await jobController.fetchMyCvs();

  void postProposal() async {
    final body = {
      "cvId": jobController.selectedCv?.id,
      "proposal": proposalController.text.trim(),
    };

    await jobController.postProposal(body, jobController.selectedJob!.id!);
  }

  return showDialog(
    context: context,
    builder: (ctx) {
      return AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Dimensions.radius5),
        ),
        title: Text(
          "Submit Proposal",
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            fontSize: Dimensions.font20,
          ),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CustomTextField(
                controller: proposalController,
                maxLines: 5,
                hintText: "Write your proposal",
              ),
              SizedBox(height: Dimensions.height20),

              // CVs list
              Obx(() {
                if (jobController.fetchingCV.value) {
                  return Center(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        CircularProgressIndicator(),
                        Text('Fetching your Cv'),
                      ],
                    ),
                  );
                }
                if (jobController.cvList.isEmpty) {
                  return Text("No CVs found.");
                }
                return SizedBox(
                  height: 150,
                  child: ListView.builder(
                    itemCount: jobController.cvList.length,
                    itemBuilder: (context, index) {
                      final cv = jobController.cvList[index];
                      return ListTile(
                        leading: const Icon(Icons.description),
                        title: Text(cv.firstName ?? ""),
                        subtitle: Text(cv.createdAt?.toString() ?? ""),
                        trailing:
                            jobController.selectedCv?.id == cv.id
                                ? const Icon(Icons.check_box_outlined)
                                : const Icon(Icons.check_box_outline_blank),
                        onTap: () {
                          if (jobController.selectedCv?.id == cv.id) {
                            // If already selected, unselect
                            jobController.selectedCv = null;
                            Get.snackbar(
                              "Unselected",
                              "You removed ${cv.firstName}",
                            );
                          } else {
                            // Select this CV
                            jobController.selectedCv = cv;
                            Get.snackbar(
                              "Selected",
                              "You picked ${cv.firstName}",
                            );
                          }
                          jobController.update(); // refresh UI
                        },
                      );
                    },
                  ),
                );
              }),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text("Cancel")),
          ElevatedButton(
            onPressed: () async {
              final proposal = proposalController.text.trim();
              final selectedCv = jobController.selectedCv;

              if (proposal.isEmpty || selectedCv == null) {
                Get.snackbar("Error", "Proposal and CV are required!");
                return;
              }
              postProposal();
              print(
                "📩 Submitting proposal: $proposal with CV ${selectedCv.id}",
              );

              Get.back();
            },
            child: Text("Submit"),
          ),
        ],
      );
    },
  );
}
