import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
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
      body: Stack(children: [
        AppBg(),
        SafeArea(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            LogoWithText(),
            SizedBox(height: 30),
            LoadingIndicator(),
          ],
        )),
      ]),
    );
  }
}
