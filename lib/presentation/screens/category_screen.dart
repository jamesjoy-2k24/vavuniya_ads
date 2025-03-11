import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class CategoryScreen extends StatelessWidget {
  const CategoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.put(HomeController());
    final Map<String, Map<String, dynamic>> categoryStyles =
        Get.arguments as Map<String, Map<String, dynamic>>? ?? {};

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Categories",
          style: AppTypography.heading.copyWith(fontSize: 20),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          const AppBg(),
          Obx(() {
            // Show loading only if categories are being fetched initially
            if (controller.isLoading.value && controller.categories.isEmpty) {
              return const Center(child: CircularProgressIndicator());
            }

            final List<Map<String, dynamic>> availableCategories =
                controller.categories.isNotEmpty
                    ? controller.categories
                    : categoryStyles.keys
                        .map((name) => {'id': null, 'name': name})
                        .toList();

            if (availableCategories.isEmpty) {
              return const Center(child: Text("No categories available"));
            }

            return GridView.count(
              padding: const EdgeInsets.all(16),
              crossAxisCount: 4,
              childAspectRatio: 0.8,
              mainAxisSpacing: 12,
              crossAxisSpacing: 12,
              children: availableCategories.map((cat) {
                final catName = cat['name'] as String;
                final style = categoryStyles[catName] ??
                    {
                      "icon": Icons.category,
                      "bgColor": AppColors.lightGrey,
                      "iconColor": AppColors.dark,
                    };
                return _buildCategoryItem(
                  context,
                  catName,
                  style["icon"] as IconData,
                  style["bgColor"] as Color,
                  style["iconColor"] as Color,
                  () {
                    final filterValue = cat['id']?.toString() ?? catName;
                    controller.filterByCategory(filterValue);
                    Get.back();
                  },
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryItem(
    BuildContext context,
    String name,
    IconData icon,
    Color bgColor,
    Color iconColor,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: bgColor,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 28,
                backgroundColor: Colors.transparent,
                child: Icon(icon, color: iconColor, size: 30),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              name,
              style: AppTypography.caption.copyWith(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
