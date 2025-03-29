import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/home/bottom_bar.dart';
import 'package:vavuniya_ads/widgets/profile/add_ad_sheet.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          Column(
            children: [
              AppBar(
                title: const Text("Post an Ad"),
                backgroundColor: AppColors.secondary,
                elevation: 0,
              ),
              AddAdSheet(),
              const BottomBar(),
            ],
          ),
        ],
      ),
    );
  }
}
