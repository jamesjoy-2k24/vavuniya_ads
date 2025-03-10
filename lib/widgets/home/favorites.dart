import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/product/app_card.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Favorite Ads",
                style: AppTypography.subheading.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              TextButton(
                onPressed: () {
                  Get.snackbar(
                    "Favorites",
                    "More favorites coming soon!",
                    snackPosition: SnackPosition.TOP,
                    backgroundColor: AppColors.dark,
                    colorText: Colors.white,
                  );
                },
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  backgroundColor: Colors.blue.withOpacity(0.1),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "More",
                      style: AppTypography.caption.copyWith(
                        color: Colors.blue,
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(width: 4),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 14,
                      color: Colors.blue,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: 200, // Adjusted for new AdCard height
          child: Obx(
            () => controller.isLoading.value
                ? _buildLoadingState()
                : controller.favoriteAds.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        itemCount: controller.favoriteAds.length,
                        itemBuilder: (context, index) {
                          final ad = controller.favoriteAds[index];
                          return Padding(
                            padding: const EdgeInsets.only(right: 12.0),
                            child: SizedBox(
                              width: 150, // Slightly wider for better spacing
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
                                location: ad['location'],
                                isVerified: ad['verified'] ?? false,
                                isFavorite:
                                    true, // Favorites are inherently favorited
                                onTap: () {
                                  Get.snackbar(
                                    "Ad: ${ad['title']}",
                                    "Price: LKR ${ad['price']} | Location: ${ad['location']}",
                                    snackPosition: SnackPosition.TOP,
                                  );
                                },
                                onFavoriteToggle: () {
                                  // Placeholder for removing from favorites
                                  Get.snackbar(
                                    "Favorite",
                                    "Remove from favorites coming soon!",
                                    snackPosition: SnackPosition.TOP,
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      ),
          ),
        ),
      ],
    );
  }

  Widget _buildLoadingState() {
    return const Center(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(color: AppColors.dark),
          SizedBox(width: 16),
          Text(
            "Loading favorites...",
            style: TextStyle(fontSize: 16, color: AppColors.grey),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.favorite_border,
            size: 40,
            color: Colors.grey,
          ),
          const SizedBox(height: 8),
          Text(
            "No favorite ads yet",
            style: AppTypography.body.copyWith(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tap the heart to save ads!",
            style: AppTypography.caption.copyWith(
              fontSize: 12,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
