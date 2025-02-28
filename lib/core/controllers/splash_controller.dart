import 'dart:async';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/config/app_routes.dart';

class SplashController extends GetxController {
  void startSplash() {
    Timer(const Duration(seconds: 3), () async {
      try {
        final prefs = await SharedPreferences.getInstance();
        bool isLoggedIn = prefs.getBool('isLoggedIn') ?? false;
        bool isOnboardingComplete =
            prefs.getBool('isOnboardingComplete') ?? false;

        if (isLoggedIn) {
          Get.offNamed(AppRoutes.home);
        } else if (isOnboardingComplete) {
          Get.offNamed(AppRoutes.register);
        } else {
          Get.offNamed(AppRoutes.welcome);
        }
      } catch (e) {
        Get.offNamed(AppRoutes.welcome);
      }
    });
  }
}
