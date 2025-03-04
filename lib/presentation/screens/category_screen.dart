import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<Map<String, dynamic>> allCategories = Get.arguments;
    return Scaffold(
      appBar: AppBar(title: const Text("All Categories")),
      body: GridView.count(
        padding: const EdgeInsets.all(16),
        crossAxisCount: 4,
        childAspectRatio: 0.85,
        mainAxisSpacing: 8,
        crossAxisSpacing: 8,
        children: allCategories.map((category) {
          return _buildCategoryItem(
            context,
            category["name"],
            category["icon"],
            category["bgColor"],
            category["iconColor"],
            () => Get.find<HomeController>()
                .filterByCategory(category["name"]),
          );
        }).toList(),
      ),
    );
  }
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
    child: Container(
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: iconColor, size: 40),
          const SizedBox(height: 8),
          Text(name, style: TextStyle(color: iconColor)),
        ],
      ),
    ),
  );
}