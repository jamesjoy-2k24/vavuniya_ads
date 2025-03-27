import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/sidebar_controller.dart';
import 'package:vavuniya_ads/core/controllers/user/user_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class SidebarItem {
  final String title;
  final IconData icon;
  final Widget content;
  final VoidCallback? onTap;

  SidebarItem({
    required this.title,
    required this.icon,
    required this.content,
    this.onTap,
  });
}

class ProfileDrawer extends StatelessWidget {
  final RxList<SidebarItem> items; // Changed to RxList for reactivity

  const ProfileDrawer({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebarController = Get.find<SidebarController>();
    final UserController userController = Get.find<UserController>();

    return Drawer(
      child: Column(
        children: [
          // Dynamic Header with User Data
          Obx(() {
            final user = userController.user.value;
            final name = user['name'] ?? 'Guest';
            final email = user['phone'] ?? 'No Phone';
            final isAdmin = user['role'] == 'admin';

            return UserAccountsDrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [AppColors.blue, AppColors.blue.withOpacity(0.8)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
              accountName: Row(
                children: [
                  Text(
                    name,
                    style: AppTypography.body.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (isAdmin) ...[
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        'Admin',
                        style: AppTypography.caption.copyWith(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              accountEmail: Text(
                email,
                style: AppTypography.caption.copyWith(color: Colors.white70),
              ),
              currentAccountPicture: CircleAvatar(
                backgroundColor: AppColors.grey
                    .withOpacity(0.3), // Fallback if textSecondary undefined
                child: user['avatarUrl'] != null
                    ? ClipOval(
                        child: Image.network(
                          user['avatarUrl'],
                          fit: BoxFit.cover,
                          width: 56,
                          height: 56,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(
                            Icons.person_rounded,
                            size: 40,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const Icon(
                        Icons.person_rounded,
                        size: 40,
                        color: Colors.white,
                      ),
              ),
            );
          }),
          // Navigation Items
          Expanded(
            child: Obx(() {
              final currentIndex = sidebarController.selectedIndex.value;
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isSelected = currentIndex == index;
                  return ListTile(
                    leading: Icon(
                      item.icon,
                      color:
                          isSelected ? AppColors.blue : AppColors.textSecondary,
                    ),
                    title: Text(
                      item.title,
                      style: AppTypography.body.copyWith(
                        color: isSelected
                            ? AppColors.blue
                            : AppColors.textSecondary,
                        fontWeight:
                            isSelected ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                    tileColor:
                        isSelected ? AppColors.blue.withOpacity(0.1) : null,
                    onTap: () {
                      if (item.onTap != null) {
                        item.onTap!();
                      } else {
                        sidebarController.selectItem(index);
                        Get.back(); // Close drawer
                      }
                    },
                    trailing: item.title == 'Logout'
                        ? const Icon(Icons.exit_to_app,
                            size: 20, color: AppColors.error)
                        : null,
                  );
                },
              );
            }),
          ),
          // Footer
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              '© 2025, Vavuniya Ads', // Updated year to current
              style: AppTypography.caption
                  .copyWith(color: AppColors.textSecondary),
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}
