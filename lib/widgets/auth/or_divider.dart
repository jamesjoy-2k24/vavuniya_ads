import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class OrDivider extends StatelessWidget {
  final String heading;
  const OrDivider({super.key, required this.heading});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.textSecondary,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              heading,
              style: AppTypography.caption,
            ),
          ),
          Expanded(
            child: Container(
              height: 1,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
