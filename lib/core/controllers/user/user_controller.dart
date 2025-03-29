import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  final Rx<Map<String, dynamic>> user = Rx({});
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    fetchUserData();
    super.onInit();
  }

  Future<void> fetchUserData() async {
    try {
      isLoading.value = true;
      error.value = '';

      final token = await _getToken();
      if (token.isEmpty) {
        error.value = 'No authentication token found';
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/user/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['error'] != null) {
          error.value = data['error'];
        } else {
          user.value = {
            'name': data['name'] ?? 'No Name',
            'phone': data['phone'] ?? 'No Phone',
            'joined': data['joined'] ?? 'Unknown',
            'adCount': data['adCount'] ?? 0,
            'favoritesCount': data['favoritesCount'] ?? 0,
            'messagesCount': data['messagesCount'] ?? 0,
            'role': data['role'] ?? 'user',
          };
        }
      } else {
        error.value = 'Failed to load user data: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Error fetching user data: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> changePassword(
      String currentPassword, String newPassword) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/password'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'currentPassword': currentPassword,
          'newPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Password changed successfully');
      } else {
        final data = jsonDecode(response.body);
        error.value = data['error'] ?? 'Failed to change password';
        Get.snackbar('Error', error.value);
      }
    } catch (e) {
      error.value = 'Error changing password: $e';
      Get.snackbar('Error', error.value);
    }
  }

  Future<void> updateUserDetails(String name, String phone) async {
    try {
      if (name.isEmpty || phone.isEmpty) {
        Get.snackbar('Error', 'Name and phone cannot be empty');
        return;
      }

      final token = await _getToken();
      if (token.isEmpty) {
        Get.snackbar('Error', 'No authentication token found');
        return;
      }

      final response = await http.put(
        Uri.parse('$baseUrl/api/user/update_user'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'name': name,
          'phone2': phone,
        }),
      );

      if (response.statusCode == 200) {
        await fetchUserData();
        Get.snackbar('Success', 'Profile updated successfully');
      } else {
        final data = jsonDecode(response.body);
        error.value =
            data['error'] ?? 'Failed to update profile: ${response.statusCode}';
        Get.snackbar('Error', error.value);
      }
    } catch (e) {
      error.value = 'Error updating profile: $e';
      Get.snackbar('Error', error.value);
    }
  }

  Future<void> refreshUserData() async {
    await fetchUserData();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  // Save token after login (call this in your login flow)
  Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('token', token);
  }

  // Clear token on logout
  Future<void> clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');
  }
}
