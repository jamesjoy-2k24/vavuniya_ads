import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/config/app_routes.dart';

class HomeController extends GetxController {
  final ScrollController scrollController = ScrollController();
  final RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> favoriteAds = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxBool isLoadingMore = false.obs;
  final RxBool isFirstVisit = true.obs;
  final RxString searchQuery = ''.obs;
  final Rx<String?> selectedCategory = Rx<String?>(null);
  final RxInt currentPage = 1.obs;
  final RxBool hasMoreAds = true.obs;
  static const int pageSize = 10;
  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    _checkFirstVisit();
    fetchInitialData();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.removeListener(_scrollListener);
    scrollController.dispose();
    super.onClose();
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
      fetchFavorites(), // Added to sync favorites
    ]);
    isLoading.value = false;
  }

  Future<void> fetchCategories() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/api/categories/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        categories.assignAll(List<Map<String, dynamic>>.from(data['data']));
      } else {
        throw jsonDecode(response.body)['error'] ??
            'Failed to fetch categories';
      }
    } catch (e) {
      _handleError("Failed to load categories: $e");
      if (categories.isEmpty) {
        categories.assignAll([
          {'id': 1, 'name': 'Electronics'},
          {'id': 2, 'name': 'Vehicles'},
          {'id': 3, 'name': 'Furniture'},
        ]);
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
        final newAds = List<Map<String, dynamic>>.from(data['ads'])
            .map(_formatAd)
            .toList();
        if (loadMore) {
          ads.addAll(newAds);
        } else {
          ads.assignAll(newAds);
        }
        hasMoreAds.value = data['has_more'] ?? newAds.length == pageSize;
        if (hasMoreAds.value && loadMore) currentPage.value++;
      } else {
        throw jsonDecode(response.body)['error'] ?? 'Failed to fetch ads';
      }
    } catch (e) {
      _handleError("Failed to load ads: $e");
      if (isInitialLoad && ads.isEmpty) ads.assignAll([]);
    } finally {
      if (isInitialLoad) isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  Map<String, dynamic> _formatAd(Map<String, dynamic> ad) {
    return {
      'id': ad['id']?.toString() ?? '',
      'title': ad['title'] ?? 'Untitled',
      'price': double.tryParse(ad['price']?.toString() ?? '0') ?? 0.0,
      'item_condition': ad['item_condition'] ?? 'Unknown',
      'images': ad['images'] != null ? List<String>.from(ad['images']) : [],
      'location': ad['location'] ?? 'Unknown',
      'description': ad['description'] ?? '',
      'status': ad['status'] ?? 'Unknown',
      'user_id': ad['user_id']?.toString() ?? '',
      'category_id': ad['category_id']?.toString(),
      'is_favorite': ad['is_favorite'] ?? false,
      'created_at': ad['created_at'] ?? '',
      'updated_at': ad['updated_at'] ?? '',
    };
  }

  Future<void> fetchFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        favoriteAds
            .assignAll(List<Map<String, dynamic>>.from(data['favorites']));
      } else {
        throw jsonDecode(response.body)['error'] ?? 'Failed to fetch favorites';
      }
    } catch (e) {
      _handleError("Failed to load favorites: $e");
    }
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
        final data = jsonDecode(response.body);
        final isFavorite = data['is_favorite'] ?? false;
        final adIndex = ads.indexWhere((ad) => ad['id'] == adId);
        if (adIndex != -1) {
          ads[adIndex]['is_favorite'] = isFavorite;
          if (isFavorite) {
            favoriteAds.add(ads[adIndex]);
          } else {
            favoriteAds.removeWhere((fav) => fav['id'] == adId);
          }
          ads.refresh();
          favoriteAds.refresh();
        }
      } else {
        throw jsonDecode(response.body)['error'] ?? 'Failed to toggle favorite';
      }
    } catch (e) {
      _handleError("Failed to toggle favorite: $e");
    }
  }

  Future<Map<String, dynamic>?> fetchAdDetail(String adId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/api/ads/show?id=$adId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return _formatAd(data); // No 'data' wrapper from backend
      } else {
        throw jsonDecode(response.body)['error'] ??
            'Failed to fetch ad details';
      }
    } catch (e) {
      _handleError("Failed to fetch ad details: $e");
      return null;
    }
  }

  Future<void> updateAd(String adId, Map<String, dynamic> adData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        // Changed to POST to match backend
        Uri.parse('$baseUrl/api/ads/update'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': adId, ...adData}),
      );

      if (response.statusCode == 200) {
        await fetchAds(); // Refresh list
        Get.snackbar("Success", "Ad updated successfully!");
      } else {
        throw jsonDecode(response.body)['error'] ?? 'Failed to update ad';
      }
    } catch (e) {
      _handleError("Failed to update ad: $e");
    }
  }

  Future<void> deleteAd(String adId) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        // Changed to POST to match backend
        Uri.parse('$baseUrl/api/ads/delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': adId}),
      );

      if (response.statusCode == 200) {
        ads.removeWhere((ad) => ad['id'] == adId);
        favoriteAds.removeWhere((fav) => fav['id'] == adId);
        ads.refresh();
        Get.snackbar("Success", "Ad deleted successfully!");
      } else {
        throw jsonDecode(response.body)['error'] ?? 'Failed to delete ad';
      }
    } catch (e) {
      _handleError("Failed to delete ad: $e");
    }
  }

  Future<void> createAd(Map<String, dynamic> adData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token') ?? '';
      final response = await http.post(
        Uri.parse('$baseUrl/api/ads/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(adData),
      );

      if (response.statusCode == 201) {
        await fetchAds();
        Get.snackbar("Success", "Ad created successfully!");
      } else {
        throw jsonDecode(response.body)['error'] ?? 'Failed to create ad';
      }
    } catch (e) {
      _handleError("Failed to create ad: $e");
    }
  }

  void filterByCategory(String? category) {
    selectedCategory.value = category;
    fetchAds(
      categoryId: category,
      search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
    );
  }

  void searchAds(String query) {
    searchQuery.value = query;
    fetchAds(
      categoryId: selectedCategory.value,
      search: query.isNotEmpty ? query : null,
    );
  }

  Future<void> loadMoreAds() => fetchAds(
        categoryId: selectedCategory.value,
        search: searchQuery.value.isNotEmpty ? searchQuery.value : null,
        loadMore: true,
      );

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        hasMoreAds.value &&
        !isLoadingMore.value) {
      loadMoreAds();
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    Get.offAllNamed(AppRoutes.login);
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
}
