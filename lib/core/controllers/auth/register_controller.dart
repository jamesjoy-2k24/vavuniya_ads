import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class RegisterController extends GetxController {
  final TextEditingController phoneController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString phoneError = ''.obs;
  final RxString errorMessage = ''.obs;
  final RxBool isFormValid = false.obs;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    phoneController.addListener(_onPhoneChanged);
    _updateFormValidity();
  }

  void _onPhoneChanged() {
    String text = phoneController.text.trim();
    if (text.isEmpty) {
      phoneError.value = "Please enter your mobile number";
    } else if (text.length > 9) {
      phoneController.text = text.substring(0, 9);
      phoneController.selection = TextSelection.fromPosition(
        TextPosition(offset: phoneController.text.length),
      );
    } else {
      phoneError.value = validatePhoneNumber(text) ?? '';
    }
    _updateFormValidity();
  }

  void _updateFormValidity() {
    isFormValid.value = phoneError.isEmpty && phoneController.text.isNotEmpty;
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

  Future<void> sendOtp() async {
    if (!isFormValid.value) {
      Get.snackbar(
        "Error",
        "Please enter a valid mobile number",
        snackPosition: SnackPosition.TOP,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    String phoneNumberValue = "+94${phoneController.text.trim()}";
    isLoading.value = true;
    errorMessage.value = "";

    try {
      // Check if user exists
      final userExists = await http.post(
        Uri.parse('$baseUrl/api/auth/user_exists'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumberValue}),
      );

      final userExistsData = jsonDecode(userExists.body);
      if (userExists.statusCode != 200) {
        throw userExistsData['error'] ?? 'Failed to check user existence';
      }
      if (userExistsData['exists'] == true) {
        Get.snackbar(
          "Error",
          "This phone number is already registered",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
        return;
      }

      // Send OTP
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/send_otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumberValue}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.toNamed("/otp", arguments: {"phone": phoneNumberValue});
      } else {
        throw data['error'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = e.toString().replaceFirst('Exception: ', '');
      Get.snackbar(
        "Error",
        errorMessage.value,
        snackPosition: SnackPosition.TOP,
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
    phoneController.dispose();
    super.onClose();
  }
}
