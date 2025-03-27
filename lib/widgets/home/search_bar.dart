import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/core/controllers/home/home_search_controller.dart';

class HomeSearchBar extends StatelessWidget {
  const HomeSearchBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HomeSearchController());

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Obx(
                () => controller.isTyping.value
                    ? IconButton(
                        icon: const Icon(Icons.arrow_back_ios,
                            color: AppColors.dark),
                        onPressed: controller.clearSearch,
                      )
                    : const SizedBox.shrink(),
              ),
              Expanded(
                child: TextField(
                  controller: controller.searchController,
                  decoration: InputDecoration(
                    hintText: 'Search in Vavuniya Ads...',
                    hintStyle: AppTypography.caption
                        .copyWith(color: AppColors.textSecondary),
                    prefixIcon: const Icon(Icons.search, color: AppColors.dark),
                    suffixIcon: Obx(
                      () => controller.isTyping.value
                          ? IconButton(
                              icon: const Icon(Icons.clear,
                                  color: AppColors.dark),
                              onPressed: controller.clearSearch,
                            )
                          : IconButton(
                              icon: const Icon(Icons.filter_list,
                                  color: AppColors.dark),
                              onPressed: () =>
                                  _showFilterDialog(context, controller),
                            ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: AppColors.lightGrey,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 12.0, horizontal: 16.0),
                  ),
                  style:
                      AppTypography.body.copyWith(color: AppColors.textPrimary),
                  textInputAction: TextInputAction.search,
                  onSubmitted: controller.searchAds,
                  onChanged: controller.updateSuggestions,
                ),
              ),
              Obx(
                () => controller.isTyping.value
                    ? Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: ElevatedButton(
                          onPressed: () => controller
                              .searchAds(controller.searchController.text),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.dark,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                          ),
                          child: const Text("Search",
                              style: TextStyle(color: Colors.white)),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
          Obx(
            () => controller.isTyping.value
                ? Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (controller.recentSearches.isNotEmpty) ...[
                          const Text("Recent Searches",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8.0,
                            children: controller.recentSearches
                                .map((search) => GestureDetector(
                                      onTap: () =>
                                          controller.selectSearch(search),
                                      child: Chip(
                                          label: Text(search),
                                          backgroundColor: AppColors.lightGrey),
                                    ))
                                .toList(),
                          ),
                          const SizedBox(height: 8),
                        ],
                        if (controller.suggestions.isNotEmpty) ...[
                          const Text("Suggestions",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                          const SizedBox(height: 4),
                          Wrap(
                            spacing: 8.0,
                            children: controller.suggestions
                                .map((suggestion) => GestureDetector(
                                      onTap: () =>
                                          controller.selectSearch(suggestion),
                                      child: Chip(
                                          label: Text(suggestion),
                                          backgroundColor: AppColors.lightGrey),
                                    ))
                                .toList(),
                          ),
                        ],
                      ],
                    ),
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog(
      BuildContext context, HomeSearchController controller) {
    String? categoryId = controller.selectedCategory.value.isNotEmpty
        ? controller.selectedCategory.value
        : null;
    double? minPrice =
        controller.minPrice.value > 0 ? controller.minPrice.value : null;
    double? maxPrice = controller.maxPrice.value != double.infinity
        ? controller.maxPrice.value
        : null;

    // Mock categories (fetch from API later)
    final categories = [
      {'id': '1', 'name': 'Electronics'},
      {'id': '2', 'name': 'Vehicles'},
      {'id': '3', 'name': 'Furniture'}
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Filter Ads"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<String>(
              value: categoryId,
              hint: const Text("Select Category"),
              items: categories
                  .map((c) =>
                      DropdownMenuItem(value: c['id'], child: Text(c['name']!)))
                  .toList(),
              onChanged: (value) => categoryId = value,
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Min Price"),
              keyboardType: TextInputType.number,
              controller:
                  TextEditingController(text: minPrice?.toString() ?? ''),
              onChanged: (value) => minPrice = double.tryParse(value),
            ),
            TextField(
              decoration: const InputDecoration(labelText: "Max Price"),
              keyboardType: TextInputType.number,
              controller:
                  TextEditingController(text: maxPrice?.toString() ?? ''),
              onChanged: (value) => maxPrice = double.tryParse(value),
            ),
          ],
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              controller.setCategoryFilter(
                  categoryId: categoryId,
                  minPrice: minPrice,
                  maxPrice: maxPrice);
              Navigator.pop(context);
            },
            child: const Text("Apply"),
          ),
        ],
      ),
    );
  }
}
