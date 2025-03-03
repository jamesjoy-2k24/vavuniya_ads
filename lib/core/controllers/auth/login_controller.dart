import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/widgets/pop_up.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString phoneNumber = "".obs;
  final RxString errorMessage = ''.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxBool isFormValid = false.obs;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_onPhoneChanged);
    passwordController.addListener(_onPasswordChanged);
    _updateFormValidity(); // Initial check
  }

  void _onPhoneChanged() {
    String text = phoneController.text.trim();
    if (text.isEmpty) {
      phoneError.value = "Please enter your mobile number";
      phoneNumber.value = "";
    } else if (text.startsWith("0")) {
      phoneController.text = text.substring(1);
      phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length),
      );
    } else if (text.length > 9) {
      phoneController.text = text.substring(0, 9);
      phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length),
      );
    } else {
      phoneNumber.value = phoneController.text;
      phoneError.value = validatePhoneNumber(phoneNumber.value) ?? '';
    }
    _updateFormValidity();
  }

  void _onPasswordChanged() {
    validatePassword(passwordController.text);
    _updateFormValidity();
  }

  void _updateFormValidity() {
    isFormValid.value = phoneError.isEmpty && passwordError.isEmpty;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your mobile number";
    }
    if (value.length != 9 || !RegExp(r'^\d{9}$').hasMatch(value)) {
      return "Mobile number must be exactly 9 digits";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      passwordError.value = "Password is required";
      return passwordError.value;
    }
    if (value.length < 6) {
      passwordError.value = "Password must be at least 6 characters";
      return passwordError.value;
    }
    passwordError.value = '';
    return null;
  }

  Future<void> login() async {
    if (!isFormValid.value) {
      Get.snackbar(
        "Error",
        "Please fill all fields correctly",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    String phoneNumberValue = "+94${phoneController.text.trim()}";
    String password = passwordController.text;
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
        await prefs.setString('token', data['token'] ?? '');

        showCustomDialogPopup(
          title: "Login Successful",
          content: "You have successfully logged in.",
          buttonText: "OK",
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
          onPressed: () {
            Get.back();
            Get.offAllNamed(AppRoutes.home);
          },
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        Get.offAllNamed(AppRoutes.home);
      } else {
        throw data['error'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = "Login failed : $e";
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    phoneController.removeListener(_onPhoneChanged);
    passwordController.removeListener(_onPasswordChanged);
    phoneController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
