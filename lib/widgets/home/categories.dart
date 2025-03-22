import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/core/controllers/home/categories_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CategoriesController());

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Categories",
            style: AppTypography.subheading.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ).animate().fadeIn(duration: 500.ms),
          const SizedBox(height: 12),
          Obx(
            () => controller.isLoading.value
                ? const SizedBox(
                    height: 120,
                    child: Center(
                        child:
                            CircularProgressIndicator(color: AppColors.dark)),
                  )
                : controller.categories.isEmpty
                    ? const SizedBox(
                        height: 120,
                        child: Center(
                          child: Text("No categories available",
                              style: TextStyle(color: AppColors.grey)),
                        ),
                      )
                    : _buildCategories(controller),
          ),
        ],
      ),
    );
  }

  Widget _buildCategories(CategoriesController controller) {
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

    final displayedCategories = controller.categories.take(7).map((cat) {
      final style = categoryStyles[cat['name']] ??
          {
            "icon": Icons.category,
            "bgColor": AppColors.lightGrey,
            "iconColor": AppColors.dark,
          };
      return {
        "id": cat['id'].toString(),
        "name": cat['name'],
        "icon": style["icon"],
        "bgColor": style["bgColor"],
        "iconColor": style["iconColor"],
      };
    }).toList();

    const moreItem = {
      "id": null,
      "name": "More",
      "icon": Icons.more_horiz,
      "bgColor": AppColors.lightGrey,
      "iconColor": AppColors.dark,
    };

    return SizedBox(
      height: 120,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: displayedCategories.length + 1,
        itemBuilder: (context, index) {
          final isMore = index == displayedCategories.length;
          final category = isMore ? moreItem : displayedCategories[index];

          return GestureDetector(
            onTap: () => isMore
                ? Get.toNamed("/categories")
                : controller.selectCategory(category["id"] as String),
            child: Container(
              width: 80,
              margin: const EdgeInsets.only(right: 12),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: category["bgColor"] as Color,
                    child: Icon(
                      category["icon"] as IconData,
                      color: category["iconColor"] as Color,
                      size: 32,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    category["name"] as String,
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.textPrimary,
                    ),
                    textAlign: TextAlign.center,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          )
              .animate()
              .fadeIn(
                duration: 400.ms,
                delay: (index * 100).ms,
              )
              .scale(
                begin: const Offset(0.8, 0.8),
                end: const Offset(1.0, 1.0),
                duration: 400.ms,
                delay: (index * 100).ms,
                curve: Curves.easeOut,
              );
        },
      ),
    );
  }
}
