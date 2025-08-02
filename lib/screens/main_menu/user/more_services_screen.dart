import 'package:flutter/material.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class MoreServicesScreen extends StatefulWidget {
  const MoreServicesScreen({super.key});

  @override
  State<MoreServicesScreen> createState() => _MoreServicesScreenState();
}

class _MoreServicesScreenState extends State<MoreServicesScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = Theme.of(context).scaffoldBackgroundColor;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: CustomAppbar(
        title: 'More Services',
        titleColor: textColor,
        // centerTitle: true,
        leadingIcon: BackButton(color: iconColor),
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          children: [
            SearchBar(
              side: MaterialStateProperty.all(
                BorderSide(color: isDark ? Colors.white60 : AppColors.green3),
              ),
              hintText: 'Search for services',
              leading: Icon(Icons.search),
              shape: MaterialStateProperty.all(
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
              ),
              shadowColor: WidgetStateColor.transparent,
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SizedBox(height: Dimensions.height20),
                    serviceCard('Automobiles', 'Find your perfect car', () {
                      Get.toNamed(AppRoutes.automobileForm);
                    }),
                    SizedBox(height: Dimensions.height20),
                    serviceCard(
                      'Beauty',
                      'Make up, Lash Techs, Nail techs, Hair Stylists and more',
                      () {
                        Get.toNamed(AppRoutes.beautyForm);
                      },
                    ),

                    SizedBox(height: Dimensions.height20),
                    serviceCard(
                      'Car Hire',
                      'Short Hire, Long Hire, Airport Pickup, Travel Hire',
                      () {
                        Get.toNamed(AppRoutes.carHireForm);
                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    serviceCard('Car Parts', 'Find all car Parts', () {
                      Get.toNamed(AppRoutes.carPartsForm);
                    }),
                    SizedBox(height: Dimensions.height20),
                    serviceCard('Carpentry', 'Carpentry Services', () {
                      Get.toNamed(AppRoutes.carpentryForm);

                    }),
                    SizedBox(height: Dimensions.height20),

                    serviceCard(
                      'Cleaning Services',
                      'Cleaning Services',
                      () {
                        Get.toNamed(AppRoutes.cleaningForm);

                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    serviceCard('Electrician', 'Electrical Services', () {
                      Get.toNamed(AppRoutes.electricianForm);

                    }),
                    SizedBox(height: Dimensions.height20),
                    serviceCard(
                      'Employment',
                      'Get and Post Job availability requests',
                      () {
                        Get.toNamed(AppRoutes.employmentScreen);

                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    serviceCard(
                      'Event Management Services',
                      'Catering Services, Event Planner, Bakers and Hiring services',
                          () {
                        Get.toNamed(AppRoutes.cateringForm);

                      },
                    ),
                    SizedBox(height: Dimensions.height20),

                    serviceCard(
                      'Hospitality',
                      'Apartment, Hotel, Gym and Spa Services',
                          () {
                        Get.toNamed(AppRoutes.hospitalityForm);

                      },
                    ),
                    SizedBox(height: Dimensions.height20),

                    serviceCard('Mechanic', 'Automobile Repairs', () {
                      Get.toNamed(AppRoutes.mechanicForm);

                    }),
                    SizedBox(height: Dimensions.height20),
                    serviceCard(
                      'Media',
                      'Photography, Videography, Drone Pilot, Cinematography',
                      () {
                        Get.toNamed(AppRoutes.mediaForm);

                      },
                    ),
                    SizedBox(height: Dimensions.height20),
                    serviceCard('Plumbing', 'Plumbing Services', () {
                      Get.toNamed(AppRoutes.plumbingForm);

                    }),
                    SizedBox(height: Dimensions.height20),
                    serviceCard('Real Estate', 'Sales, Rentals, Short let', () {
                      Get.toNamed(AppRoutes.realEstateForm);
                    }),
                    SizedBox(height: Dimensions.height20),
                    serviceCard(
                      'Software Development',
                      'Product Design, Development, Frontend & Backend Services',
                      () {
                        Get.toNamed(AppRoutes.softwareDevelopmentForm);

                      },
                    ),
                    SizedBox(height: Dimensions.height50),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget serviceCard(String title, String subtitle, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor =
        Theme.of(context).textTheme.bodyLarge?.color ?? Colors.black;
    final iconColor = Theme.of(context).iconTheme.color ?? Colors.black;

    return InkWell(
      onTap: onTap,
      child: Container(
        height: Dimensions.height50,
        width: double.maxFinite,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(color: isDark ? Colors.white.withOpacity(0.2) : Colors.black45.withOpacity(0.2)),
          ),
          // borderRadius: BorderRadius.circular(Dimensions.radius5),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: textColor,
                      fontSize: Dimensions.font17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    subtitle,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: textColor,
                      fontSize: Dimensions.font12,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_circle_right_outlined, color: iconColor),
          ],
        ),
      ),
    );
  }
}
