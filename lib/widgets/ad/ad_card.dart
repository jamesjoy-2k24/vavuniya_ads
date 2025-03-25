import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:intl/intl.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

enum CardVariant { favorite, recent, myAds, total }

class AdCard extends StatelessWidget {
  final Map<String, dynamic> ad;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final List<Widget> actions;
  final bool isFavorite;
  final VoidCallback onFavoriteToggle;
  final bool showFavoriteToggle;
  final bool showDescription;
  final int animationIndex;
  final double? width;
  final double? height;
  final CardVariant variant;

  const AdCard({
    super.key,
    required this.ad,
    required this.isFavorite,
    required this.onFavoriteToggle,
    this.onTap,
    this.onDelete,
    this.actions = const [],
    this.showFavoriteToggle = true,
    this.showDescription = true,
    this.animationIndex = 0,
    this.width,
    this.height,
    this.variant = CardVariant.recent,
  });

  String _daysSincePosted() {
    final createdAt =
        DateTime.tryParse(ad['created_at'] ?? '') ?? DateTime.now();
    final difference = DateTime.now().difference(createdAt).inDays;
    return '$difference days ago';
  }

  @override
  Widget build(BuildContext context) {
    final String title = ad['title'] ?? 'Untitled';
    final String description = ad['description'] ?? '';
    final String category = ad['category_name'] ?? 'Uncategorized';
    final String location = ad['location'] ?? 'Unknown';
    final double price = double.tryParse(ad['price']?.toString() ?? '0') ?? 0;
    final String formattedPrice =
        "LKR ${NumberFormat.currency(symbol: '', decimalDigits: 0).format(price)}";

    return GestureDetector(
      onTap: onTap ??
          () => print(
              "Navigating to ad details..."), // Change to Get.toNamed if needed
      child: Container(
        width: width,
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
                clipBehavior: Clip.none,
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
                                onError: (exception, stackTrace) {
                                  print(
                                      'Image load error for ${ad['images']}: $exception');
                                },
                              )
                            : null,
                      ),
                      child: ad['images'] == null || ad['images'].isEmpty
                          ? const Center(
                              child: Icon(Icons.image,
                                  size: 50, color: AppColors.grey))
                          : null,
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
                  // Action Buttons
                  Positioned(
                    top: 4,
                    right: 4,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (showFavoriteToggle)
                          IconButton(
                            icon: Icon(
                              isFavorite
                                  ? Icons.favorite
                                  : Icons.favorite_border,
                              color: Colors.red,
                              size: 20,
                            ),
                            onPressed: onFavoriteToggle,
                          ),
                        ...actions,
                      ],
                    ),
                  ),
                ],
              ),
              // Content Section
              Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
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
                        description,
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
                      children: [
                        Icon(Icons.category, size: 14, color: AppColors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            category,
                            style: AppTypography.caption.copyWith(
                              fontSize: 12,
                              color: AppColors.grey,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Text(
                            formattedPrice,
                            style: AppTypography.body.copyWith(
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                              color: AppColors.blue,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.location_on,
                                size: 14, color: AppColors.grey),
                            const SizedBox(width: 4),
                            Text(
                              location,
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
        ),
      ),
    ).animate().fadeIn(duration: 300.ms, delay: (animationIndex * 50).ms);
  }
}
