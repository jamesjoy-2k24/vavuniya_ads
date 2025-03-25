import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/home/bottom_bar.dart';
import 'package:vavuniya_ads/widgets/sidebar.dart';

class ProfileScreen extends StatelessWidget {
  ProfileScreen({super.key});

  // Placeholder user data
  final Map<String, dynamic> user = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'joined': 'March 25, 2023',
  };

  // User sidebar items with content
  static final List<SidebarItem> userItems = [
    SidebarItem(
      title: 'Profile',
      icon: Icons.person,
      content: _ProfileContent(),
    ),
    SidebarItem(
      title: 'My Ads',
      icon: Icons.list,
      content: _MyAdsContent(),
    ),
    SidebarItem(
      title: 'Settings',
      icon: Icons.settings,
      content: _SettingsContent(),
    ),
    SidebarItem(
      title: 'Logout',
      icon: Icons.logout,
      content: SizedBox(), // Placeholder, handled by onTap
      onTap: _logout,
    ),
  ];

  // Admin sidebar items with content
  static final List<SidebarItem> adminItems = [
    SidebarItem(
      title: 'Profile',
      icon: Icons.person,
      content: _ProfileContent(),
    ),
    SidebarItem(
      title: 'Manage Ads',
      icon: Icons.list_alt,
      content: _ManageAdsContent(),
    ),
    SidebarItem(
      title: 'Manage Users',
      icon: Icons.people,
      content: _ManageUsersContent(),
    ),
    SidebarItem(
      title: 'Categories',
      icon: Icons.category,
      content: _CategoriesContent(),
    ),
    SidebarItem(
      title: 'Reports',
      icon: Icons.bar_chart,
      content: _ReportsContent(),
    ),
    SidebarItem(
      title: 'Settings',
      icon: Icons.settings,
      content: _SettingsContent(),
    ),
    SidebarItem(
      title: 'Logout',
      icon: Icons.logout,
      content: SizedBox(), // Placeholder, handled by onTap
      onTap: _logout,
    ),
  ];

  static void _logout() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () => Get.offAllNamed('/login'),
            child:
                const Text("Logout", style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Placeholder role check (replace with auth logic)
    const bool isAdmin = false; // Toggle to true for admin testing
    final controller = Get.find<SidebarController>();

    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          Row(
            children: [
              // Persistent Sidebar
              Sidebar(
                role: isAdmin ? 'admin' : 'user',
                items: isAdmin ? adminItems : userItems,
              ),
              // Dynamic Content Area
              Expanded(
                child: Column(
                  children: [
                    AppBar(
                      title: const Text("Profile"),
                      backgroundColor: AppColors.blue,
                      elevation: 0,
                      automaticallyImplyLeading: false, // No back button
                    ),
                    Expanded(
                      child: Obx(
                        () => (isAdmin
                                ? adminItems
                                : userItems)[controller.selectedIndex.value]
                            .content,
                      ),
                    ),
                    const BottomBar(),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// Content Widgets (Placeholders)
class _ProfileContent extends StatelessWidget {
  final Map<String, dynamic> user = {
    'name': 'John Doe',
    'email': 'john.doe@example.com',
    'joined': 'March 25, 2023',
  };

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "My Profile",
            style: AppTypography.subheading.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 20),
          Card(
            elevation: 2,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const CircleAvatar(
                        radius: 30,
                        backgroundColor: AppColors.grey,
                        child:
                            Icon(Icons.person, size: 40, color: Colors.white),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user['name'],
                              style: AppTypography.body.copyWith(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              user['email'],
                              style: AppTypography.caption.copyWith(
                                fontSize: 14,
                                color: AppColors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Joined: ${user['joined']}",
                    style: AppTypography.caption.copyWith(
                      fontSize: 12,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Edit Profile coming soon!")),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.blue,
              padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 24),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text("Edit Profile"),
          ),
        ],
      ),
    );
  }
}

class _MyAdsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("My Ads Content Coming Soon"));
  }
}

class _SettingsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Settings Content Coming Soon"));
  }
}

class _ManageAdsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Manage Ads Content Coming Soon"));
  }
}

class _ManageUsersContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Manage Users Content Coming Soon"));
  }
}

class _CategoriesContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Categories Content Coming Soon"));
  }
}

class _ReportsContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Center(child: Text("Reports Content Coming Soon"));
  }
}
