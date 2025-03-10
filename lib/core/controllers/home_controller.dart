import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/config/app_routes.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> favoriteAds = <Map<String, dynamic>>[].obs;
  final RxList<String> categories = <String>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isFirstVisit = true.obs;
  final RxString searchQuery = ''.obs;
  final Rx<String?> selectedCategory = Rx<String?>(null); // Nullable value
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreAds = true.obs;
  final int pageSize = 10;

  static const String baseUrl =
      'http://localhost/vavuniya_ads'; // Update for prod

  @override
  void onInit() {
    super.onInit();
    _checkFirstVisit();
    fetchInitialData();
  }

  Future<void> _checkFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    isFirstVisit.value = prefs.getBool('isFirstVisitHome') ?? true;
  }

  Future<void> dismissFirstVisit() async {
    isFirstVisit.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isFirstVisitHome', false);
  }

  Future<void> fetchInitialData() async {
    isLoading.value = true;
    await Future.wait([
      fetchCategories(),
      fetchAds(),
    ]);
    isLoading.value = false;
  }

  Future<void> fetchCategories() async {
    try {
      // Replace with real API call if separate endpoint exists
      await Future.delayed(const Duration(seconds: 1)); // Simulate network
      categories.assignAll([
        'Vehicles',
        'Jobs',
        'Services',
        'Property',
        'Agriculture',
        'Education',
        'Electronics',
        'Health',
        'Fashion',
        'Food',
        'Travel',
        'Sports',
      ]);
    } catch (e) {
      _handleError("Failed to load categories: $e");
      if (categories.isEmpty) {
        categories
            .assignAll(['Vehicles', 'Jobs', 'Services']); // Minimal fallback
      }
    }
  }

  Future<void> fetchAds(
      {String? categoryId, String? search, bool loadMore = false}) async {
    if (loadMore && (!hasMoreAds.value || isLoadingMore.value)) return;
    final bool isInitialLoad = !loadMore;
    if (isInitialLoad) {
      isLoading.value = true;
      currentPage.value = 1;
      ads.clear();
      hasMoreAds.value = true;
    } else {
      isLoadingMore.value = true;
    }

    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/api/ads/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'category_id': categoryId,
          'search': search,
          'page': currentPage.value,
          'page_size': pageSize,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final newAds = _formatAds(List<dynamic>.from(data['ads']));
        if (loadMore) {
          ads.addAll(newAds);
        } else {
          ads.assignAll(newAds);
        }
        hasMoreAds.value = newAds.length == pageSize;
        if (hasMoreAds.value && loadMore) currentPage.value++;
      } else {
        throw jsonDecode(response.body)['error'] ?? 'Failed to fetch ads';
      }
    } catch (e) {
      _handleError("Failed to load ads: $e");
      if (isInitialLoad && ads.isEmpty) {
        ads.assignAll([]);
      }
    } finally {
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  List<Map<String, dynamic>> _formatAds(List<dynamic> rawAds) {
    return rawAds
        .map((ad) => {
              'id': ad['id']?.toString() ?? '',
              'title': ad['title'] ?? 'Untitled',
              'price': double.tryParse(ad['price']?.toString() ?? '0') ?? 0.0,
              'item_condition': ad['condition'] ?? 'Unknown',
              'images':
                  ad['images'] != null ? List<String>.from(ad['images']) : [],
              'location': ad['location'] ?? 'Unknown',
              'verified': ad['verified'] ?? false,
              'is_favorite': favoriteAds.any((fav) => fav['id'] == ad['id']),
            })
        .toList();
  }

  void _handleError(String message) {
    Get.snackbar(
      "Oops!",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
      duration: const Duration(seconds: 3),
      isDismissible: true,
    );
  }

  void filterByCategory(String? category) {
    selectedCategory.value = category;
    fetchAds(
        categoryId: category,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null);
  }

  void searchAds(String query) {
    searchQuery.value = query;
    fetchAds(
        categoryId: selectedCategory.value,
        search: query.isNotEmpty ? query : null);
  }

  Future<void> loadMoreAds() {
    return fetchAds(
      categoryId: selectedCategory.value,
      search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
      loadMore: true,
    );
  }

  Future<void> toggleFavorite(String adId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/toggle'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'ad_id': adId}),
      );

      if (response.statusCode == 200) {
        final adIndex = ads.indexWhere((ad) => ad['id'] == adId);
        if (adIndex != -1) {
          final isFavorite = ads[adIndex]['is_favorite'] == true;
          ads[adIndex]['is_favorite'] = !isFavorite;
          if (isFavorite) {
            favoriteAds.removeWhere((fav) => fav['id'] == adId);
          } else {
            favoriteAds.add(ads[adIndex]);
          }
          ads.refresh(); // Ensure UI updates
          favoriteAds.refresh();
        }
      } else {
        throw jsonDecode(response.body)['error'] ?? 'Failed to toggle favorite';
      }
    } catch (e) {
      _handleError("Failed to toggle favorite: $e");
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(AppRoutes.login);
  }
}
