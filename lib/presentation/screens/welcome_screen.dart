import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/welcome_screen/skip.dart';
import 'package:vavuniya_ads/widgets/welcome_screen/get_start.dart';
import 'package:vavuniya_ads/widgets/welcome_screen/feature_list.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  Future<void> _completeOnboarding(String route) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isOnboardingComplete', true);
    Get.offNamed(route);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          SafeArea(
            child: Column(
              children: [
                // Skip Button
                Skip(
                  onSkip: () => _completeOnboarding(AppRoutes.register),
                ),
                SizedBox(height: 80),

                // Heading
                Text(
                  "Welcome to Vavuniya Ads",
                  style: AppTypography.heading,
                ),

                // Body
                WelcomeScreenFeature(),
                GetStart(
                  onGetStarted: () => _completeOnboarding(AppRoutes.register),
                  onLogin: () => _completeOnboarding(AppRoutes.login),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
