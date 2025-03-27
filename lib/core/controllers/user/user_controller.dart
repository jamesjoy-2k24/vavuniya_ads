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
        Uri.parse('$baseUrl/api/users/me'),
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
