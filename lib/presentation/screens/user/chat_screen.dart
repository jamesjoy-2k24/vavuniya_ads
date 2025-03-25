import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/home/bottom_bar.dart';

class MessagesScreen extends StatelessWidget {
  const MessagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          Column(
            children: [
              AppBar(
                title: const Text("Messages"),
                backgroundColor: AppColors.secondary,
                elevation: 0,
              ),
              Expanded(
                child: Center(
                  child: Text(
                    "Messages Coming Soon",
                    style: AppTypography.subheading.copyWith(
                      color: AppColors.textPrimary,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
              const BottomBar(),
            ],
          ),
        ],
      ),
    );
  }
}
