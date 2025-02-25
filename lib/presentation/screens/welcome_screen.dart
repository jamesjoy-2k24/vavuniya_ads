import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/welcome_screen/skip.dart';
import 'package:vavuniya_ads/widgets/welcome_screen/get_start.dart';
import 'package:vavuniya_ads/widgets/welcome_screen/feature_list.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

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
                Skip(),
                SizedBox(height: 80),

                // Heading
                Text(
                  "Welcome to Vavuniya Ads",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.w900),
                ),

                // Body
                WelcomeScreenFeature(),
                GetStart(),
              ],
            ),
          )
        ],
      ),
    );
  }
}
