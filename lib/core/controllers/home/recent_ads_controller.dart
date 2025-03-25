import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class RecentAdsController extends GetxController {
  final RxList<Map<String, dynamic>> recentAds = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool isLoadingMore = false.obs;
  final RxInt page = 1.obs;
  final RxBool hasMore = true.obs;
  static const String baseUrl = 'http://localhost/vavuniya_ads';
  final ScrollController scrollController = ScrollController();

  @override
  void onInit() {
    super.onInit();
    fetchRecentAds();
    scrollController.addListener(_scrollListener);
  }

  @override
  void onClose() {
    scrollController.dispose();
    super.onClose();
  }

  void _scrollListener() {
    if (scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200 &&
        !isLoadingMore.value &&
        hasMore.value) {
      fetchMoreAds();
    }
  }

  Future<void> fetchRecentAds() async {
    isLoading.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/ads/list?page=1'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      print('Recent Ads Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('ads')) {
          recentAds.value = (data['ads'] as List).cast<Map<String, dynamic>>();
          page.value = data['pagination']['page'];
          hasMore.value = data['pagination']['has_more'];
        } else {
          throw 'Ads key missing in response';
        }
      } else {
        throw 'Failed to fetch recent ads: ${response.statusCode} - ${response.body}';
      }
    } catch (e) {
      print('Recent Ads Fetch error: $e');
      Get.snackbar("Error", "Couldn’t load recent ads: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
      recentAds.value = [];
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchMoreAds() async {
    if (!hasMore.value || isLoadingMore.value) return;
    isLoadingMore.value = true;
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/api/ads/list?page=${page.value + 1}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer ${await _getToken()}',
        },
      );

      print('More Ads Raw response: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.containsKey('ads')) {
          recentAds.addAll((data['ads'] as List).cast<Map<String, dynamic>>());
          page.value = data['pagination']['page'];
          hasMore.value = data['pagination']['has_more'];
        } else {
          throw 'Ads key missing in response';
        }
      } else {
        throw 'Failed to fetch more ads: ${response.statusCode}';
      }
    } catch (e) {
      print('More Ads Fetch error: $e');
      Get.snackbar("Error", "Couldn’t load more ads: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white);
    } finally {
      isLoadingMore.value = false;
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
