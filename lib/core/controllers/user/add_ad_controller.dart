import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/core/controllers/user/my_ads_controller.dart';

class AddAdController extends GetxController {
  final RxInt categoryId = 0.obs;
  final RxString categoryName = '-- Select Category --'.obs;
  final RxInt subcategoryId = 0.obs;
  final RxString subcategoryName = '-- Select Subcategory --'.obs;
  final RxString location = ''.obs;
  final RxString title = ''.obs;
  final RxString description = ''.obs;
  final RxDouble price = 0.0.obs;
  final RxBool negotiable = false.obs;
  final RxString itemCondition = 'new'.obs;
  final RxString name = ''.obs;
  final RxString contactNo = ''.obs;
  final RxString contactEmail = ''.obs;
  final RxString error = ''.obs;
  final RxBool isLoading = false.obs;
  final RxList<Map<String, dynamic>> categories = <Map<String, dynamic>>[].obs;
  final RxList<Map<String, dynamic>> subcategories =
      <Map<String, dynamic>>[].obs;
  static const String baseUrl = 'http://localhost/vavuniya_ads';

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
        Uri.parse('$baseUrl/api/categories/list'),
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

  Future<void> fetchSubcategories(int categoryId) async {
    try {
      subcategories.clear();
      subcategoryId.value = 0;
      subcategoryName.value = '-- Select Subcategory --';
      final token = await _getToken();
      final response = await http.get(
        Uri.parse('$baseUrl/api/categories/list?parent_id=$categoryId'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        subcategories.value =
            List<Map<String, dynamic>>.from(data['categories'] ?? []);
      } else {
        error.value = 'Failed to load subcategories';
        Get.snackbar('Error', error.value);
      }
    } catch (e) {
      error.value = 'Error fetching subcategories: $e';
      Get.snackbar('Error', error.value);
    }
  }

  Future<void> createAd() async {
    try {
      isLoading.value = true;
      error.value = '';
      if (categoryId.value == 0 ||
          subcategoryId.value == 0 ||
          location.value == '-- Select Location --' ||
          title.value.isEmpty ||
          description.value.isEmpty) {
        error.value = 'Please fill all required fields';
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
        Uri.parse('$baseUrl/api/ads/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'category_id': categoryId.value,
          'subcategory_id': subcategoryId.value,
          'location': location.value,
          'title': title.value,
          'description': description.value,
          'price': price.value,
          'negotiable': negotiable.value,
          'images': [],
          'item_condition': itemCondition.value,
          'is_featured': false,
          'contact_no': contactNo.value.isEmpty ? null : contactNo.value,
          'contact_email':
              contactEmail.value.isEmpty ? null : contactEmail.value,
        }),
      );

      if (response.statusCode == 201) {
        Get.back();
        Get.find<MyAdsController>().fetchMyAds();
        Get.snackbar('Success', 'Ad created successfully');
      } else {
        final data = jsonDecode(response.body);
        error.value = data['error'] ?? 'Failed to create ad';
        Get.snackbar('Error', error.value);
      }
    } catch (e) {
      error.value = 'Error creating ad: $e';
      Get.snackbar('Error', error.value);
    } finally {
      isLoading.value = false;
    }
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('token') ?? '';
  }
}
