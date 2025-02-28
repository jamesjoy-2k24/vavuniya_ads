import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class Skip extends StatelessWidget {
  final VoidCallback onSkip;

  const Skip({super.key, required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topRight,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: TextButton(
          onPressed: onSkip,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Next",
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary),
              ),
              Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}
