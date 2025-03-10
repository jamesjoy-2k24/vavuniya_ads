import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/product/app_card.dart';

class RecentAds extends StatelessWidget {
  const RecentAds({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final ScrollController scrollController = ScrollController();

    scrollController.addListener(() {
      if (scrollController.position.pixels >=
              scrollController.position.maxScrollExtent - 200 &&
          !controller.isLoadingMore.value) {
        controller.loadMoreAds();
      }
    });

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Text(
            "Recent Ads",
            style: AppTypography.subheading.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ),
        Obx(
          () => controller.isLoading.value && controller.ads.isEmpty
              ? _buildLoadingState()
              : controller.ads.isEmpty
                  ? _buildEmptyState()
                  : Column(
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height *
                              0.6, // Dynamic height
                          child: ListView.builder(
                            controller: scrollController,
                            physics: const AlwaysScrollableScrollPhysics(),
                            itemCount: controller.ads.length,
                            itemBuilder: (context, index) {
                              final ad = controller.ads[index];
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0, vertical: 8.0),
                                child: AdCard(
                                  title: ad['title'] ?? 'Untitled',
                                  price: double.tryParse(
                                          ad['price']?.toString() ?? '0') ??
                                      0.0,
                                  itemCondition: ad['item_condition'] ??
                                      ad['condition'] ??
                                      'Unknown',
                                  imageUrl: ad['images']?.isNotEmpty == true
                                      ? ad['images'][0]
                                      : null,
                                  location: ad['location'] ?? 'Unknown',
                                  isVerified: ad['verified'] ?? false,
                                  isFavorite: controller.favoriteAds
                                      .any((fav) => fav['id'] == ad['id']),
                                  onTap: () {
                                    Get.toNamed("/ad-detail", arguments: ad);
                                  },
                                  onFavoriteToggle: () {
                                    Get.snackbar(
                                      "Favorite",
                                      "${ad['title']} favorite toggle coming soon!",
                                      snackPosition: SnackPosition.TOP,
                                    );
                                  },
                                ),
                              );
                            },
                          ),
                        ),
                        if (controller.isLoadingMore.value)
                          const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: CircularProgressIndicator(
                                  color: AppColors.dark),
                            ),
                          ),
                      ],
                    ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Padding(
      padding: EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: AppColors.dark),
            SizedBox(height: 16),
            Text(
              "Loading recent ads...",
              style: TextStyle(fontSize: 16, color: AppColors.grey),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.hourglass_empty,
              size: 40,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              "No recent ads available",
              style: AppTypography.body.copyWith(
                fontSize: 16,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              "Check back later for new listings!",
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
