import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/profile/add_ad_sheet.dart';

class AddPostScreen extends StatelessWidget {
  const AddPostScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          SafeArea(
            child: Column(
              children: [
                AppBar(
                  title: const Text("Post an Ad"),
                  backgroundColor: AppColors.secondary,
                  elevation: 0,
                  leading: IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                ),
                Expanded(
                  child: AddAdSheet(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
