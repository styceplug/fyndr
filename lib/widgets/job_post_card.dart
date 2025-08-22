import 'package:flutter/material.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:get/get.dart';
import 'package:icons_launcher/cli_commands.dart';

import '../utils/app_constants.dart';
import '../utils/dimensions.dart';

class JobPostCard extends StatelessWidget {
  final String name;
  final String occupation;
  final String location;
  final String salary;
  final String timePosted;
  final String vacancy;


  const JobPostCard({
    super.key,
    required this.name,
    required this.occupation,
    required this.location,
    required this.salary,
    required this.timePosted,
    required this.vacancy,

  });

  @override
  Widget build(BuildContext context) {
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Container(
      height: Dimensions.height20*7,
      padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,vertical: Dimensions.height10),
      margin: EdgeInsets.only(bottom: Dimensions.height10),
      decoration: BoxDecoration(
        border: Border.all(color: iconColor.withOpacity(0.4)),
        borderRadius: BorderRadius.circular(Dimensions.radius10),
      ),
      child: Column(
        children: [
          Expanded(
            child: Row(
              children: [
                Container(
                  height: Dimensions.height10 * 5,
                  width: Dimensions.width10 * 5,
                  decoration: BoxDecoration(
                    color: Theme.of(context).dividerColor.withOpacity(0.05),
                    borderRadius: BorderRadius.circular(Dimensions.radius10)
                  ),
                  child: Icon(Icons.work_history_rounded, color: iconColor),
                ),
                SizedBox(width: Dimensions.width20),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text(
                      name.capitalizeEachWord(),
                      style: Theme.of(
                        context,
                      ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      occupation.capitalizeEachWord(),
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(fontSize: Dimensions.font14,fontWeight: FontWeight.w400),
                    ),
                    SizedBox(height: Dimensions.height5),
                    Row(
                      children: [
                        Text('₦',
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700,color: Colors.purple),

                        ),
                        SizedBox(width: Dimensions.width10/Dimensions.width5),
                        Text(
                          salary.capitalizeEachWord(),
                          style: Theme.of(
                            context,
                          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700,color: Colors.purple),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                    Spacer(),
                  ],
                ),
                const Spacer(),
                Text('View Job', style: TextStyle(color: Colors.blueAccent)),
              ],
            ),
          ),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width10,vertical: Dimensions.height5),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius5)
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.pin_drop_outlined,
                      size: Dimensions.iconSize16,
                      color: Theme.of(context).iconTheme.color,
                    ),
                    SizedBox(width: Dimensions.width5),
                    Text(
                      location.capitalizeEachWord(),
                      style: Theme.of(context).textTheme.bodySmall,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              SizedBox(width: Dimensions.width20),
              Container(
                padding: EdgeInsets.symmetric(horizontal: Dimensions.width5,vertical: Dimensions.height5),
                decoration: BoxDecoration(
                  color: Theme.of(context).dividerColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(Dimensions.radius5)
                ),
                child: Row(
                  children: [
                    Text(
                      'Vacancy:',
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    SizedBox(width: Dimensions.width5),
                    Text(
                      vacancy.capitalizeEachWord(),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  ],
                ),
              ),
              Spacer(),
              Text(timePosted,overflow: TextOverflow.ellipsis,)
            ],
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
