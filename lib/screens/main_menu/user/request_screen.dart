import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fyndr/routes/routes.dart';
import 'package:fyndr/utils/app_constants.dart';
import 'package:fyndr/utils/colors.dart';
import 'package:fyndr/utils/dimensions.dart';
import 'package:fyndr/widgets/custom_appbar.dart';
import 'package:fyndr/widgets/custom_button.dart';
import 'package:fyndr/widgets/request_card.dart';

import '../../../controllers/request_controller.dart';
import '../../../helpers/global_loader_controller.dart';
import '../../../widgets/empty_state_widget.dart';

class RequestScreen extends StatefulWidget {
  const RequestScreen({super.key});

  @override
  State<RequestScreen> createState() => _RequestScreenState();
}

class _RequestScreenState extends State<RequestScreen> with TickerProviderStateMixin,  AutomaticKeepAliveClientMixin{
  final requestController = Get.find<RequestController>();
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // requestController.fetchUserRequests(showLoader: false);
    });
  }

@override
bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final isDark = theme.brightness == Brightness.dark;
    final bgColor = theme.scaffoldBackgroundColor;
    final primaryColor = theme.colorScheme.primary;
    final fadedText = textTheme.bodyMedium?.color?.withOpacity(0.6) ?? Colors.grey;

    return Scaffold(
      backgroundColor: bgColor,
      body: Container(
        height: Dimensions.screenHeight,
        width: Dimensions.screenWidth,
        padding: EdgeInsets.symmetric(horizontal: Dimensions.width20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CustomAppbar(
              title: 'My Requests',
              centerTitle: true,
              actionIcon: InkWell(
                onTap: () => Get.toNamed(AppRoutes.notificationScreen),
                child: Icon(
                  CupertinoIcons.bell_fill,
                  color: textTheme.bodyLarge?.color,
                ),
              ),
            ),
            SizedBox(height: Dimensions.height30),
            Row(
              children: [
                Expanded(
                  child: CustomButton(
                    text: 'Create New Request',
                    onPressed: () => Get.offAllNamed(AppRoutes.bottomNav),
                  ),
                ),
                SizedBox(width: Dimensions.width10),
                InkWell(
                  onTap: () async => await requestController.fetchUserRequests(),
                  borderRadius: BorderRadius.circular(Dimensions.radius10),
                  child: Container(
                    padding: EdgeInsets.all(Dimensions.width15),
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(Dimensions.radius10),
                    ),
                    child: Icon(Icons.refresh, color: textTheme.bodyLarge?.color),
                  ),
                ),
              ],
            ),
            SizedBox(height: Dimensions.height30),

            // Tab Bar
            TabBar(
              controller: _tabController,
              labelColor: theme.colorScheme.primary,
              unselectedLabelColor: fadedText,
              indicatorColor: primaryColor,
              tabs: const [
                Tab(text: 'Live Requests'),
                Tab(text: 'Awaiting Payment'),
              ],
            ),
            SizedBox(height: Dimensions.height15),

            // Tab Views
            Expanded(
              child: Obx(() {
                final allRequests = requestController.userRequests;

                if (allRequests.isEmpty) {
                  return const EmptyState(message: 'No requests yet');
                }

                final liveRequests = allRequests
                    .where((r) => r.transactionStatus == 'completed')
                    .toList()
                  ..sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime(0)) ?? 0);

                final unpaidRequests = allRequests
                    .where((r) => r.transactionStatus != 'completed')
                    .toList()
                  ..sort((a, b) => b.createdAt?.compareTo(a.createdAt ?? DateTime(0)) ?? 0);

                final tabViews = [liveRequests, unpaidRequests];

                return RefreshIndicator(
                  color: primaryColor,
                  onRefresh: () async => await requestController.fetchUserRequests(),
                  child: TabBarView(
                    controller: _tabController,
                    children: tabViews.map((requests) {
                      if (requests.isEmpty) {
                        return const Center(child: EmptyState(message: "No requests found"));
                      }

                      return ListView.separated(
                        physics: const BouncingScrollPhysics(),
                        padding: EdgeInsets.zero,
                        itemCount: requests.length,
                        separatorBuilder: (_, __) => SizedBox(height: Dimensions.height10),
                        itemBuilder: (_, index) {
                          final req = requests[index];
                          return RequestCard(
                            title: req.title ?? '',
                            category: req.category ?? '',
                            date: req.createdAt,
                            serviceType: req.category ?? '',
                            requestId: req.id ?? '',
                          );
                        },
                      );
                    }).toList(),
                  ),
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}