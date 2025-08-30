import 'package:flutter/material.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:get/get.dart';
import 'package:icons_launcher/cli_commands.dart';

import '../controllers/request_controller.dart';
import '../models/job_model.dart';
import '../utils/app_constants.dart';
import '../utils/dimensions.dart';

class JobPostCard extends StatelessWidget {
  final String companyName;
  final String occupation;
  final String location;
  final String companyImage;
  final String id;

  const JobPostCard({
    super.key,
    required this.companyName,
    required this.occupation,
    required this.location,
    required this.companyImage,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    RequestController controller = Get.find<RequestController>();
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;


    return Container(
      height: Dimensions.height20 * 4.99,
      alignment: Alignment.center,
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
              shape: BoxShape.circle,
              color: Theme.of(context).dividerColor.withOpacity(0.05),
            ),
            clipBehavior: Clip.antiAlias,
            child: Image.network(
              companyImage,
              fit: BoxFit.cover,
              errorBuilder:
                  (context, error, stackTrace) => Icon(
                    Icons.business,
                    size: Dimensions.height20 * 3,
                    color: Colors.grey,
                  ),
            ),
          ),
          SizedBox(width: Dimensions.width10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Expanded(
                  child: Text(
                    companyName.capitalizeEachWord(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Expanded(
                  child: Text(
                    occupation.capitalizeEachWord(),
                    overflow: TextOverflow.ellipsis,

                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
                Expanded(
                  child: Text(
                    location.capitalizeEachWord(),

                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF85CE5C),
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: Dimensions.width10),
          InkWell(
          onTap: ()async{
            await controller.fetchSingleJob(id);
              Get.toNamed(AppRoutes.jobDetailsScreen);
            },
            child: Text('View Job', style: TextStyle(color: Color(0xFF85CE5C))),
          ),
        ],
      ),
    );
  }
}

extension StringCasingExtension on String {
  String capFirst() {
    if (isEmpty) return this;
    return this[0].toUpperCase() + substring(1);
  }

  String capitalizeEachWord() {
    return split(' ').map((word) => word.capFirst()).join(' ');
  }
}
