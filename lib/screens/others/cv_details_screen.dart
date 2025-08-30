import 'package:flutter/material.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:get/get.dart';

import '../../controllers/request_controller.dart';

class CvDetailsScreen extends StatefulWidget {
  const CvDetailsScreen({super.key});

  @override
  State<CvDetailsScreen> createState() => _CvDetailsScreenState();
}

class _CvDetailsScreenState extends State<CvDetailsScreen> {
  RequestController controller = Get.find<RequestController>();

  @override
  Widget build(BuildContext context) {
    final cv = controller.selectedCv;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: CustomAppbar(
        title: 'CV Details',
        leadingIcon: const BackButton(),
      ),

      body: Padding(
        padding: EdgeInsets.fromLTRB(
          Dimensions.width20,
          0,
          Dimensions.width20,
          Dimensions.height20,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height10,
                ),
                width: Dimensions.screenWidth,
                decoration: BoxDecoration(
                  color: Colors.amber.withOpacity(0.01),
                  border: Border.all(
                    color: Theme.of(context).dividerColor.withOpacity(0.5),
                  ),
                  borderRadius: BorderRadius.circular(Dimensions.radius20),
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.teal,
                        borderRadius: BorderRadius.circular(
                          Dimensions.radius20,
                        ),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: Dimensions.width20,
                        vertical: Dimensions.height20,
                      ),
                      margin: EdgeInsets.only(right: Dimensions.width10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            height: Dimensions.height20 * 6,
                            width: Dimensions.width20 * 6,
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
                                  (cv?.profileImage != null &&
                                          cv!.profileImage!.isNotEmpty)
                                      ? DecorationImage(
                                        image: NetworkImage(cv.profileImage!),
                                        fit: BoxFit.cover,
                                      )
                                      : null,
                            ),
                            clipBehavior: Clip.antiAlias,
                            child:
                                (cv?.profileImage == null ||
                                        cv!.profileImage!.isEmpty)
                                    ? Icon(
                                      Icons.business,
                                      size: Dimensions.height20 * 2,
                                      color: Colors.grey,
                                    )
                                    : null,
                          ),
                          SizedBox(height: Dimensions.height10),
                          Text(
                            'About Me',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: Dimensions.font20,
                              fontWeight: FontWeight.w700,
                                color: Colors.white
                            ),
                          ),
                          SizedBox(height: Dimensions.height5),
                          Text(
                            cv?.number ?? '',
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(
                              fontSize: Dimensions.font17,
                              fontWeight: FontWeight.w400,
                              color: Colors.white
                            ),
                          ),
                          SizedBox(height: Dimensions.height30),
                          Row(
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: Dimensions.width5,vertical: Dimensions.height5),
                                decoration: BoxDecoration(color: Colors.white,shape: BoxShape.circle),
                                  child: Icon(Icons.phone, size: Dimensions.iconSize16)),
                              SizedBox(width: Dimensions.width5),
                              Text(cv?.number ?? '',style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.white),),
                            ],
                          ),
                          SizedBox(height: Dimensions.height5),
                          Row(
                            children: [
                              Icon(Icons.mail, size: Dimensions.iconSize16),
                              SizedBox(width: Dimensions.width5),
                              Text(cv?.email ?? ''),
                            ],
                          ),
                          SizedBox(height: Dimensions.height5),
                          Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: Dimensions.iconSize16,
                              ),
                              SizedBox(width: Dimensions.width5),
                              Text('${cv?.area}, ${cv?.lga}, ${cv?.state}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Row(
                          children: [
                            SizedBox(width: Dimensions.width30),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  cv?.firstName ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontSize: Dimensions.font30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  cv?.lastName ?? '',
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontSize: Dimensions.font30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  cv!.workExperienceDetails.map((exp) => exp.jobTitle).join(', '),
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleLarge?.copyWith(
                                    fontSize: Dimensions.font16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        SizedBox(height: Dimensions.height30),

                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
