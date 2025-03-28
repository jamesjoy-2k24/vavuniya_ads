import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/profile/my_ads/confirm_delete_dialog.dart';
import 'package:vavuniya_ads/widgets/profile/my_ads/confirm_undo_dialog.dart';
import 'package:vavuniya_ads/widgets/profile/my_ads/edit_ad_dialog.dart';

class AdCard extends StatefulWidget {
  final Map<String, dynamic> ad;

  const AdCard({super.key, required this.ad});

  @override
  _AdCardState createState() => _AdCardState();
}

class _AdCardState extends State<AdCard> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _fadeAnimation =
        Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isDeleted = widget.ad['is_deleted'] == 1; // Check as integer

    return FadeTransition(
      opacity: _fadeAnimation,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDeleted ? Colors.grey.shade300 : Colors.white,
        child: ListTile(
          leading: widget.ad['imageUrl'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    widget.ad['imageUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Icon(
                        Icons.image,
                        size: 50,
                        color: AppColors.grey),
                  ),
                )
              : const Icon(Icons.image, size: 50, color: AppColors.grey),
          title: Text(
            widget.ad['title'] ?? 'Untitled Ad',
            style: AppTypography.body.copyWith(
              fontWeight: FontWeight.bold,
              color: isDeleted ? Colors.grey : Colors.black,
            ),
          ),
          subtitle: Text(
            widget.ad['description'] ?? 'No description',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(
              color: isDeleted ? Colors.grey.shade700 : AppColors.textSecondary,
            ),
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (!isDeleted)
                IconButton(
                  icon: const Icon(Icons.edit, color: AppColors.blue),
                  onPressed: () => Get.dialog(EditAdDialog(ad: widget.ad)),
                ),
              IconButton(
                icon: Icon(
                  isDeleted ? Icons.restore : Icons.delete,
                  color: isDeleted ? AppColors.green : AppColors.error,
                ),
                onPressed: () => Get.dialog(
                  isDeleted
                      ? ConfirmUndoDialog(adId: widget.ad['id'])
                      : ConfirmDeleteDialog(adId: widget.ad['id']),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
