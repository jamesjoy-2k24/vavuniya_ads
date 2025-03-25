import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/ad/ad_card.dart'; // Import your AdCard widget
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/core/controllers/home/recent_ads_controller.dart';
import 'package:vavuniya_ads/widgets/app/loading_indicator.dart'; // Assuming the controller is set up correctly

class RecentAds extends StatelessWidget {
  const RecentAds({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecentAdsController()); // Get the controller

    return SafeArea(
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Section Title
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                "Recent Ads",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),

            // Infinite Scrollable GridView for Recent Ads
            Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: LoadingIndicator(),
                  );
                } else if (controller.recentAds.isEmpty) {
                  return const Center(
                    child: Text("No recent ads",
                        style: TextStyle(color: AppColors.grey)),
                  );
                } else {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16.0),
                    child: GridView.builder(
                      shrinkWrap:
                          true, // Allow GridView to take only as much space as it needs
                      controller: controller.scrollController,
                      physics:
                          const NeverScrollableScrollPhysics(), // Disable internal scrolling
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 ads per row
                        crossAxisSpacing: 12, // Space between columns
                        mainAxisSpacing: 12, // Space between rows
                        childAspectRatio: 0.75, // Adjust size ratio
                      ),
                      itemCount: controller.recentAds.length +
                          (controller.hasMore.value
                              ? 1
                              : 0), // Add a loader if more ads are being fetched
                      itemBuilder: (context, index) {
                        if (index == controller.recentAds.length) {
                          // Show a loading indicator at the end of the list
                          return const Center(
                            child: LoadingIndicator(),
                          );
                        }
                        final ad = controller.recentAds[index];
                        return AdCard(
                          ad: ad,
                          height: 200,
                          width: double.infinity,
                          showFavoriteToggle: false,
                          showDescription: false,
                          animationIndex: index,
                          isFavorite: false,
                          onFavoriteToggle: () {},
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
