import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/core/controllers/home/favorites_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:intl/intl.dart';

class AdCard extends StatelessWidget {
  final Map<String, dynamic> ad;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showFavoriteToggle;
  final bool showDescription;
  final int animationIndex;

  const AdCard({
    super.key,
    required this.ad,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showFavoriteToggle = true,
    this.showDescription = true,
    this.animationIndex = 0,
  });

  String _daysSincePosted() {
    final createdAt =
        DateTime.tryParse(ad['created_at'] ?? '') ?? DateTime.now();
    final difference = DateTime.now().difference(createdAt).inDays;
    return '$difference days ago';
  }

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();

    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed("/ad/${ad['id']}"),
      child: Container(
        width: 240,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        child: Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image Section
              Stack(
                children: [
                  ClipRRect(
                    borderRadius:
                        const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      height: 110,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: AppColors.lightGrey,
                        image: (ad['images'] != null && ad['images'].isNotEmpty)
                            ? DecorationImage(
                                image: NetworkImage(
                                    'http://localhost/vavuniya_ads/images/${ad['images']}'),
                                fit: BoxFit.cover,
                                onError: (_, __) => const Center(
                                  child: Icon(Icons.image,
                                      size: 50, color: AppColors.grey),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),

                  // Dark Gradient Overlay
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Colors.black.withOpacity(0.6),
                            Colors.transparent,
                          ],
                        ),
                      ),
                    ),
                  ),

                  // Post Date
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          _daysSincePosted(),
                          style: AppTypography.caption
                              .copyWith(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),

                  // Favorite & Edit/Delete Buttons
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Row(
                      children: [
                        if (showFavoriteToggle)
                          Obx(() {
                            final isFavorite = favoritesController.favorites
                                .any((f) =>
                                    f['ad_id'].toString() ==
                                    ad['id'].toString());

                            return IconButton(
                              icon: Icon(
                                  isFavorite
                                      ? Icons.favorite
                                      : Icons.favorite_border,
                                  color: Colors.red,
                                  size: 20),
                              onPressed: () {
                                isFavorite
                                    ? favoritesController
                                        .removeFavorite(ad['id'].toString())
                                    : favoritesController
                                        .addFavorite(ad['id'].toString());
                              },
                            );
                          }),
                        if (onEdit != null)
                          IconButton(
                              icon: const Icon(Icons.edit,
                                  color: AppColors.blue, size: 20),
                              onPressed: onEdit),
                        if (onDelete != null)
                          IconButton(
                              icon: const Icon(Icons.delete,
                                  color: AppColors.error, size: 20),
                              onPressed: onDelete),
                      ],
                    ),
                  ),
                ],
              ),

              // Content Section
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad['title'] ?? 'Untitled',
                      style: AppTypography.body.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 15,
                          color: AppColors.textPrimary),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showDescription)
                      Padding(
                        padding: const EdgeInsets.only(top: 4.0),
                        child: Text(
                          ad['description'] ?? '',
                          style: AppTypography.caption.copyWith(
                              fontSize: 12, color: AppColors.grey, height: 1.2),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        const Icon(Icons.category,
                            size: 14, color: AppColors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            ad['category_name'] ?? 'Uncategorized',
                            style: AppTypography.caption
                                .copyWith(fontSize: 12, color: AppColors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "LKR ${NumberFormat.currency(symbol: '', decimalDigits: 0).format(double.tryParse(ad['price']?.toString() ?? '0') ?? 0)}",
                            style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                                color: AppColors.blue),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.location_on,
                            size: 14, color: AppColors.grey),
                        Expanded(
                          child: Text(
                            ad['location'] ?? 'Unknown',
                            style: AppTypography.caption
                                .copyWith(fontSize: 12, color: AppColors.grey),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(duration: 400.ms, delay: (animationIndex * 100).ms);
  }
}
