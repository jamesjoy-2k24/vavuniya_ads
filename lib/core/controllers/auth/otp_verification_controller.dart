import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vavuniya_ads/core/controllers/auth/register_controller.dart';

class OTPVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final RxBool isButtonDisabled = true.obs;
  final RxBool canResend = false.obs;
  final RxInt timerCount = 30.obs;
  final RxBool isLoading = false.obs; // Added for button loading
  late String phoneNumber;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>?;
    phoneNumber = args?['phone'] ?? '';
    startTimer();
    otpController.addListener(_onOtpChanged);
  }

  void _onOtpChanged() {
    final otp = otpController.text.trim();
    isButtonDisabled.value = otp.length != 6;
  }

  void startTimer() {
    canResend.value = false;
    timerCount.value = 30;
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (timerCount.value > 0) {
        timerCount.value--;
      } else {
        canResend.value = true;
        timer.cancel();
      }
    });
  }

  Future<void> verifyOTP(String otp) async {
    if (otp.length != 6) {
      Get.snackbar("Error", "Please enter a 6-digit OTP",
          snackPosition: SnackPosition.TOP);
      return;
    }

    isButtonDisabled.value = true;
    isLoading.value = true; // Show loading

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify_otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber, 'code': otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.dialog(
          AlertDialog(
            title: const Text("Success"),
            content: const Text("OTP Verified Successfully!"),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          barrierDismissible: false,
        );
        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        Get.offNamed("/register-final"); // Redirect to RegisterFinal
      } else {
        throw data['error'] ?? 'Unknown error';
      }
    } catch (e) {
      Get.snackbar("Error", "Verification failed: $e",
          snackPosition: SnackPosition.TOP);
    } finally {
      isLoading.value = false; // Hide loading
      isButtonDisabled.value = false;
    }
  }

  Future<void> resendOTP() async {
    if (!canResend.value) return;
    await Get.find<RegisterController>().sendOtp();
    startTimer();
  }

  @override
  void onClose() {
    otpController.removeListener(_onOtpChanged);
    otpController.dispose();
    super.onClose();
  }
}
