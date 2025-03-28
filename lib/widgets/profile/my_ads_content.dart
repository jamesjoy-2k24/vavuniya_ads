import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/my_ads_controller.dart';
import 'package:vavuniya_ads/widgets/profile/my_ads/ad_card.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class MyAdsContent extends StatelessWidget {
  const MyAdsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final MyAdsController adsController = Get.put(MyAdsController());

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 16),
          Expanded(
            child: Obx(() {
              if (adsController.isLoading.value) {
                return const Center(
                    child: CircularProgressIndicator(color: AppColors.blue));
              } else if (adsController.error.value.isNotEmpty) {
                return _buildErrorState(adsController.error.value);
              } else if (adsController.ads.isEmpty) {
                return _buildEmptyState();
              } else {
                return ListView.builder(
                  itemCount: adsController.ads.length,
                  itemBuilder: (context, index) {
                    return AdCard(ad: adsController.ads[index]);
                  },
                );
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.blue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "My Ads",
        textAlign: TextAlign.center,
        style: AppTypography.subheading.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 12),
          Text(error,
              style: AppTypography.body.copyWith(color: AppColors.error)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Get.find<MyAdsController>().refreshAds(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.list_alt, size: 48, color: AppColors.grey),
          const SizedBox(height: 12),
          Text("No ads posted yet",
              style: AppTypography.body.copyWith(color: AppColors.grey)),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => Get.toNamed('/add-ad'),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
            child: const Text("Post an Ad"),
          ),
        ],
      ),
    );
  }
}
