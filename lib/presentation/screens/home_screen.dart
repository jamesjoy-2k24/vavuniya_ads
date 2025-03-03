import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_text_field.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
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
                // Top Search Bar
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: AppTextField(
                    label: "Search Ads",
                    hintText: "Search by title or description",
                    controller: TextEditingController(),
                    icon: Icons.search,
                    onChanged: (value) => controller.searchAds(value),
                    suffixIcon: IconButton(
                      icon:
                          const Icon(Icons.filter_list, color: AppColors.dark),
                      onPressed: () {
                        Get.snackbar("Info", "Filter feature coming soon!");
                      },
                    ),
                    keyboardType: TextInputType.text,
                  ),
                ),

                // Main Content
                Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // First-Time Notice
                        Obx(
                          () => controller.isFirstVisit.value
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 8.0),
                                  child: Card(
                                    color: AppColors.lightGrey,
                                    child: Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Row(
                                        children: [
                                          const Icon(Icons.store,
                                              color: AppColors.dark, size: 40),
                                          const SizedBox(width: 16),
                                          Expanded(
                                            child: Text(
                                              "Welcome to Vavuniya Ads! Discover amazing deals near you.",
                                              style: AppTypography.body
                                                  .copyWith(fontSize: 16),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),

                        // Categories Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Text(
                            "Categories",
                            style: AppTypography.heading.copyWith(fontSize: 20),
                          ),
                        ),
                        _buildCategories(controller),

                        // Favorite Ads Section
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16.0, vertical: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Favorite Ads",
                                style: AppTypography.heading
                                    .copyWith(fontSize: 20),
                              ),
                              IconButton(
                                icon: const Icon(Icons.arrow_forward_ios,
                                    size: 16),
                                onPressed: () {
                                  Get.snackbar(
                                      "Info", "More favorites coming soon!");
                                },
                              ),
                            ],
                          ),
                        ),
                        _buildFavoriteAds(controller),

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

  Widget _buildCategories(HomeController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        childAspectRatio: 0.8,
        children: List.generate(
          8, // 2 rows x 4 columns
          (index) => index < controller.categories.length
              ? Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.lightGrey,
                      child: Icon(
                        Icons
                            .category, // Placeholder—replace with category-specific icons
                        color: AppColors.dark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.categories[index],
                      style: AppTypography.caption.copyWith(fontSize: 12),
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                )
              : Column(
                  children: [
                    CircleAvatar(
                      radius: 30,
                      backgroundColor: AppColors.lightGrey,
                      child: const Icon(
                        Icons.more_horiz,
                        color: AppColors.dark,
                        size: 24,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "More",
                      style: TextStyle(fontSize: 12),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildFavoriteAds(HomeController controller) {
    return SizedBox(
      height: 200,
      child: Obx(
        () => controller.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : controller.favoriteAds.isEmpty
                ? const Center(child: Text("No favorite ads yet"))
                : ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: controller.favoriteAds.length,
                    itemBuilder: (context, index) {
                      final ad = controller.favoriteAds[index];
                      return SizedBox(
                        width: 150,
                        child: AdCard(
                          title: ad['title'],
                          price: double.parse(ad['price']),
                          item_condition: ad['item_condition'],
                          imageUrl:
                              ad['images'].isNotEmpty ? ad['images'][0] : null,
                          location: ad['location'],
                          onTap: () {
                            Get.snackbar("Info", "Ad details coming soon!");
                          },
                        ),
                      );
                    },
                  ),
      ),
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
