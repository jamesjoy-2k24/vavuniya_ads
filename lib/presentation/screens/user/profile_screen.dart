import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/sidebar_controller.dart';
import 'package:vavuniya_ads/core/controllers/user/user_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/profile/drawer.dart';
import 'package:vavuniya_ads/widgets/profile/profile_content.dart';
import 'package:vavuniya_ads/widgets/profile/my_ads_content.dart';
import 'package:vavuniya_ads/widgets/profile/settings_content.dart';
import 'package:vavuniya_ads/widgets/admin/manage_ads_content.dart';
import 'package:vavuniya_ads/widgets/profile/manage_users_content.dart';
import 'package:vavuniya_ads/widgets/profile/categories_content.dart';
import 'package:vavuniya_ads/widgets/profile/reports_content.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  static void _logout() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () async {
              final userController = Get.find<UserController>();
              await userController.clearToken();
              Get.offAllNamed('/login');
            },
            child:
                const Text("Logout", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final SidebarController sidebarController = Get.put(SidebarController());
    final UserController userController = Get.put(UserController());

    // Define sidebar items as a reactive list to avoid rebuilding
    RxList<SidebarItem> getItems(bool isAdmin) => (isAdmin
            ? [
                SidebarItem(
                    title: 'Profile',
                    icon: Icons.person,
                    content: const ProfileContent()),
                SidebarItem(
                    title: 'Manage Ads',
                    icon: Icons.list_alt,
                    content: const ManageAdsContent()),
                SidebarItem(
                    title: 'Manage Users',
                    icon: Icons.people,
                    content: const ManageUsersContent()),
                SidebarItem(
                    title: 'Categories',
                    icon: Icons.category,
                    content: const CategoriesContent()),
                SidebarItem(
                    title: 'Reports',
                    icon: Icons.bar_chart,
                    content: const ReportsContent()),
                SidebarItem(
                    title: 'Settings',
                    icon: Icons.settings,
                    content: const SettingsContent()),
                SidebarItem(
                    title: 'Logout',
                    icon: Icons.logout,
                    content: const SizedBox(),
                    onTap: _logout),
              ]
            : [
                SidebarItem(
                    title: 'Profile',
                    icon: Icons.person,
                    content: const ProfileContent()),
                SidebarItem(
                    title: 'My Ads',
                    icon: Icons.list,
                    content: const MyAdsContent()),
                SidebarItem(
                    title: 'Settings',
                    icon: Icons.settings,
                    content: const SettingsContent()),
                SidebarItem(
                    title: 'Logout',
                    icon: Icons.logout,
                    content: const SizedBox(),
                    onTap: _logout),
              ])
        .obs;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: AppColors.secondary,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.home),
            onPressed: () => Get.offNamed('/'),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: _logout,
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => userController.refreshUserData(),
          ),
        ],
      ),
      drawer: Obx(() {
        final isAdmin = userController.user.value['role'] == 'admin';
        final items = getItems(isAdmin);
        return ProfileDrawer(items: items);
      }),
      body: Stack(
        children: [
          const AppBg(),
          Obx(() {
            final isAdmin = userController.user.value['role'] == 'admin';
            final items = getItems(isAdmin);
            // Ensure index is within bounds
            final index = sidebarController.selectedIndex.value
                .clamp(0, items.length - 1);
            return items[index].content;
          }),
        ],
      ),
    );
  }
}
