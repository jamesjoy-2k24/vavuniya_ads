import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/product/app_card.dart';

class Favorites extends StatelessWidget {
  Favorites({super.key});

  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Favorite Ads",
                  style: AppTypography.subheading,
                ),
                GestureDetector(
                  onTap: () {
                    Get.snackbar("Sorry",
                        "it's on working!"); // Navigate to full favorites page
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "more",
                        style: AppTypography.subheading.copyWith(
                          color:
                              Colors.blue, // Highlight "more" for tap feedback
                        ),
                      ),
                      const SizedBox(width: 5),
                      const Icon(Icons.arrow_forward_ios,
                          size: 16, color: Colors.blue),
                    ],
                  ),
                ),
              ],
            ),
          ),
          _buildFavoriteAds(controller),
        ],
      ),
    );
  }
}

Widget _buildFavoriteAds(HomeController controller) {
  // Dummy ads for testing
  final List<Map<String, dynamic>> dummyFavoriteAds = [
    {
      "title": "Used Toyota Corolla",
      "price": "15000.00",
      "item_condition": "Used",
      "images": ["https://via.placeholder.com/150?text=Car"],
      "location": "Vavuniya Town",
    },
    {
      "title": "iPhone 13 Pro",
      "price": "800.00",
      "item_condition": "Like New",
      "images": ["https://via.placeholder.com/150?text=Phone"],
      "location": "Nedunkeni",
    },
    {
      "title": "Apartment for Rent",
      "price": "300.00",
      "item_condition": "New",
      "images": ["https://via.placeholder.com/150?text=Apartment"],
      "location": "Kandy Road",
    },
    {
      "title": "Laptop Dell XPS",
      "price": "1200.00",
      "item_condition": "Used",
      "images": ["https://via.placeholder.com/150?text=Laptop"],
      "location": "Vavuniya Central",
    },
  ];

  return SizedBox(
    height: 200,
    child: Obx(
      () => controller.isLoading.value
          ? const Center(child: CircularProgressIndicator())
          : controller.favoriteAds.isEmpty
              ? ListView.builder(
                  // Use dummy data if controller has no favorites
                  scrollDirection: Axis.horizontal,
                  itemCount: dummyFavoriteAds.length,
                  itemBuilder: (context, index) {
                    final ad = dummyFavoriteAds[index];
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
                          Get.snackbar(
                            "Ad: ${ad['title']}",
                            "Price: ${ad['price']} | Location: ${ad['location']}",
                            snackPosition: SnackPosition.TOP,
                          );
                        },
                      ),
                    );
                  },
                )
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
                          Get.snackbar(
                            "Ad: ${ad['title']}",
                            "Price: ${ad['price']} | Location: ${ad['location']}",
                            snackPosition: SnackPosition.TOP,
                          );
                        },
                      ),
                    );
                  },
                ),
    ),
  );
}
