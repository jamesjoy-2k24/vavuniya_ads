import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class Categories extends StatelessWidget {
  const Categories({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            "Categories",
            style: AppTypography.subheading.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        Obx(() {
          if (controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          if (controller.categories.isEmpty && !controller.isLoading.value) {
            return const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(child: Text("No categories available")),
            );
          }
          return _buildCategories(context, controller);
        }),
      ],
    );
  }
}

Widget _buildCategories(BuildContext context, HomeController controller) {
  const categoryStyles = {
    "Vehicles": {
      "icon": Icons.directions_car,
      "bgColor": Color(0xFFDAFAF8),
      "iconColor": Color(0xFF00C7BE),
    },
    "Jobs": {
      "icon": Icons.work,
      "bgColor": Color(0xFFFFEBEE),
      "iconColor": Color(0xFFB71C1C),
    },
    "Services": {
      "icon": Icons.build,
      "bgColor": Color(0xFFE3F2FD),
      "iconColor": Color(0xFF0D47A1),
    },
    "Property": {
      "icon": Icons.home,
      "bgColor": Color(0xFFFFEFD6),
      "iconColor": Color(0xFFE65100),
    },
    "Agriculture": {
      "icon": Icons.local_florist,
      "bgColor": Color(0xFFE1FFE4),
      "iconColor": Color(0xFF1B5E20),
    },
    "Education": {
      "icon": Icons.school,
      "bgColor": Color(0xFFF2DFF4),
      "iconColor": Color(0xFF4A148C),
    },
    "Electronics": {
      "icon": Icons.devices,
      "bgColor": Color(0xFFDEDCFF),
      "iconColor": Color(0xFF00188D),
    },
    "Health": {
      "icon": Icons.local_hospital,
      "bgColor": Color(0xFFF8E1E1),
      "iconColor": Color(0xFFD81B60),
    },
    "Fashion": {
      "icon": Icons.checkroom,
      "bgColor": Color(0xFFFFF0E1),
      "iconColor": Color(0xFFF06292),
    },
    "Food": {
      "icon": Icons.fastfood,
      "bgColor": Color(0xFFFFF9E1),
      "iconColor": Color(0xFF795548),
    },
    "Travel": {
      "icon": Icons.flight,
      "bgColor": Color(0xFFE1F5FF),
      "iconColor": Color(0xFF0277BD),
    },
    "Sports": {
      "icon": Icons.sports_soccer,
      "bgColor": Color(0xFFE8F5E9),
      "iconColor": Color(0xFF2E7D32),
    },
  };

  final availableCategories = controller.categories.isNotEmpty
      ? controller.categories
      : categoryStyles.keys.toList();
  final displayedCategories = availableCategories.take(7).map((cat) {
    final style = categoryStyles[cat] ??
        {
          "icon": Icons.category,
          "bgColor": AppColors.lightGrey,
          "iconColor": AppColors.dark,
        };
    return {
      "name": cat,
      "icon": style["icon"] as IconData,
      "bgColor": style["bgColor"] as Color,
      "iconColor": style["iconColor"] as Color,
    };
  }).toList();

  const moreItem = {
    "name": "More",
    "icon": Icons.more_horiz,
    "bgColor": AppColors.lightGrey,
    "iconColor": AppColors.dark,
  };

  return Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16.0),
    child: GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 4,
      childAspectRatio: 0.8,
      mainAxisSpacing: 12.0,
      crossAxisSpacing: 12.0,
      children: [
        ...displayedCategories.map((category) => _buildCategoryItem(
              context,
              category["name"] as String,
              category["icon"] as IconData,
              category["bgColor"] as Color,
              category["iconColor"] as Color,
              () => controller.filterByCategory(category["name"] as String),
            )),
        _buildCategoryItem(
          context,
          moreItem["name"] as String,
          moreItem["icon"] as IconData,
          moreItem["bgColor"] as Color,
          moreItem["iconColor"] as Color,
          () => Get.toNamed("/categories", arguments: categoryStyles),
        ),
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
