import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/widgets/pop_up.dart';
import 'package:jwt_decoder/jwt_decoder.dart';

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
  final RxBool obscurePassword = true.obs;
  final RxBool obscureConfirmPassword = true.obs;
  final RxBool showErrors = false.obs; // New: Trigger error animations
  late String phoneNumber;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    phoneNumber = args?['phone'] ?? '';
    print(phoneNumber);
    nameController.addListener(_validateName);
    passwordController.addListener(_validatePassword);
    confirmPasswordController.addListener(_validateConfirmPassword);
    _updateFormValidity();
  }

  void _validateName() {
    nameError.value = validateName(nameController.text) ?? '';
    _updateFormValidity();
  }

  void _validatePassword() {
    passwordError.value = validatePassword(passwordController.text) ?? '';
    _validateConfirmPassword();
    _updateFormValidity();
  }

  void _validateConfirmPassword() {
    confirmPasswordError.value =
        validateConfirmPassword(confirmPasswordController.text) ?? '';
    _updateFormValidity();
  }

  void _updateFormValidity() {
    isFormValid.value = nameError.isEmpty &&
        passwordError.isEmpty &&
        confirmPasswordError.isEmpty &&
        nameController.text.isNotEmpty &&
        passwordController.text.isNotEmpty &&
        confirmPasswordController.text.isNotEmpty;
  }

  String? validateName(String? value) {
    if (value == null || value.trim().isEmpty) return "Name is required";
    if (value.trim().length < 2) return "Name must be at least 2 characters";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Password is required";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) return "Please confirm your password";
    if (value != passwordController.text) return "Passwords do not match";
    return null;
  }

  void togglePasswordVisibility() =>
      obscurePassword.value = !obscurePassword.value;
  void toggleConfirmPasswordVisibility() =>
      obscureConfirmPassword.value = !obscureConfirmPassword.value;

  Future<void> submit() async {
    _validateName();
    _validatePassword();
    _validateConfirmPassword();

    if (!isFormValid.value) {
      showErrors.value = true; // Trigger animations
      Future.delayed(const Duration(milliseconds: 500),
          () => showErrors.value = false); // Reset after shake

      // Focus first invalid field
      if (nameError.isNotEmpty) {
        FocusScope.of(Get.context!).requestFocus(FocusNode());
        nameController.selection = TextSelection.fromPosition(
            TextPosition(offset: nameController.text.length));
      } else if (passwordError.isNotEmpty) {
        FocusScope.of(Get.context!).requestFocus(FocusNode());
        passwordController.selection = TextSelection.fromPosition(
            TextPosition(offset: passwordController.text.length));
      } else if (confirmPasswordError.isNotEmpty) {
        FocusScope.of(Get.context!).requestFocus(FocusNode());
        confirmPasswordController.selection = TextSelection.fromPosition(
            TextPosition(offset: confirmPasswordController.text.length));
      }

      return;
    }

    isLoading.value = true;
    showErrors.value = false;

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
      if (response.statusCode == 201) {
        final token = data['token'];
        final decodedToken = JwtDecoder.decode(token);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isLoggedIn', true);
        await prefs.setInt('userId', decodedToken['sub']);
        await prefs.setString('role', decodedToken['role'] ?? 'user');
        await prefs.setString('token', token);

        showCustomDialogPopup(
          title: "Welcome!",
          content: "Registration complete. You're now logged in!",
          buttonText: "Get Started",
          icon: Icons.check_circle_rounded,
          iconColor: Colors.green,
          onPressed: () => Get.offAllNamed(AppRoutes.home),
        );
      } else {
        throw data['error'] ?? 'Registration failed';
      }
    } catch (e) {
      final errorMsg = e.toString().contains('Phone number already registered')
          ? "This phone number is already in use"
          : "Registration failed. Please try again.";
      Get.snackbar(
        "Error",
        errorMsg,
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
    nameController.removeListener(_validateName);
    passwordController.removeListener(_validatePassword);
    confirmPasswordController.removeListener(_validateConfirmPassword);
    nameController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
