import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesController extends GetxController {
  final RxList<Map<String, dynamic>> favorites = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    fetchFavorites();
  }

  /// Fetches the user's favorite ads
  Future<void> fetchFavorites() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/favorites/list'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        favorites.value =
            (data['favorites'] as List).cast<Map<String, dynamic>>();
      } else {
        throw 'Failed to fetch favorites: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('Fetch error: $e'); // Debug error
      Get.snackbar("Error", "Couldn’t load favorites: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      favorites.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  /// Adds an ad to the user's favorites
  Future<void> addFavorite(String adId) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/favorites/add'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
        body: jsonEncode({'ad_id': int.parse(adId)}),
      );

      if (response.statusCode == 200) {
        fetchFavorites();
        Get.snackbar("Success", "Added to favorites",
            snackPosition: SnackPosition.TOP);
      } else {
        throw 'Failed to add favorite: ${response.statusCode}';
      }
    } catch (e) {
      Get.snackbar("Error", "Couldn’t add favorite: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  Future<void> removeFavorite(String adId) async {
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/api/favorites/remove?id=$adId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      if (response.statusCode == 200) {
        fetchFavorites();
        Get.snackbar("Success", "Removed from favorites",
            snackPosition: SnackPosition.TOP);
      } else if (response.statusCode == 404) {
        Get.snackbar("Error", "Ad not found in favorites",
            snackPosition: SnackPosition.TOP,
            backgroundColor: Colors.redAccent,
            colorText: Colors.white);
      } else {
        throw 'Failed to remove favorite: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      Get.snackbar("Error", "Couldn’t remove favorite: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    }
  }

  /// 🕒 Formats the "time ago" display for ads
  String timeAgo(String createdAt) {
    final createdDate = DateTime.tryParse(createdAt) ?? DateTime.now();
    final now = DateTime.now();
    final difference = now.difference(createdDate);

    if (difference.inMinutes < 1) {
      return "Just now";
    } else if (difference.inHours < 1) {
      return "${difference.inMinutes} min ago";
    } else if (difference.inDays < 1) {
      return "${difference.inHours} hrs ago";
    } else if (difference.inDays == 1) {
      return "Yesterday";
    } else if (difference.inDays < 7) {
      return "${difference.inDays} days ago";
    } else if (difference.inDays < 30) {
      return "${(difference.inDays / 7).floor()} weeks ago";
    } else {
      return "${(difference.inDays / 30).floor()} months ago";
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
