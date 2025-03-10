import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/home/categories.dart';
import 'package:vavuniya_ads/widgets/home/favorites.dart';
import 'package:vavuniya_ads/widgets/home/first_time_notice.dart';
import 'package:vavuniya_ads/widgets/home/recent_ads.dart';
import 'package:vavuniya_ads/widgets/home/search_bar.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: Stack(
        children: [
          // Full-screen Background
          const AppBg(),
          // Main Layout
          Column(
            children: [
              // Fixed Header with Title, Search, and Logout
              HomeSearchBar(),
              // Scrollable Content
              Expanded(
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  child: Container(
                    color: Colors.transparent, // Background handled by AppBg
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const FirstTimeNotice(),
                        const Categories(),
                        const Favorites(),
                        const RecentAds(),
                        const SizedBox(height: 32), // Bottom padding
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Loading Overlay (Optional)
          Obx(
            () => controller.isLoading.value && controller.ads.isEmpty
                ? Container(
                    color: Colors.black.withOpacity(0.3),
                    child: const Center(
                      child: CircularProgressIndicator(color: AppColors.dark),
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }
}
