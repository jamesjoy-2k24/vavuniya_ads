import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/core/controllers/home/categories_controller.dart';

class CategoriesScreen extends StatelessWidget {
  static const String route = "/categories";

  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CategoriesController>();

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "All Categories",
          style: AppTypography.subheading.copyWith(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        backgroundColor: AppColors.secondary,
        elevation: 0,
      ),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.dark))
            : controller.categories.isEmpty
                ? const Center(
                    child: Text("No categories available",
                        style: TextStyle(color: AppColors.grey)),
                  )
                : _buildFullCategories(controller),
      ),
    );
  }

  Widget _buildFullCategories(CategoriesController controller) {
    const categoryStyles = {
      "Electronics": {
        "icon": Icons.devices,
        "bgColor": Color(0xFFDEDCFF),
        "iconColor": Color(0xFF00188D)
      },
      "Vehicles": {
        "icon": Icons.directions_car,
        "bgColor": Color(0xFFDAFAF8),
        "iconColor": Color(0xFF00C7BE)
      },
      "Furniture": {
        "icon": Icons.chair,
        "bgColor": Color(0xFFFFEFD6),
        "iconColor": Color(0xFFE65100)
      },
      "Fashion": {
        "icon": Icons.checkroom,
        "bgColor": Color(0xFFFFF0E1),
        "iconColor": Color(0xFFF06292)
      },
      "Food & Dining": {
        "icon": Icons.restaurant,
        "bgColor": Color(0xFFFFF9E1),
        "iconColor": Color(0xFF795548)
      },
      "Sports & Fitness": {
        "icon": Icons.fitness_center,
        "bgColor": Color(0xFFE8F5E9),
        "iconColor": Color(0xFF2E7D32)
      },
      "Health & Beauty": {
        "icon": Icons.spa,
        "bgColor": Color(0xFFF8E1E1),
        "iconColor": Color(0xFFD81B60)
      },
      "Education": {
        "icon": Icons.school,
        "bgColor": Color(0xFFE1F5FE),
        "iconColor": Color(0xFF0288D1)
      },
      "Services": {
        "icon": Icons.build,
        "bgColor": Color(0xFFE0F7FA),
        "iconColor": Color(0xFF00ACC1)
      },
      "Jobs": {
        "icon": Icons.work,
        "bgColor": Color(0xFFE0F2F1),
        "iconColor": Color(0xFF004D40)
      },
      "Property": {
        "icon": Icons.home,
        "bgColor": Color(0xFFE8EAF6),
        "iconColor": Color(0xFF3949AB)
      },
      "Pets": {
        "icon": Icons.pets,
        "bgColor": Color(0xFFF1E8FF),
        "iconColor": Color(0xFF6A1B9A)
      },
      "Travel": {
        "icon": Icons.flight,
        "bgColor": Color(0xFFE1F5FE),
        "iconColor": Color(0xFF0277BD)
      },
      "Books": {
        "icon": Icons.book,
        "bgColor": Color(0xFFF5F5F5),
        "iconColor": Color(0xFF424242)
      },
      "Toys & Games": {
        "icon": Icons.toys,
        "bgColor": Color(0xFFFFF8E1),
        "iconColor": Color(0xFFFBC02D)
      },
    };

    return GridView.builder(
      padding: const EdgeInsets.all(16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 0.8,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: controller.categories.length,
      itemBuilder: (context, index) {
        final category = controller.categories[index];
        final style = categoryStyles[category['name']] ??
            {
              "icon": Icons.category,
              "bgColor": AppColors.lightGrey,
              "iconColor": AppColors.dark,
            };

        return GestureDetector(
          onTap: () {
            controller.selectCategory(category['id'].toString());
            Get.back(); // Return to HomeScreen with filter applied
          },
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircleAvatar(
                radius: 35,
                backgroundColor: style["bgColor"] as Color,
                child: Icon(
                  style["icon"] as IconData,
                  color: style["iconColor"] as Color,
                  size: 40,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                category['name'],
                style: AppTypography.caption.copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        )
            .animate()
            .fadeIn(
              duration: 400.ms,
              delay: (index * 50).ms,
            )
            .scale(
              begin: const Offset(0.9, 0.9),
              end: const Offset(1.0, 1.0),
              duration: 400.ms,
              delay: (index * 50).ms,
              curve: Curves.easeOut,
            );
      },
    );
  }
}
