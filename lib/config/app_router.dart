import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/presentation/screens/ad_detail_screen.dart';
import 'package:vavuniya_ads/presentation/screens/category_screen.dart';
import 'package:vavuniya_ads/presentation/screens/home_screen.dart';
import 'package:vavuniya_ads/presentation/screens/splash_screen.dart';
import 'package:vavuniya_ads/presentation/screens/welcome_screen.dart';
import 'package:vavuniya_ads/presentation/screens/auth/otp_screen.dart';
import 'package:vavuniya_ads/presentation/screens/auth/login_screen.dart';
import 'package:vavuniya_ads/presentation/screens/auth/register_final.dart';
import 'package:vavuniya_ads/presentation/screens/auth/register_screen.dart';

class AppRouter {
  static final List<GetPage> routes = [
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.welcome, page: () => WelcomeScreen()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
    GetPage(
      name: AppRoutes.otp,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final phoneNumber = args?['phone'] ?? '';
        return OtpScreen(phoneNumber: phoneNumber);
      },
    ),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.categories, page: () => const CategoryScreen()),
    GetPage(name: AppRoutes.registerFinal, page: () => const RegisterFinal()),
    GetPage(name: AppRoutes.adDetail, page: () => const AdDetailScreen()),
  ];

  static GetPage unknownRoute = GetPage(
    name: '/404',
    page: () => Scaffold(body: Center(child: Text('404 - Page Not Found'))),
  );
}
