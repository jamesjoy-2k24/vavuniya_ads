import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/core/controllers/home/favorites_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class AdCard extends StatelessWidget {
  final Map<String, dynamic> ad;
  final VoidCallback? onTap; // Navigate to ad details
  final VoidCallback? onEdit; // For MyAds
  final VoidCallback? onDelete; // For MyAds
  final bool showFavoriteToggle; // Show/hide favorite icon
  final int animationIndex; // For staggered animations

  const AdCard({
    super.key,
    required this.ad,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showFavoriteToggle = true,
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();

    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed("/ad/${ad['ad_id']}"),
      child: Container(
        width: 200, // Adjustable for horizontal lists
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        child: Card(
          elevation: 2,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image (placeholder or network image if available)
              ClipRRect(
                borderRadius:
                    const BorderRadius.vertical(top: Radius.circular(12)),
                child: Container(
                  height: 120,
                  width: double.infinity,
                  color: AppColors.lightGrey, // Placeholder
                  child: ad['images'] != null && ad['images'].isNotEmpty
                      ? Image.network(
                          'http://localhost/vavuniya_ads/images/${ad['images']}',
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.broken_image, size: 50),
                        )
                      : const Icon(Icons.image,
                          size: 50, color: AppColors.grey),
                ),
              ),
              // Content
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad['title'],
                      style: AppTypography.body
                          .copyWith(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ad['description'],
                      style: AppTypography.caption
                          .copyWith(fontSize: 14, color: AppColors.grey),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "LKR ${ad['price']}",
                          style: AppTypography.body.copyWith(
                            color: AppColors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        if (showFavoriteToggle)
                          Obx(
                            () => IconButton(
                              icon: Icon(
                                favoritesController.favorites.any((f) =>
                                        f['ad_id'].toString() ==
                                        ad['ad_id'].toString())
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: Colors.red,
                              ),
                              onPressed: () {
                                final isFavorite = favoritesController.favorites
                                    .any((f) =>
                                        f['ad_id'].toString() ==
                                        ad['ad_id'].toString());
                                if (isFavorite) {
                                  favoritesController
                                      .removeFavorite(ad['ad_id'].toString());
                                } else {
                                  favoritesController
                                      .addFavorite(ad['ad_id'].toString());
                                }
                              },
                            ),
                          ),
                      ],
                    ),
                    if (onEdit != null || onDelete != null) ...[
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          if (onEdit != null)
                            IconButton(
                              icon:
                                  const Icon(Icons.edit, color: AppColors.blue),
                              onPressed: onEdit,
                            ),
                          if (onDelete != null)
                            IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.error),
                              onPressed: onDelete,
                            ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    )
        .animate()
        .fadeIn(
          duration: 400.ms,
          delay: (animationIndex * 100).ms,
        )
        .scale(
          begin: const Offset(0.9, 0.9),
          end: const Offset(1.0, 1.0),
          duration: 400.ms,
          delay: (animationIndex * 100).ms,
          curve: Curves.easeOut,
        );
  }
}
