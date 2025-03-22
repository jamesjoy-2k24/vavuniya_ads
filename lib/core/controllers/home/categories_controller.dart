import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/core/controllers/home/home_search_controller.dart';

class CategoriesController extends GetxController {
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        categories.value =
            (data['categories'] as List).cast<Map<String, dynamic>>();
      } else if (response.statusCode == 401) {
        throw 'Unauthorized - please log in again';
      } else {
        throw 'Failed to fetch categories: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        "Couldn’t load categories: $e",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      categories.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  void selectCategory(String categoryId) {
    Get.find<HomeSearchController>().setCategoryFilter(categoryId: categoryId);
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
