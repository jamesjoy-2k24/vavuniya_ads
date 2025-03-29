import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/core/controllers/user/my_ads_controller.dart';

class AddAdController extends GetxController {
  final RxInt categoryId = 0.obs;
  final RxString categoryName = '-- Select Category --'.obs;
  final RxString location = '-- Select Location --'.obs;
  final RxString title = ''.obs;
  final RxString description = ''.obs;
  final RxDouble price = 0.0.obs;
  final RxBool negotiable = false.obs;
  final RxString itemCondition = 'new'.obs;
  final RxString error = ''.obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  static const String baseUrl =
      'http://localhost/vavuniya_ads'; // Update as needed

  final List<String> locations = [
    '-- Select Location --',
    'Vavuniya',
    'Colombo',
    'Kandy',
    'Jaffna',
    'Galle'
  ];

  @override
  void onInit() {
    fetchCategories();
    super.onInit();
  }

  Future<void> fetchCategories() async {
    try {
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        categories.value =
            List<Map<String, dynamic>>.from(data['categories'] ?? []);
      } else {
        error.value = 'Failed to load categories';
        Get.snackbar('Error', error.value);
      }
    } catch (e) {
      error.value = 'Error fetching categories: $e';
      Get.snackbar('Error', error.value);
    }
  }

  Future<void> createAd() async {
    try {
      error.value = '';
      if (categoryId.value == 0 ||
          location.value == '-- Select Location --' ||
          title.value.isEmpty ||
          description.value.isEmpty) {
        error.value = 'All fields are required';
        Get.snackbar('Error', error.value);
        return;
      }

      final token = await _getToken();
      if (token.isEmpty) {
        error.value = 'No authentication token found';
        Get.snackbar('Error', error.value);
        return;
      }

      final response = await http.post(
        Uri.parse('$baseUrl/api/user/my-ads'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'category_id': categoryId.value,
          'location': location.value,
          'title': title.value,
          'description': description.value,
          'price': price.value,
          'negotiable': negotiable.value,
          'images': [], // Add image upload later
          'item_condition': itemCondition.value,
          'is_featured': false,
        }),
      );

      if (response.statusCode == 201) {
        Get.back(); // Close bottom sheet
        Get.find<MyAdsController>().fetchMyAds(); // Refresh ad list
        Get.snackbar('Success', 'Ad created successfully');
      } else {
        final data = jsonDecode(response.body);
        error.value = data['error'] ?? 'Failed to create ad';
        Get.snackbar('Error', error.value);
      }
    } catch (e) {
      error.value = 'Error creating ad: $e';
      Get.snackbar('Error', error.value);
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
