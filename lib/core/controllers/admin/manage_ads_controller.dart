import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ManageAdsController extends GetxController {
  final RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = true.obs;
  final RxString error = ''.obs;
  RxString selectedStatus = 'all'.obs;
  RxList<dynamic> filteredAds = <dynamic>[].obs;
  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    fetchAds();
    super.onInit();
  }

  void filterAds() {
    if (selectedStatus.value == 'all') {
      filteredAds.value = ads;
    } else {
      filteredAds.value =
          ads.where((ad) => ad['status'] == selectedStatus.value).toList();
    }
  }

  Future<void> fetchAds() async {
    try {
      isLoading.value = true;
      error.value = '';
      final token = await _getToken();
      if (token.isEmpty) {
        error.value = 'No authentication token found';
        Get.snackbar('Error', error.value);
        return;
      }

      final response = await http.get(
        Uri.parse('$baseUrl/api/admin/manage_ads'),
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
        Get.snackbar('Error', error.value);
      }
    } catch (e) {
      error.value = 'Error fetching ads: $e';
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> approveAd(int adId) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/approve_ad'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': adId,
        }),
      );

      if (response.statusCode == 200) {
        fetchAds(); // Refresh the list
        Get.snackbar('Success', 'Ad approved successfully');
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['error'] ?? 'Failed to approve ad');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error approving ad: $e');
    }
  }

  Future<void> rejectAd(int adId, String reason) async {
    try {
      final token = await _getToken();
      final response = await http.put(
        Uri.parse('$baseUrl/api/admin/reject_ad'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'id': adId,
          'rejection_reason': reason,
        }),
      );

      if (response.statusCode == 200) {
        fetchAds(); // Refresh the list
        Get.snackbar('Success', 'Ad rejected successfully');
      } else {
        final data = jsonDecode(response.body);
        Get.snackbar('Error', data['error'] ?? 'Failed to reject ad');
      }
    } catch (e) {
      Get.snackbar('Error', 'Error rejecting ad: $e');
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
