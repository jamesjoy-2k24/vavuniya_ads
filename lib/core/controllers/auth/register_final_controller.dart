import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vavuniya_ads/widgets/pop_up.dart';

class RegisterFinalController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final RxBool isLoading = false.obs;
  final RxString nameError = ''.obs;
  final RxString passwordError = ''.obs;
  final RxString confirmPasswordError = ''.obs;
  final RxBool isFormValid = false.obs;
  late String phoneNumber;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    phoneNumber = args?['phone'] ?? '';
    nameController.addListener(_updateFormValidity);
    passwordController.addListener(_updateFormValidity);
    confirmPasswordController.addListener(_updateFormValidity);
    _updateFormValidity(); // Initial check
  }

  void _updateFormValidity() {
    validateName(nameController.text);
    validatePassword(passwordController.text);
    validateConfirmPassword(confirmPasswordController.text);
    isFormValid.value = nameError.isEmpty &&
        passwordError.isEmpty &&
        confirmPasswordError.isEmpty;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      nameError.value = "Name is required";
      return nameError.value;
    }
    if (value.trim().length < 2) {
      nameError.value = "Name must be at least 2 characters";
      return nameError.value;
    }
    nameError.value = '';
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

  String? validateConfirmPassword(String? value) {
    if (value != passwordController.text) {
      confirmPasswordError.value = "Passwords do not match";
      return confirmPasswordError.value;
    }
    confirmPasswordError.value = '';
    return null;
  }

  Future<void> submit() async {
    if (!isFormValid.value) {
      Get.snackbar("Error", "Please fill all fields correctly",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'phone': phoneNumber,
          'name': nameController.text.trim(),
          'password': passwordController.text,
        }),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showCustomDialogPopup(
            title: "Registration Successful",
            content: "You have successfully registered! Logging you in...",
            buttonText: "OK",
            icon: Icons.check_circle_rounded,
            iconColor: Colors.green,
            onPressed: () {
              Get.back();
              Get.offAllNamed("/home");
            });
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        Get.offAllNamed("/home");
      } else {
        throw data['error'] ?? 'Unknown error';
      }
    } catch (e) {
      Get.snackbar("Error", "Registration failed: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  @override
   void onClose() {
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
