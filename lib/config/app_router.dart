import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
// import 'package:vavuniya_ads/presentation/screens/ad/ad_detail_screen.dart';
import 'package:vavuniya_ads/presentation/screens/ad/category_screen.dart';
import 'package:vavuniya_ads/presentation/screens/home_screen.dart';
import 'package:vavuniya_ads/presentation/screens/user/profile_screen.dart';
import 'package:vavuniya_ads/presentation/screens/splash_screen.dart';
import 'package:vavuniya_ads/presentation/screens/user/add_post_screen.dart';
import 'package:vavuniya_ads/presentation/screens/user/favorites_screen.dart';
import 'package:vavuniya_ads/presentation/screens/user/chat_screen.dart';
import 'package:vavuniya_ads/presentation/screens/welcome_screen.dart';
import 'package:vavuniya_ads/presentation/screens/auth/otp_screen.dart';
import 'package:vavuniya_ads/presentation/screens/auth/login_screen.dart';
import 'package:vavuniya_ads/presentation/screens/auth/register_final.dart';
import 'package:vavuniya_ads/presentation/screens/auth/register_screen.dart';

class AppRouter {
  static final List<GetPage> routes = [
    GetPage(
      name: AppRoutes.otp,
      page: () {
        final args = Get.arguments as Map<String, dynamic>?;
        final phoneNumber = args?['phone'] ?? '';
        return OtpScreen(phoneNumber: phoneNumber);
      },
    ),
    GetPage(name: AppRoutes.home, page: () => HomeScreen()),
    GetPage(name: AppRoutes.splash, page: () => SplashScreen()),
    GetPage(name: AppRoutes.welcome, page: () => WelcomeScreen()),
    GetPage(name: AppRoutes.profile, page: () => ProfileScreen()),
    GetPage(name: AppRoutes.register, page: () => RegisterScreen()),
    GetPage(name: AppRoutes.login, page: () => const LoginScreen()),
    GetPage(name: AppRoutes.post, page: () => const AddPostScreen()),
    GetPage(name: AppRoutes.chat, page: () => const MessagesScreen()),
    GetPage(name: AppRoutes.favorites, page: () => const FavoritesScreen()),
    GetPage(name: AppRoutes.categories, page: () => const CategoriesScreen()),
    GetPage(name: AppRoutes.registerFinal, page: () => const RegisterFinal()),

    // User profile routes
    GetPage(
        name: '/my-ads', page: () => const PlaceholderScreen(title: 'My Ads')),
    GetPage(
        name: '/settings',
        page: () => const PlaceholderScreen(title: 'Settings')),
    // Admin profile routes
    GetPage(
        name: '/admin/ads',
        page: () => const PlaceholderScreen(title: 'Manage Ads')),
    GetPage(
        name: '/admin/users',
        page: () => const PlaceholderScreen(title: 'Manage Users')),
    GetPage(
        name: '/admin/categories',
        page: () => const PlaceholderScreen(title: 'Categories')),
    GetPage(
        name: '/admin/reports',
        page: () => const PlaceholderScreen(title: 'Reports')),
    GetPage(
        name: '/admin/settings',
        page: () => const PlaceholderScreen(title: 'Admin Settings')),

    // GetPage(name: AppRoutes.adDetail, page: () => const AdDetailScreen()),
  ];

  static GetPage unknownRoute = GetPage(
    name: '/404',
    page: () => Scaffold(body: Center(child: Text('404 - Page Not Found'))),
  );
}

class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('$title Coming Soon')),
    );
  }
}
