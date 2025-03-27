import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/my_ads_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class MyAdsContent extends StatefulWidget {
  const MyAdsContent({super.key});

  @override
  State<MyAdsContent> createState() => _MyAdsContentState();
}

class _MyAdsContentState extends State<MyAdsContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final MyAdsController adsController = Get.put(MyAdsController());

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
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
          ),
          const SizedBox(height: 16),
          // Ads List
          Expanded(
            child: Obx(
              () {
                if (adsController.isLoading.value) {
                  return const Center(
                      child: CircularProgressIndicator(color: AppColors.blue));
                } else if (adsController.error.value.isNotEmpty) {
                  return _buildErrorState(adsController.error.value);
                } else if (adsController.ads.isEmpty) {
                  return _buildEmptyState();
                } else {
                  return FadeTransition(
                    opacity: _fadeAnimation,
                    child: ListView.builder(
                      itemCount: adsController.ads.length,
                      itemBuilder: (context, index) {
                        final ad = adsController.ads[index];
                        return _buildAdCard(ad);
                      },
                    ),
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: AppColors.error),
          const SizedBox(height: 16),
          Text(
            error,
            style: AppTypography.body.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
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
          const SizedBox(height: 16),
          Text(
            "No ads posted yet",
            style: AppTypography.body.copyWith(color: AppColors.grey),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Get.toNamed('/add-ad'), // Assuming an add ad route
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
            child: const Text("Post an Ad"),
          ),
        ],
      ),
    );
  }

  Widget _buildAdCard(Map<String, dynamic> ad) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(bottom: 8),
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: ListTile(
          leading: ad['imageUrl'] != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.network(
                    ad['imageUrl'],
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(Icons.image, size: 50, color: AppColors.grey),
          title: Text(
            ad['title'] ?? 'Untitled Ad',
            style: AppTypography.body.copyWith(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            ad['description'] ?? 'No description',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.caption.copyWith(color: AppColors.grey),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.edit, color: AppColors.blue),
            onPressed: () {
              Get.toNamed('/edit-ad', arguments: ad);
            },
          ),
        ),
      ),
    );
  }
}
