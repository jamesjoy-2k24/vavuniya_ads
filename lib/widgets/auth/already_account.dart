import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class AlreadyAccount extends StatelessWidget {
  final String message;
  final String actionText;
  final VoidCallback onTap;

  const AlreadyAccount({
    super.key,
    required this.message,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            message,
            style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
          ),
          SizedBox(width: 5),
          Text(
            actionText,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.link,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
