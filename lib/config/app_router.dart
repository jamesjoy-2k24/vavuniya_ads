import 'app_routes.dart';
import 'package:flutter/material.dart';
import 'package:vavuniya_ads/presentation/screens/home_screen.dart';
import 'package:vavuniya_ads/presentation/screens/splash_screen.dart';
import 'package:vavuniya_ads/presentation/screens/welcome_screen.dart';
import 'package:vavuniya_ads/presentation/screens/auth/login_screen.dart';
import 'package:vavuniya_ads/presentation/screens/auth/register_screen.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppRoutes.home:
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case AppRoutes.login:
        return MaterialPageRoute(builder: (_) => LoginScreen());
      case AppRoutes.splash:
        return MaterialPageRoute(builder: (_) => SplashScreen());
      case AppRoutes.welcome:
        return MaterialPageRoute(builder: (_) => WelcomeScreen());
      case AppRoutes.register:
        return MaterialPageRoute(builder: (_) => RegisterScreen());
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('404 - Page Not Found')),
          ),
        );
    }
  }
}
