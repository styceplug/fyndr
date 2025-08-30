import 'package:flutter/material.dart';
import 'package:fyndr/controllers/request_controller.dart';
import 'package:fyndr/data/services/employment_data.dart';
import 'package:fyndr/widgets/job_post_card.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../models/job_model.dart';
import '../routes/routes.dart';
import '../utils/app_constants.dart';
import '../utils/dimensions.dart';

class CvCard extends StatelessWidget {
  final CvModel cv;
  final String? firstName;
  final String? lastName;
  final String avatar;
  final String? state;
  final String? timePosted;
  final String? educationMajor;

  const CvCard({
    super.key,
    required this.cv,
    this.firstName,
    this.lastName,
    required this.avatar,
    this.state,
    this.educationMajor,
    required this.timePosted,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Container(
      height: Dimensions.height20 * 5,
      padding: EdgeInsets.fromLTRB(
        0,
        Dimensions.height10,
        Dimensions.width20,
        Dimensions.height10,
      ),

      margin: EdgeInsets.only(bottom: Dimensions.height10),
      decoration: BoxDecoration(
        border: Border.all(color: iconColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(Dimensions.radius30 * 2),
      ),
      child: Row(
        children: [
          Container(
            height: Dimensions.height20 * 5,
            width: Dimensions.width20 * 5,
            decoration: BoxDecoration(
              border: Border.all(
                color: Theme.of(context).primaryColor,
                width: Dimensions.width5 / Dimensions.width5,
              ),
              shape: BoxShape.circle,
              color: Theme.of(context).dividerColor.withOpacity(0.05),
              image: DecorationImage(
                image: NetworkImage(avatar!),
                fit: BoxFit.cover,
              ),
            ),
            clipBehavior: Clip.antiAlias,
          ),
          SizedBox(width: Dimensions.width10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        (firstName ?? '').capitalizeEachWord(),
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: Dimensions.width5),
                      Flexible(
                        child: Text(
                          (lastName ?? '').capitalizeEachWord(),
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Text(
                    (educationMajor ?? '').capitalizeEachWord(),
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    "${(state ?? '').capitalizeEachWord()} State, Nigeria",
                    overflow: TextOverflow.ellipsis,

                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Dimensions.width10,),
          InkWell(
            onTap: () async {
              RequestController controller = Get.find<RequestController>();
              bool success = await controller.fetchSingleCv(cv.id);

              if (!success || controller.selectedCv == null) {
                Get.snackbar(
                  "Error",
                  "Failed to load CV details. Please try again.",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                );
                return;
              }

              Get.toNamed(AppRoutes.cvDetailsScreen);
            },
            child: Text('View CV', style: TextStyle(color: Colors.blueAccent)),
          ),
        ],
      ),
    );
  }
}
