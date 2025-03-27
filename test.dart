import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProfileDrawer extends StatelessWidget {
  final Map<String, dynamic> user;
  final bool isAdmin;

  const ProfileDrawer({
    super.key,
    required this.user,
    required this.isAdmin, // Added flag for Admin role
  });

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildDrawerHeader(),
          // Conditional rendering for Admin and User options
          if (isAdmin) ...[
            _buildDrawerItem(
              icon: Icons.dashboard,
              text: 'Admin Dashboard',
              onTap: () {
                Get.offNamed('/admin_dashboard');
              },
            ),
          ],
          _buildDrawerItem(
            icon: Icons.person,
            text: 'Profile',
            onTap: () {
              Get.back(); // Close drawer if already in Profile section
            },
          ),
          _buildDrawerItem(
            icon: Icons.list,
            text: 'My Ads',
            onTap: () {
              Get.offNamed('/my_ads');
            },
          ),
          _buildDrawerItem(
            icon: Icons.settings,
            text: 'Settings',
            onTap: () {
              Get.offNamed('/settings');
            },
          ),
          _buildDrawerItem(
            icon: Icons.logout,
            text: 'Logout',
            onTap: _logout,
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerHeader() {
    return UserAccountsDrawerHeader(
      accountName: Text(user['name']),
      accountEmail: Text(user['email']),
      currentAccountPicture: const CircleAvatar(
        child: Icon(Icons.person, size: 40),
      ),
    );
  }

  Widget _buildDrawerItem({
    required IconData icon,
    required String text,
    required GestureTapCallback onTap,
  }) {
    return ListTile(
      title: Text(text),
      leading: Icon(icon),
      onTap: onTap,
    );
  }

  void _logout() {
    Get.dialog(
      AlertDialog(
        title: const Text("Logout"),
        content: const Text("Are you sure you want to logout?"),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          TextButton(
            onPressed: () {
              Get.offAllNamed('/login');
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
