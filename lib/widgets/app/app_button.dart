import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_spacing.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/app/loading_indicator.dart';

class AppButton extends StatelessWidget {
  final String text;
  final bool isLoading;
  final Color color;
  final Color textColor;
  final double? width;
  final double? height;
  final VoidCallback onPressed;
  final Widget? loadingWidget;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.color = Colors.black,
    this.textColor = Colors.white,
    this.width,
    this.height,
    this.loadingWidget,
    this.fullWidth = true,
    Padding? icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: fullWidth ? double.infinity : width,
        height: height ?? 50,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: color,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.small),
          ),
          onPressed: isLoading ? null : onPressed, // Disable when loading
          child: isLoading
              ? loadingWidget ??
                  const LoadingIndicator()
              : Text(
                  text,
                  style: AppTypography.button.copyWith(color: textColor),
                ),
        ),
      ),
    );
  }
}
