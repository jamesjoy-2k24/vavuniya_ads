import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    primaryColor: AppColors.primary,
    scaffoldBackgroundColor: AppColors.background,
    textTheme:  TextTheme(
      displayLarge: AppTypography.heading,
      titleMedium: AppTypography.subheading,
      bodyLarge: AppTypography.body,
      bodySmall: AppTypography.caption,
      labelLarge: AppTypography.button,
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.lightGrey,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      hintStyle: AppTypography.body.copyWith(color: AppColors.textSecondary),
    ),
  );
}
