import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyndr/utils/colors.dart';

import '../../routes/routes.dart';
import '../../utils/dimensions.dart';

class OnBoard {
  final String image, title, description;

  OnBoard({
    required this.image,
    required this.title,
    required this.description,
  });
}

final List<OnBoard> demoData = [
  OnBoard(
    image: "assets/images/onboard1.png",
    title: "Welcome to Fyndr",
    description:
        "Find verified help fast — property agents, car rentals, cleaning, and more.",
  ),
  OnBoard(
    image: "assets/images/onboard2.png",
    title: "Post what you need",
    description: "Fill a quick form and let trusted merchants come to you.",
  ),
  OnBoard(
    image: "assets/images/onboard3.png",
    title: "Chat Safely On App",
    description: "We keep communication secure — no spam, just real solutions.",
  ),
];

// OnBoardingScreen
class OnBoardingScreen extends StatefulWidget {
  const OnBoardingScreen({super.key});

  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  late PageController _pageController;
  int _pageIndex = 0;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 5), (Timer timer) {
      if (_pageIndex < 2) {
        _pageIndex++;
      } else {
        _pageIndex = 2;
      }

      _pageController.animateToPage(
        _pageIndex,
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeIn,
      );
    });
  }

  @override
  void dispose() {
    // Dispose everything
    _pageController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  @override
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),

        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                onPageChanged: (index) {
                  setState(() {
                    _pageIndex = index;
                  });
                },
                itemCount: demoData.length,
                controller: _pageController,
                itemBuilder: (context, index) => OnBoardContent(
                  title: demoData[index].title,
                  description: demoData[index].description,
                  image: demoData[index].image,
                ),
              ),
            ),

            // Dot Indicator
            Padding(
              padding: EdgeInsets.only(bottom: Dimensions.height50),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  demoData.length,
                      (index) => Padding(
                    padding: EdgeInsets.only(right: Dimensions.width10),
                    child: DotIndicator(
                      isActive: index == _pageIndex,
                      activeColor: theme.colorScheme.primary,
                      inactiveColor: theme.dividerColor,
                    ),
                  ),
                ),
              ),
            ),

            SizedBox(height: Dimensions.height10),

            // Next button
            if (_pageIndex < 2)
              SizedBox(
                height: Dimensions.height12 * 10.85,
                child: InkWell(
                  onTap: () {
                    _pageIndex++;
                    _pageController.animateToPage(
                      _pageIndex,
                      duration: const Duration(milliseconds: 350),
                      curve: Curves.easeIn,
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      horizontal: Dimensions.width15,
                      vertical: Dimensions.height15,
                    ),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: theme.iconTheme.color ?? Colors.black),
                    ),
                    child: Icon(
                      CupertinoIcons.right_chevron,
                      color: theme.iconTheme.color,
                      size: Dimensions.iconSize20,
                    ),
                  ),
                ),
              ),

            // Action buttons
            if (_pageIndex == 2)
              Column(
                children: [
                  InkWell(
                    onTap: () {
                      _timer?.cancel();
                      Get.offAllNamed(AppRoutes.merchantAuthScreen);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height18),
                      height: Dimensions.height50,
                      width: Dimensions.width360,
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.colorScheme.primary),
                        borderRadius: BorderRadius.circular(Dimensions.radius10),
                      ),
                      child: Center(
                        child: Text(
                          'Sign in as Merchant',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: theme.colorScheme.primary,
                            fontSize: Dimensions.font18,
                          ),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      _timer?.cancel();
                      Get.offAllNamed(AppRoutes.userAuthScreen);
                    },
                    child: Container(
                      margin: EdgeInsets.only(bottom: Dimensions.height18),
                      height: Dimensions.height50,
                      width: Dimensions.width360,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(Dimensions.radius10),
                      ),
                      child: Center(
                        child: Text(
                          'Sign in as Customer',
                          style: TextStyle(
                            fontFamily: "Poppins",
                            color: theme.colorScheme.onPrimary,
                            fontSize: Dimensions.font18,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),

            SizedBox(height: Dimensions.height50 + 20),
          ],
        ),
      ),
    );
  }
}

// OnBoarding area widget
class OnBoardContent extends StatelessWidget {
  const OnBoardContent({
    super.key,
    required this.image,
    required this.title,
    required this.description,
  });

  final String image;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(height: Dimensions.height65),
        InkWell(
          onTap: () {
            print('tapped');
            Get.offAllNamed(AppRoutes.guestBottomNav);
          },
          child: Text(
            'Continue as Guest',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w500,
              fontSize: Dimensions.font14,
              decoration: TextDecoration.underline,
            ),
          ),
        ),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: Dimensions.height100),
              Container(
                height: Dimensions.height100 * 2,
                width: Dimensions.width100 * 2,
                decoration: BoxDecoration(
                  color: theme.cardColor,
                  borderRadius: BorderRadius.circular(Dimensions.radius15),
                  boxShadow: [
                    BoxShadow(
                      color: theme.shadowColor.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    )
                  ],
                ),
                child: Image.asset(fit: BoxFit.cover, image),
              ),
              const Spacer(),
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textTheme.bodyLarge?.color,
                  fontSize: Dimensions.font22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              SizedBox(height: Dimensions.height10),
              Text(
                description,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: theme.textTheme.bodyMedium?.color,
                  fontSize: Dimensions.font17,
                  fontWeight: FontWeight.w400,
                ),
              ),
              const Spacer(),
            ],
          ),
        ),
      ],
    );
  }
}

// Dot indicator widget
class DotIndicator extends StatelessWidget {
  const DotIndicator({
    this.isActive = false,
    this.activeColor,
    this.inactiveColor,
    super.key,
  });

  final bool isActive;
  final Color? activeColor;
  final Color? inactiveColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      height: 8,
      width: isActive ? 24 : 8,
      decoration: BoxDecoration(
        color: isActive
            ? activeColor ?? theme.colorScheme.primary
            : inactiveColor ?? theme.dividerColor,
        border: isActive
            ? null
            : Border.all(
          color: inactiveColor ?? theme.colorScheme.primary,
        ),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }
}
