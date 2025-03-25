import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/ad/ad_card.dart';
import 'package:vavuniya_ads/core/controllers/home/recent_ads_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class RecentAds extends StatelessWidget {
  const RecentAds({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RecentAdsController());

    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Text(
              "Recent Ads",
              style: AppTypography.subheading.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: AppColors.textPrimary,
              ),
            ).animate().fadeIn(duration: 500.ms),
          ),

          // Wrapping the GridView in a Flexible Widget
          Flexible(
            child: Obx(
              () {
                if (controller.isLoading.value) {
                  return const Center(
                    child: CircularProgressIndicator(color: AppColors.dark),
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
                      controller: controller.scrollController,
                      physics: const AlwaysScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 ads per row
                        crossAxisSpacing: 12, // Space between columns
                        mainAxisSpacing: 12, // Space between rows
                        childAspectRatio: 0.75, // Adjust size ratio
                      ),
                      itemCount: controller.recentAds.length +
                          (controller.hasMore.value ? 1 : 0),
                      itemBuilder: (context, index) {
                        if (index == controller.recentAds.length) {
                          return const Center(
                            child: CircularProgressIndicator(
                                color: AppColors.dark),
                          );
                        }
                        final ad = controller.recentAds[index];
                        return AdCard(
                          ad: ad,
                          showFavoriteToggle: true,
                          animationIndex: index,
                        );
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
