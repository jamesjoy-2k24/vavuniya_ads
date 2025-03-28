import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/config/app_theme.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/config/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Vavuniya Ads',
      theme: AppTheme.lightTheme,
      // darkTheme: ThemeData.dark(),
      initialRoute: AppRoutes.splash,
      getPages: AppRouter.routes,
      debugShowCheckedModeBanner: false,
      defaultTransition: Transition.fade,
      unknownRoute: AppRouter.unknownRoute,
    );
  }
}
