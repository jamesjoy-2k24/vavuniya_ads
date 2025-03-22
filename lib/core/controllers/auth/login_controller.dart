import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/widgets/pop_up.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

class LoginController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString phoneError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFormValid = false.obs;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_onPhoneChanged);
    passwordController.addListener(_onPasswordChanged);
    _updateFormValidity();
  }

  void _onPhoneChanged() {
    String text = phoneController.text.trim();
    if (text.isEmpty) {
      phoneError.value = "Please enter your mobile number";
    } else if (text.length > 10) {
      phoneController.text = text.substring(0, 10);
      phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length),
      );
    } else {
      phoneError.value = validatePhoneNumber(text) ?? '';
    }
    _updateFormValidity();
  }

  void _onPasswordChanged() {
    passwordError.value = validatePassword(passwordController.text) ?? '';
    _updateFormValidity();
  }

  void _updateFormValidity() {
    isFormValid.value = phoneError.isEmpty &&
        passwordError.isEmpty &&
        phoneController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
  }

  String? validatePhoneNumber(String? value) {
    if (value == null || value.isEmpty) {
      return "Please enter your mobile number";
    }
    if (value.length != 10 || !RegExp(r'^\d{10}$').hasMatch(value)) {
      return "Mobile number must be exactly 10 digits";
    }
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
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

    String phoneNumberValue = "+94${phoneController.text.trim().substring(1)}";
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
        final token = data['token'];
        final decodedToken = JwtDecoder.decode(token); // Decode JWT
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', decodedToken['user_id']);
        await prefs.setString('role', decodedToken['role'] ?? 'user');
        await prefs.setString('token', token);

        // Navigate based on role
        final route = decodedToken['role'] == 'admin'
            ? AppRoutes.adminDashboard
            : AppRoutes.home;
        showCustomDialogPopup(
          title: "Login Successful",
          content: "You have successfully logged in.",
          buttonText: "OK",
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
          onPressed: () => Get.offAllNamed(route),
        );
      } else {
        throw data['error'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
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
