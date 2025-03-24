import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/core/controllers/home/favorites_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class AdCard extends StatelessWidget {
  final Map<String, dynamic> ad;
  final VoidCallback? onTap;
  final VoidCallback? onEdit;
  final VoidCallback? onDelete;
  final bool showFavoriteToggle; // Controls heart icon
  final bool showDescription; // Controls description visibility
  final int animationIndex;

  const AdCard({
    super.key,
    required this.ad,
    this.onTap,
    this.onEdit,
    this.onDelete,
    this.showFavoriteToggle = true,
    this.showDescription = true, // Default to true
    this.animationIndex = 0,
  });

  @override
  Widget build(BuildContext context) {
    final favoritesController = Get.find<FavoritesController>();

    return GestureDetector(
      onTap: onTap ?? () => Get.toNamed("/ad/${ad['ad_id']}"),
      child: Container(
        width: 200,
        margin: const EdgeInsets.only(right: 12, bottom: 12),
        child: Card(
          elevation: 4,
          shadowColor: Colors.black.withOpacity(0.1),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
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
                        image: ad['images'] != null && ad['images'].isNotEmpty
                            ? DecorationImage(
                                image: NetworkImage(
                                    'http://localhost/vavuniya_ads/images/${ad['images']}'),
                                fit: BoxFit.cover,
                                onError: (exception, stackTrace) =>
                                    const Icon(Icons.broken_image),
                              )
                            : null,
                      ),
                      child: ad['images'] == null || ad['images'].isEmpty
                          ? const Icon(Icons.image,
                              size: 50, color: AppColors.grey)
                          : null,
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
                          size: 20,
                        ),
                        onPressed: () {
                          final isFavorite = favoritesController.favorites.any(
                              (f) =>
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
                            Colors.transparent
                          ],
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 8,
                    left: 8,
                    child: Row(
                      children: [
                        const Icon(Icons.access_time,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          favoritesController.timeAgo(ad['created_at'] ?? ''),
                          style: AppTypography.caption
                              .copyWith(color: Colors.white, fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      ad['title'],
                      style: AppTypography.body.copyWith(
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (showDescription) ...[
                      const SizedBox(height: 4),
                      Text(
                        ad['description'],
                        style: AppTypography.caption.copyWith(
                          fontSize: 12,
                          color: AppColors.grey,
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "LKR ${NumberFormat.currency(symbol: '', decimalDigits: 0).format(double.parse(ad['price'].toString()))}",
                          style: AppTypography.body.copyWith(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.blue,
                          ),
                        ),
                        Row(
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: AppColors.grey),
                            const SizedBox(width: 4),
                            Text(
                              ad['location'] ?? 'Unknown',
                              style: AppTypography.caption.copyWith(
                                fontSize: 12,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(duration: 800.ms)
            .scale(begin: Offset(0.95, 0.95), end: Offset(1.0, 1.0)),
      ),
    );
  }
}
