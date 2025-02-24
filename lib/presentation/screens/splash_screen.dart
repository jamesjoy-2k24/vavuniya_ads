import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/splash_logo.dart';
import 'package:vavuniya_ads/widgets/app/loading_indicator.dart';
import 'package:vavuniya_ads/core/controllers/splash_controller.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late SplashController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SplashController(context);
    _controller.startSplash();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF00E3FD), Color(0xFFC4F6FF)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoWithText(),
            SizedBox(height: 30),
            LoadingIndicator(),
          ],
        ),
      ),
    );
  }
}
