// widgets/app/ad_card.dart
import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class AdCard extends StatelessWidget {
  final String title;
  final double price;
  final String condition;
  final String? imageUrl;
  final String? location;
  final VoidCallback onTap;

  const AdCard({
    super.key,
    required this.title,
    required this.price,
    required this.condition,
    this.imageUrl,
    this.location,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              // Image (or placeholder)
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: imageUrl != null
                    ? Image.network(imageUrl!,
                        width: 80, height: 80, fit: BoxFit.cover)
                    : Container(
                        width: 80,
                        height: 80,
                        color: Colors.grey[300],
                        child: const Icon(Icons.image, color: Colors.grey),
                      ),
              ),
              const SizedBox(width: 10),
              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.body
                          .copyWith(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "LKR $price",
                      style:
                          AppTypography.caption.copyWith(color: AppColors.dark),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      "$condition${location != null ? ' • $location' : ''}",
                      style: AppTypography.caption
                          .copyWith(color: Colors.grey[700]),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
