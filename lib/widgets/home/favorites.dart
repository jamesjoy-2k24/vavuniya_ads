import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/widgets/ad/ad_card.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/core/controllers/home/favorites_controller.dart';
import 'package:vavuniya_ads/widgets/app/loading_indicator.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final FavoritesController controller = Get.put(FavoritesController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Favorites",
                style: AppTypography.subheading.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ).animate().fadeIn(duration: 500.ms),
              TextButton(
                onPressed: () => Get.toNamed("/favorites"),
                child: const Text("See All",
                    style: TextStyle(color: AppColors.blue)),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Favorites List
          Obx(
            () {
              if (controller.isLoading.value) {
                return const SizedBox(
                  height: 240,
                  child: Center(
                    child: LoadingIndicator(  ),
                  ),
                );
              }

              if (controller.favorites.isEmpty) {
                return const SizedBox(
                  height: 240,
                  child: Center(
                    child: Text(
                      "No favorites yet",
                      style: TextStyle(color: AppColors.grey),
                    ),
                  ),
                );
              }

              return SizedBox(
                height: 220,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.favorites.length.clamp(0, 7),
                  itemBuilder: (context, index) {
                    final favorite = controller.favorites[index];

                    return AdCard(
                      ad: favorite,
                      width: 250,
                      showFavoriteToggle: false,
                      showDescription: false,
                      animationIndex: index,
                      isFavorite: true,
                      onFavoriteToggle: () => (),
                    );
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
