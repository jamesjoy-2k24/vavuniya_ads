import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vavuniya_ads/core/controllers/user/user_controller.dart';

class MyAdsController extends GetxController {
  final RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    fetchMyAds();
    super.onInit();
  }

  Future<void> fetchMyAds() async {
    try {
      isLoading.value = true;
      error.value = '';

      final token = await _getToken();
      if (token.isEmpty) {
        error.value = 'No authentication token found';
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/users/my_ads'),
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
          ads.value = List<Map<String, dynamic>>.from(data['ads']);
        }
      } else {
        error.value = 'Failed to load ads: ${response.statusCode}';
      }
    } catch (e) {
      error.value = 'Error fetching ads: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshAds() async {
    await fetchMyAds();
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
