import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
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
                    height: 150,
                    child: Center(
                        child:
                            CircularProgressIndicator(color: AppColors.dark)),
                  )
                : controller.favorites.isEmpty
                    ? const SizedBox(
                        height: 150,
                        child: Center(
                          child: Text("No favorites yet",
                              style: TextStyle(color: AppColors.grey)),
                        ),
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
                            return GestureDetector(
                              onTap: () =>
                                  Get.toNamed("/ad/${favorite['ad_id']}"),
                              child: Container(
                                width: 200,
                                margin: const EdgeInsets.only(right: 12),
                                child: Card(
                                  elevation: 2,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12)),
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          favorite['title'],
                                          style: AppTypography.body.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          favorite['description'],
                                          style: AppTypography.caption
                                              .copyWith(fontSize: 14),
                                          maxLines: 2,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const Spacer(),
                                        Text(
                                          "LKR ${favorite['price']}",
                                          style: AppTypography.body.copyWith(
                                            color: AppColors.blue,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            )
                                .animate()
                                .fadeIn(
                                  duration: 400.ms,
                                  delay: (index * 100).ms,
                                )
                                .scale(
                                  begin: const Offset(0.9, 0.9),
                                  end: const Offset(1.0, 1.0),
                                  duration: 400.ms,
                                  delay: (index * 100).ms,
                                  curve: Curves.easeOut,
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
