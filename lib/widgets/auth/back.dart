import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class Back extends StatelessWidget {
  final VoidCallback? onPressed; // Custom action
  final String text; // Optional text
  final IconData icon; // Customizable icon
  final double iconSize; // Adjustable icon size
  final double textSize; // Adjustable text size
  final Color color; // Custom color
  final Alignment alignment; // Flexible alignment
  final bool showText; // Toggle text visibility

  const Back({
    super.key,
    this.onPressed,
    this.text = "Back",
    this.icon = Icons.arrow_back_ios_new,
    this.iconSize = 16,
    this.textSize = 14,
    this.color = AppColors.textPrimary,
    this.alignment = Alignment.topLeft,
    this.showText = true,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: TextButton(
        onPressed: onPressed ?? () => Get.back(), // Default to Get.back()
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: iconSize,
              color: color,
            ),
            if (showText) ...[
              const SizedBox(width: 4),
              Text(
                text,
                style: TextStyle(
                  fontSize: textSize,
                  color: color,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
