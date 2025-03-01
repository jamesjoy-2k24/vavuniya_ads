import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFormValid = false.obs;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_updateFormValidity);
    passwordController.addListener(_updateFormValidity);
    _updateFormValidity();
  }

  void _updateFormValidity() {
    final phone = phoneController.text.trim();
    final password = passwordController.text;
    isFormValid.value = phone.length == 9 && RegExp(r'^\d{9}$').hasMatch(phone) && password.length >= 6;
  }

  Future<void> login() async {
    String phoneNumberValue = "+94${phoneController.text.trim()}";
    String password = passwordController.text;

    if (!isFormValid.value) {
      errorMessage.value = "Please enter a valid phone number and password";
      Get.snackbar("Error", errorMessage.value, snackPosition: SnackPosition.BOTTOM);
      return;
    }

    isLoading.value = true;
    errorMessage.value = "";

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phoneNumberValue,
          'password': password,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', data['user_id']);
        Get.dialog(
          AlertDialog(
            title: const Text("Success"),
            content: const Text("Login Successful!"),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          barrierDismissible: false,
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        Get.offAllNamed("/home");
      } else {
        throw data['error'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = "Login failed: $e";
      Get.snackbar("Error", errorMessage.value, snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}