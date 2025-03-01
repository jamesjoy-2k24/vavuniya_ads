import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:vavuniya_ads/core/controllers/auth/register_controller.dart';
import 'package:vavuniya_ads/widgets/pop_up.dart';

class OTPVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final RxBool isButtonDisabled = true.obs;
  final RxBool canResend = false.obs;
  final RxInt timerCount = 30.obs;
  final RxBool isLoading = false.obs;
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
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    isButtonDisabled.value = true;
    isLoading.value = true;

    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/verify_otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber, 'code': otp}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        showCustomDialogPopup(
          title: "Success",
          content: "OTP verification successful",
          icon: Icons.check_circle,
          buttonText: "Continue",
          onPressed: () => Get.back(),
        );

        await Future.delayed(const Duration(seconds: 2));
        Get.back();
        // Pass phoneNumber to RegisterFinal
        Get.offNamed("/register-final", arguments: {"phone": phoneNumber});
      } else {
        throw data['error'] ?? 'Unknown error';
      }
    } catch (e) {
      Get.snackbar("Error", "Verification failed: $e",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
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
