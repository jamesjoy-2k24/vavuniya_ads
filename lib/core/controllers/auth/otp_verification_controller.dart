import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:vavuniya_ads/widgets/pop_up.dart';

class OTPVerificationController extends GetxController {
  final TextEditingController otpController = TextEditingController();
  final RxBool isLoading = false.obs;
  final RxBool isButtonEnabled = false.obs;
  final RxBool canResend = false.obs;
  final RxInt timerCount = 30.obs;
  final RxString errorMessage = ''.obs;
  final String phoneNumber;

  static const String baseUrl = 'http://localhost/vavuniya_ads';

  OTPVerificationController({required this.phoneNumber});

  @override
  void onInit() {
    super.onInit();
    startTimer();
    otpController.addListener(_onOtpChanged);
  }

  void _onOtpChanged() {
    final otp = otpController.text.trim();
    isButtonEnabled.value = otp.length == 6;
    if (otp.length == 6) errorMessage.value = '';
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

  Future<void> verifyOTP() async {
    final otp = otpController.text.trim();
    if (otp.length != 6) {
      errorMessage.value = "Please enter a 6-digit OTP";
      return;
    }

    isLoading.value = true;
    errorMessage.value = '';

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
          content: "Phone number verified successfully!",
          icon: Icons.check_circle,
          iconColor: Colors.green,
          buttonText: "Continue",
          onPressed: () {
            Get.back(); // Close dialog
            Get.offNamed("/register-final", arguments: {"phone": phoneNumber});
          },
        );
      } else {
        throw data['error'] ?? 'Unknown error';
      }
    } catch (e) {
      errorMessage.value = e.toString() == 'Invalid or expired OTP'
          ? "The OTP is invalid or has expired"
          : "Verification failed. Please try again.";
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

  Future<void> resendOTP() async {
    if (!canResend.value) return;

    isLoading.value = true;
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/api/auth/send_otp'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'phone': phoneNumber}),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        Get.snackbar(
          "Success",
          "OTP resent successfully",
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.green,
          colorText: Colors.white,
        );
        startTimer();
      } else {
        throw data['error'] ?? 'Failed to resend OTP';
      }
    } catch (e) {
      errorMessage.value = "Failed to resend OTP. Please try again.";
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
    otpController.removeListener(_onOtpChanged);
    otpController.dispose();
    super.onClose();
  }
}
