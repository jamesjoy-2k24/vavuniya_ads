import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class Categories extends StatelessWidget {
  Categories({super.key});
  final HomeController controller = Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
          child: Text(
            "Categories",
            style: AppTypography.subheading,
          ),
        ),
        _buildCategories(context, controller),
      ],
    );
  }
}

Widget _buildCategories(BuildContext context, HomeController controller) {
  final List<Map<String, dynamic>> allCategories = [
    {
      "name": "Vehicles",
      "icon": Icons.directions_car,
      "bgColor": const Color(0xFFDAFAF8),
      "iconColor": const Color(0xFF00C7BE),
    },
    {
      "name": "Jobs",
      "icon": Icons.work,
      "bgColor": const Color(0xFFFFEBEE),
      "iconColor": const Color(0xFFB71C1C),
    },
    {
      "name": "Services",
      "icon": Icons.build,
      "bgColor": const Color(0xFFE3F2FD),
      "iconColor": const Color(0xFF0D47A1),
    },
    {
      "name": "Property",
      "icon": Icons.home,
      "bgColor": const Color(0xFFFFEFD6),
      "iconColor": const Color(0xFFE65100),
    },
    {
      "name": "Agriculture",
      "icon": Icons.local_florist,
      "bgColor": const Color(0xFFE1FFE4),
      "iconColor": const Color(0xFF1B5E20),
    },
    {
      "name": "Education",
      "icon": Icons.school,
      "bgColor": const Color(0xFFF2DFF4),
      "iconColor": const Color(0xFF4A148C),
    },
    {
      "name": "Electronics",
      "icon": Icons.devices,
      "bgColor": const Color(0xFFDEDCFF),
      "iconColor": const Color(0xFF00188D),
    },
    {
      "name": "Health",
      "icon": Icons.local_hospital,
      "bgColor": const Color(0xFFF8E1E1),
      "iconColor": const Color(0xFFD81B60),
    },
    {
      "name": "Fashion",
      "icon": Icons.checkroom,
      "bgColor": const Color(0xFFFFF0E1),
      "iconColor": const Color(0xFFF06292),
    },
    {
      "name": "Food",
      "icon": Icons.fastfood,
      "bgColor": const Color(0xFFFFF9E1),
      "iconColor": const Color(0xFF795548),
    },
    {
      "name": "Travel",
      "icon": Icons.flight,
      "bgColor": const Color(0xFFE1F5FF),
      "iconColor": const Color(0xFF0277BD),
    },
    {
      "name": "Sports",
      "icon": Icons.sports_soccer,
      "bgColor": const Color(0xFFE8F5E9),
      "iconColor": const Color(0xFF2E7D32),
    },
  ];

  // Show only 7 + "More"
  final displayedCategories = allCategories.take(7).toList();
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
      childAspectRatio: 0.85, // Slightly adjusted for better spacing
      mainAxisSpacing: 8.0,
      crossAxisSpacing: 8.0,
      children: List.generate(
        8, // 7 categories + "More"
        (index) => index < 7
            ? _buildCategoryItem(
                context,
                displayedCategories[index]["name"],
                displayedCategories[index]["icon"],
                displayedCategories[index]["bgColor"],
                displayedCategories[index]["iconColor"],
                () {
                  controller
                      .filterByCategory(displayedCategories[index]["name"]);
                },
              )
            : _buildCategoryItem(
                context,
                moreItem["name"] as String,
                moreItem["icon"] as IconData,
                moreItem["bgColor"] as Color,
                moreItem["iconColor"] as Color,
                () {
                  Get.toNamed("/categories",
                      arguments: allCategories); // Pass all categories
                },
              ),
      ),
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
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        CircleAvatar(
          radius: 30,
          backgroundColor: bgColor,
          child: Icon(
            icon,
            color: iconColor,
            size: 28, // Slightly larger for better visibility
          ),
        ),
        const SizedBox(height: 6),
        Text(
          name,
          style: AppTypography.caption.copyWith(
            fontSize: 12,
            color: AppColors.textPrimary,
          ),
          textAlign: TextAlign.center,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ],
    ),
  );
}
