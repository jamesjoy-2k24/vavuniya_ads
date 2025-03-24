import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/ad/ad_card.dart';
import 'package:vavuniya_ads/core/controllers/home/favorites_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class FavoritesScreen extends StatelessWidget {
  static const String route = "/favorites";

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Favorites",
          style: AppTypography.subheading.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.secondary,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.dark))
            : controller.favorites.isEmpty
                ? const Center(
                    child: Text("No favorites yet",
                        style: TextStyle(color: AppColors.grey)))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: controller.favorites.length,
                    itemBuilder: (context, index) {
                      final favorite = controller.favorites[index];
                      return AdCard(
                        ad: favorite,
                        showFavoriteToggle: true,
                        showDescription: true,
                        animationIndex: index,
                      );
                    },
                  ),
      ),
    );
  }
}
