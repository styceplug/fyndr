import 'package:flutter/material.dart';
import 'package:fyndr/data/services/employment_data.dart';
import 'package:fyndr/widgets/job_post_card.dart';

import '../models/job_model.dart';
import '../utils/app_constants.dart';
import '../utils/dimensions.dart';

class CvCard extends StatelessWidget {
  final CvModel cv;
  final String? firstName;
  final String? lastName;
  final String? state;
  final String? timePosted;
  final String? educationMajor;

  const CvCard({
    super.key,
    required this.cv,
    this.firstName,
    this.lastName,
    this.state,
    this.educationMajor,
    required this.timePosted,
  });

  @override
  Widget build(BuildContext context) {
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Container(
      height: Dimensions.height20 * 5,
      padding: EdgeInsets.symmetric(
        horizontal: Dimensions.width10,
        vertical: Dimensions.height10,
      ),
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      decoration: BoxDecoration(
        border: Border.all(color: iconColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(Dimensions.radius10),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                height: Dimensions.height10 * 5,
                width: Dimensions.width10 * 5,
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.05),
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                ),
                child: Icon(Icons.work_history_rounded, color: iconColor),
              ),
              SizedBox(width: Dimensions.width20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  Row(
                    children: [
                      Text(
                        (firstName ?? '').capitalizeEachWord(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(width: Dimensions.width5),
                      Text(
                        (lastName ?? '').capitalizeEachWord(),
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Text(
                    (state ?? '').capitalizeEachWord(),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontSize: Dimensions.font14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),

                ],
              ),
              const Spacer(),
              Text('Expand CV', style: TextStyle(color: Colors.blueAccent)),
            ],
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: Dimensions.width10,
                  vertical: Dimensions.height5,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius5),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.school,
                      size: Dimensions.iconSize16,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: Dimensions.width5),
                    Text(
                      educationMajor!.capitalizeEachWord(),
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),

              Text(timePosted.toString(), overflow: TextOverflow.ellipsis),
            ],
          ),
        ],
      ),
    );
  }
}
