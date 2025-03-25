import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/widgets/ad/ad_card.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/core/controllers/home/favorites_controller.dart';

class Favorites extends StatelessWidget {
  const Favorites({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FavoritesController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          Obx(
            () => controller.isLoading.value
                ? const SizedBox(
                    height: 240, // Adjusted for dynamic height
                    child: Center(
                        child:
                            CircularProgressIndicator(color: AppColors.dark)),
                  )
                : controller.favorites.isEmpty
                    ? const SizedBox(
                        height: 240,
                        child: Center(
                            child: Text("No favorites yet",
                                style: TextStyle(color: AppColors.grey))),
                      )
                    : SizedBox(
                        height: 240,
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller.favorites.length > 7
                              ? 7
                              : controller.favorites.length,
                          itemBuilder: (context, index) {
                            final favorite = controller.favorites[index];
                            return AdCard(
                              ad: favorite,
                              showFavoriteToggle: false,
                              showDescription: false,
                              animationIndex: index,
                            );
                          },
                        ),
                      ),
          ),
        ],
      ),
    );
  }
}
