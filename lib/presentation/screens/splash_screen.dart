import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/splash_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/splash_logo.dart';
import 'package:vavuniya_ads/widgets/app/loading_indicator.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Initialize controller with GetX
    final SplashController controller = Get.put(SplashController());

    // Start splash logic
    controller.startSplash();

    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LogoWithText(),
                  SizedBox(height: 30),
                  LoadingIndicator(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
