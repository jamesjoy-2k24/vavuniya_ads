import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/ad/ad_card.dart';
import 'package:vavuniya_ads/core/controllers/home/favorites_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/loading_indicator.dart';
import 'package:vavuniya_ads/widgets/home/bottom_bar.dart';

class FavoritesScreen extends StatelessWidget {
  static const String route = "/favorites";

  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<FavoritesController>();

    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          Column(
            children: [
              AppBar(
                title: const Text("Favorites"),
                backgroundColor: AppColors.secondary,
                elevation: 0,
              ),
              Expanded(
                child: Obx(
                  () => controller.isLoading.value
                      ? const Center(child: LoadingIndicator())
                      : controller.favorites.isEmpty
                          ? const Center(
                              child: Text("No favorites yet",
                                  style: TextStyle(color: AppColors.grey)))
                          : Padding(
                              padding: const EdgeInsets.all(16),
                              child: GridView.builder(
                                gridDelegate:
                                    const SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 16,
                                  mainAxisSpacing: 16,
                                  childAspectRatio: 0.7,
                                ),
                                itemCount: controller.favorites.length,
                                itemBuilder: (context, index) {
                                  final favorite = controller.favorites[index];
                                  return AdCard(
                                    ad: favorite,
                                    width: double.infinity,
                                    showFavoriteToggle: true,
                                    showDescription: false,
                                    animationIndex: index,
                                    isFavorite: true,
                                    onFavoriteToggle: () =>
                                        controller.removeFavorite(
                                            favorite['id'].toString()),
                                    actions: [
                                      IconButton(
                                        icon: const Icon(Icons.delete,
                                            color: AppColors.error, size: 20),
                                        onPressed: () =>
                                            controller.removeFavorite(
                                                favorite['id'].toString()),
                                      ),
                                    ],
                                  );
                                },
                              ),
                            ),
                ),
              )
            ],
          )
        ],
      ),
      bottomNavigationBar: const BottomBar(),
    );
  }
}
