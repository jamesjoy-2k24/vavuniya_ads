import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class MyAdsController extends GetxController {
  final RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  static const String baseUrl =
      'http://localhost/vavuniya_ads'; // Update as needed

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
        Uri.parse('$baseUrl/api/user/my_ads'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        ads.value = List<Map<String, dynamic>>.from(data['ads'] ?? []);
      } else {
        final data = jsonDecode(response.body);
        error.value = data['error'] ?? 'Failed to load ads';
      }
    } catch (e) {
      error.value = 'Error fetching ads: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> editAd(
      int id, String title, String description, String? imageUrl) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/update_ads'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': id,
          'title': title,
          'description': description,
          'imageUrl': imageUrl,
        }),
      );

      if (response.statusCode == 200) {
        final index = ads.indexWhere((ad) => ad['id'] == id);
        if (index != -1) {
          ads[index] = {
            'id': id,
            'title': title,
            'description': description,
            'imageUrl': imageUrl,
            'is_deleted': 0, // Ensure it’s active
          };
          ads.refresh();
        }
        Get.snackbar('Success', 'Ad updated successfully');
      } else {
        Get.snackbar('Error', 'Failed to update ad');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error updating ad: $e');
    }
  }

  Future<void> deleteAd(int id) async {
    try {
      final token = await _getToken();
      final response = await http.delete(
        Uri.parse('$baseUrl/api/user/delete_ads'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      if (response.statusCode == 200) {
        final index = ads.indexWhere((ad) => ad['id'] == id);
        if (index != -1) {
          ads[index]['is_deleted'] = 1; // Mark as deleted locally
          ads.refresh();
        }
        Get.snackbar(
          'Scheduled',
          'Ad scheduled for deletion in 1 day',
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 5),
          mainButton: TextButton(
            onPressed: () => undoDelete(id),
            child: const Text('Undo', style: TextStyle(color: Colors.white)),
          ),
        );
      } else {
        Get.snackbar('Error', 'Failed to delete ad');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error deleting ad: $e');
    }
  }

  Future<void> undoDelete(int id) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/api/user/undo_delete'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({'id': id}),
      );

      if (response.statusCode == 200) {
        final index = ads.indexWhere((ad) => ad['id'] == id);
        if (index != -1) {
          ads[index]['is_deleted'] = 0; // Restore locally
          ads.refresh();
        }
        Get.snackbar('Success', 'Ad restored');
      } else {
        Get.snackbar('Error', 'Failed to undo delete');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error undoing delete: $e');
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
