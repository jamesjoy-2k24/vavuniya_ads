import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/core/controllers/home/favorites_controller.dart';
import 'package:vavuniya_ads/widgets/product/app_card.dart';

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
      body: // Ensure this matches your file
          Obx(
        () => controller.isLoading.value
            ? const SizedBox(
                height: 150,
                child: Center(
                    child: CircularProgressIndicator(color: AppColors.dark)),
              )
            : controller.favorites.isEmpty
                ? const SizedBox(
                    height: 150,
                    child: Center(
                        child: Text("No favorites yet",
                            style: TextStyle(color: AppColors.grey))),
                  )
                : SizedBox(
                    height: 150,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: controller.favorites.length > 5
                          ? 5
                          : controller.favorites.length,
                      itemBuilder: (context, index) {
                        final favorite = controller.favorites[index];
                        return AdCard(
                          ad: favorite,
                          animationIndex: index,
                        );
                      },
                    ),
                  ),
      ),
    );
  }
}
