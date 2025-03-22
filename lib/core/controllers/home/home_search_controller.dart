import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:debounce_throttle/debounce_throttle.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/core/controllers/home/home_controller.dart';

class HomeSearchController extends GetxController {
  final TextEditingController searchController = TextEditingController();
  final RxBool isTyping = false.obs;
  final RxList<String> recentSearches = <String>[].obs;
  final RxList<String> suggestions = <String>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategory = ''.obs;
  final RxDouble minPrice = 0.0.obs;
  final RxDouble maxPrice = double.infinity.obs;
  final _debouncer = Debouncer<void Function()>(Duration(milliseconds: 500),
      initialValue: () {});

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    _loadRecentSearches();
    searchController.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    isTyping.value = searchController.text.isNotEmpty;
    if (isTyping.value) {
      _debouncer.value = () => updateSuggestions(searchController.text);
    } else {
      suggestions.clear();
    }
  }

  Future<void> _loadRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    recentSearches.value = prefs.getStringList('recentSearches') ?? [];
  }

  Future<void> _saveRecentSearches() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(
        'recentSearches', recentSearches.take(5).toList());
  }

// Search Ads
  void searchAds(String query) async {
    if (query.isEmpty &&
        selectedCategory.value.isEmpty &&
        minPrice.value == 0 &&
        maxPrice.value == double.infinity) {
      clearSearch();
      return;
    }

    isLoading.value = true;
    try {
      final url =
          Uri.parse('$baseUrl/api/ads/search').replace(queryParameters: {
        'q': query.isNotEmpty ? query : null,
        if (selectedCategory.value.isNotEmpty)
          'category_id': selectedCategory.value,
        if (minPrice.value > 0) 'minPrice': minPrice.value.toString(),
        if (maxPrice.value != double.infinity)
          'maxPrice': maxPrice.value.toString(),
        'page': '1',
        'limit': '10',
      });

      final token = await _getToken();
      if (token.isEmpty) throw 'Authentication token missing';

      final response = await http.get(url, headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final ads = (data['ads'] as List).cast<Map<String, dynamic>>();
        Get.find<HomeController>().updateAds(ads);

        if (query.isNotEmpty && !recentSearches.contains(query)) {
          recentSearches.insert(0, query);
          if (recentSearches.length > 5) recentSearches.removeLast();
          await _saveRecentSearches();
        }
      } else if (response.statusCode == 401) {
        throw 'Unauthorized access - please log in again';
      } else if (response.statusCode == 400) {
        throw jsonDecode(response.body)['error'] ?? 'Invalid search parameters';
      } else {
        throw 'Search failed: ${response.statusCode}';
      }
    } catch (e) {
      String errorMsg = e.toString().contains('Unauthorized')
          ? "Please log in again"
          : e.toString().contains('Invalid')
              ? e.toString()
              : "Failed to search ads: $e";
      Get.snackbar("Error", errorMsg,
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

// Set Category Filter
  void setCategoryFilter(
      {String? categoryId, double? minPrice, double? maxPrice}) {
    if (categoryId != null) selectedCategory.value = categoryId;
    if (minPrice != null) this.minPrice.value = minPrice;
    if (maxPrice != null) this.maxPrice.value = maxPrice;
    searchAds(searchController.text);
  }

// Update Suggestions
  void updateSuggestions(String query) async {
    if (query.isEmpty) {
      suggestions.clear();
      return;
    }

    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/ads/suggestions?q=$query'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        suggestions.value = (data['suggestions'] as List).cast<String>();
      } else {
        suggestions.clear();
      }
    } catch (e) {
      suggestions.clear();
    }
  }

// Select Search
  void selectSearch(String search) {
    searchController.text = search;
    searchAds(search);
  }

  void clearSearch() {
    searchController.clear();
    isTyping.value = false;
    suggestions.clear();
    selectedCategory.value = '';
    minPrice.value = 0.0;
    maxPrice.value = double.infinity;
    Get.find<HomeController>().updateAds([]);
  }

  void setFilter({String? category, double? minPrice, double? maxPrice}) {
    if (category != null) selectedCategory.value = category;
    if (minPrice != null) this.minPrice.value = minPrice;
    if (maxPrice != null) this.maxPrice.value = maxPrice;
    searchAds(searchController.text);
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }

  @override
  void onClose() {
    searchController.removeListener(_onTextChanged);
    searchController.dispose();
    super.onClose();
  }
}
