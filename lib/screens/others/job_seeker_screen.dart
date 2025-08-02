import 'package:flutter/material.dart';

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


  @override
  Widget build(BuildContext context) {

    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Scaffold(
      appBar: CustomAppbar(title: 'Job Seekers Screen'),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: Dimensions.width20,
            vertical: Dimensions.height20,
          ),
          child: Column(
            children: [
              CustomButton(text: 'Create CV', onPressed: () {}),
              SizedBox(height: Dimensions.height20),
              CustomTextField(
                hintText: 'Filter by Job Title',
                prefixIcon: Icons.search,
              ),
              SizedBox(height: Dimensions.height20),
              Container(
                height: Dimensions.height10 * 8,
                padding: EdgeInsets.only(right: Dimensions.width10),
                decoration: BoxDecoration(
                  // color: Colors.red,
                  border: Border.all(color: iconColor),
                  borderRadius: BorderRadius.circular(Dimensions.radius30),
                ),
                child: Row(
                  children: [
                    Container(
                      height: Dimensions.height70,
                      width: Dimensions.width70,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        image: DecorationImage(
                          image: AssetImage(AppConstants.getPngAsset('user')),
                        ),
                      ),
                    ),
                    SizedBox(width: Dimensions.width20),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Text(
                          'First Name Last Name',
                          style: TextStyle(color: textColor),
                        ),
                        Text('Occupation', style: TextStyle(color: textColor)),
                        Text('Location', style: TextStyle(color: textColor)),
                      ],
                    ),
                    Spacer(),
                    Text('View Job'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
