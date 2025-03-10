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
    final HomeController controller = Get.find<HomeController>();
    final Map<String, Map<String, dynamic>> categoryStyles =
        Get.arguments as Map<String, Map<String, dynamic>>? ?? {};

    final availableCategories = controller.categories.isNotEmpty
        ? controller.categories
        : categoryStyles.keys.toList();

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
              if (controller.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }
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
                  final style = categoryStyles[cat] ??
                      {
                        "icon": Icons.category,
                        "bgColor": AppColors.lightGrey,
                        "iconColor": AppColors.dark,
                      };
                  return _buildCategoryItem(
                    context,
                    cat,
                    style["icon"] as IconData,
                    style["bgColor"] as Color,
                    style["iconColor"] as Color,
                    () {
                      controller.filterByCategory(cat);
                      Get.back();
                    },
                  );
                }).toList(),
              );
            }),
          ],
        ));
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
