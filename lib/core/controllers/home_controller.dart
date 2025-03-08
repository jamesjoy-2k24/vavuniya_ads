import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/config/app_routes.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> favoriteAds = <Map<String, dynamic>>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isFirstVisit = true.obs;
  final RxString searchQuery = ''.obs;
  final RxString selectedCategory = ''.obs;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    _checkFirstVisit();
    fetchAds();
  }

// First Visit
  Future<void> _checkFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstVisit.value = prefs.getBool('isFirstVisitHome') ?? true;
  }

// Dismiss First Visit
  Future<void> dismissFirstVisit() async {
    isFirstVisit.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstVisitHome', false);
  }

// Fetch Ads
  Future<void> fetchAds({String? categoryId, String? search}) async {
    isLoading.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/api/ads/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': token,
        },
        body: jsonEncode({
          'category_id': categoryId,
          'search': search,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ads.value = List<Map<String, dynamic>>.from(data['ads']);
      } else {
        throw data['error'] ?? 'Failed to fetch ads';
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Failed to load ads: $e",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

// Filter Category
  void filterByCategory(String? category) {
    selectedCategory.value = category ?? '';
    fetchAds(
        categoryId: category,
        search: searchQuery.value.isEmpty ? null : searchQuery.value);
  }

// Search Ads
  void searchAds(String query) {
    searchQuery.value = query;
    fetchAds(
        categoryId: selectedCategory.value,
        search: query.isEmpty ? null : query);
  }

// Logout
  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLoggedIn', false);
    await prefs.remove('userId');
    await prefs.remove('token');
    Get.offAllNamed(AppRoutes.login);
  }
}
