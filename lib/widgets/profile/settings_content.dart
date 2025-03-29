import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/core/controllers/user/user_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class SettingsContent extends StatefulWidget {
  const SettingsContent({super.key});

  @override
  State<SettingsContent> createState() => _SettingsContentState();
}

class _SettingsContentState extends State<SettingsContent>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();

    final userController = Get.find<UserController>();
    _nameController.text = userController.user.value['name'] ?? '';
    _phoneController.text =
        userController.user.value['email'] ?? ''; // Using email as phone
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _saveSettings() async {
    final userController = Get.find<UserController>();
    await userController.updateUserDetails(
        _nameController.text, _phoneController.text);
  }

  void _showChangePasswordDialog() {
    Get.dialog(ChangePasswordDialog());
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: [
                  _buildSectionTitle("Account"),
                  _buildTextField("Name", _nameController),
                  _buildTextField("Phone", _phoneController),
                  _buildActionTile(
                      "Change Password", Icons.lock, _showChangePasswordDialog),
                  const SizedBox(height: 16),
                  _buildSectionTitle("Preferences"),
                  _buildSwitchTile(
                    title: "Dark Mode",
                    value: Get.isDarkMode,
                    onChanged: (value) async {
                      Get.changeThemeMode(
                          value ? ThemeMode.dark : ThemeMode.light);
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('darkMode', value);
                      setState(() {});
                    },
                  ),
                  _buildSwitchTile(
                    title: "Push Notifications",
                    value: false,
                    onChanged: (value) async {
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool('notifications', value);
                      Get.snackbar('Info',
                          'Notifications toggle: $value (Not implemented yet)');
                    },
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _saveSettings,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text(
                      "Save Changes",
                      style: AppTypography.body.copyWith(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [AppColors.blue, AppColors.blue.withOpacity(0.8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        "Settings",
        style: AppTypography.subheading.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Text(
        title,
        style: AppTypography.subheading.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: AppColors.grey.withOpacity(0.1),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
      {required String title,
      required bool value,
      required ValueChanged<bool> onChanged}) {
    return SwitchListTile(
      title: Text(title, style: AppTypography.body),
      value: value,
      activeColor: AppColors.blue,
      onChanged: onChanged,
    );
  }

  Widget _buildActionTile(String title, IconData icon, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: AppColors.blue),
      title: Text(title, style: AppTypography.body),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.grey),
      onTap: onTap,
    );
  }
}

class ChangePasswordDialog extends StatelessWidget {
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  ChangePasswordDialog({super.key});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Change Password"),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _currentPasswordController,
              decoration: const InputDecoration(labelText: "Current Password"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _newPasswordController,
              decoration: const InputDecoration(labelText: "New Password"),
              obscureText: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _confirmPasswordController,
              decoration:
                  const InputDecoration(labelText: "Confirm New Password"),
              obscureText: true,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel"),
        ),
        ElevatedButton(
          onPressed: () async {
            if (_newPasswordController.text !=
                _confirmPasswordController.text) {
              Get.snackbar('Error', 'New passwords do not match');
              return;
            }
            if (_newPasswordController.text.length < 6) {
              Get.snackbar('Error', 'Password must be at least 6 characters');
              return;
            }
            final userController = Get.find<UserController>();
            await userController.changePassword(
              _currentPasswordController.text,
              _newPasswordController.text,
            );
            Get.back();
          },
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.blue),
          child: const Text("Save"),
        ),
      ],
    );
  }
}
