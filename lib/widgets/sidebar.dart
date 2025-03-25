import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final Widget content; // Widget to display when selected
  final VoidCallback? onTap; // Optional custom action (e.g., logout)

  SidebarItem({
    required this.title,
    required this.icon,
    required this.content,
    this.onTap,
  });
}

class SidebarController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void selectItem(int index) {
    selectedIndex.value = index;
  }
}

class Sidebar extends StatelessWidget {
  final String role;
  final List<SidebarItem> items;
  final Color backgroundColor;
  final double width;
  final Color selectedColor;
  final Color unselectedColor;

  final SidebarController controller = Get.put(SidebarController());

  Sidebar({
    super.key,
    required this.role,
    required this.items,
    this.backgroundColor = Colors.white,
    this.width = 250,
    this.selectedColor = AppColors.blue,
    this.unselectedColor = AppColors.grey,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      color: backgroundColor,
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                role == 'admin' ? 'Admin Panel' : 'My Account',
                style: AppTypography.subheading.copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ),
            const Divider(height: 1, color: AppColors.grey),
            // Navigation Items
            Expanded(
              child: Obx(
                () {
                  final currentIndex = controller.selectedIndex.value;
                  return ListView.builder(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      final isSelected = currentIndex == index;
                      return ListTile(
                        leading: Icon(
                          item.icon,
                          color: isSelected ? selectedColor : unselectedColor,
                        ),
                        title: Text(
                          item.title,
                          style: AppTypography.body.copyWith(
                            color: isSelected ? selectedColor : unselectedColor,
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                        onTap: () {
                          if (item.onTap != null) {
                            item.onTap!();
                          } else {
                            controller.selectItem(index);
                          }
                        },
                        tileColor:
                            isSelected ? selectedColor.withOpacity(0.1) : null,
                        hoverColor: AppColors.grey.withOpacity(0.1),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
