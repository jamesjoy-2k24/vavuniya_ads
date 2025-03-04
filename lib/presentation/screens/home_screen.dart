import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/home/categories.dart';
import 'package:vavuniya_ads/widgets/home/favorites.dart';
import 'package:vavuniya_ads/widgets/home/first_time_notice.dart';
import 'package:vavuniya_ads/widgets/home/search_bar.dart';
import 'package:vavuniya_ads/widgets/product/app_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());

    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          SafeArea(
            child: Column(
              children: [
                HomeSearchBar(),
                FirstTimeNotice(),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Categories(),
                        Favorites(),

                        // Recent Posted Ads Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Recent Posted Ads",
                            style: AppTypography.heading.copyWith(fontSize: 20),
                          ),
                        ),
                        _buildRecentAds(controller),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.snackbar("Info", "Post ad feature coming soon!");
        },
        backgroundColor: AppColors.dark,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildRecentAds(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.ads.isEmpty
                ? const Center(child: Text("No recent ads available"))
                : GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 16,
                      mainAxisSpacing: 16,
                    ),
                    itemCount: controller.ads.length,
                    itemBuilder: (context, index) {
                      final ad = controller.ads[index];
                      return AdCard(
                        title: ad['title'],
                        price: double.parse(ad['price']),
                        item_condition: ad['item_condition'],
                        imageUrl:
                            ad['images'].isNotEmpty ? ad['images'][0] : null,
                        location: ad['location'],
                        onTap: () {
                          Get.snackbar("Info", "Ad details coming soon!");
                        },
                      );
                    },
                  ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return BottomNavigationBar(
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.dark,
      unselectedItemColor: Colors.grey,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(icon: Icon(Icons.category), label: "Category"),
        BottomNavigationBarItem(icon: Icon(Icons.chat), label: "Chat"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
      onTap: (index) {
        switch (index) {
          case 0: // Home
            break;
          case 1:
            Get.snackbar("Info", "Category screen coming soon!");
            break;
          case 2:
            Get.snackbar("Info", "Chat screen coming soon!");
            break;
          case 3:
            Get.snackbar("Info", "Profile screen coming soon!");
            break;
        }
      },
    );
  }
}
