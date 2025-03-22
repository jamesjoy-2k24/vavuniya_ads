import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/auth/otp_verification_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/auth/otp_input.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  @override
  Widget build(BuildContext context) {
    final controller =
        Get.put(OTPVerificationController(phoneNumber: phoneNumber));

    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Verify Your Number",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 28,
                          color: AppColors.dark,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "Enter the 6-digit code sent to\n$phoneNumber",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                          fontSize: 16,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 40),

                  // OTP Input
                  OTPInputBoxes(controller: controller),
                  const SizedBox(height: 24),

                  // Error Message
                  Obx(
                    () => controller.errorMessage.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 8.0),
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 14),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),

                  // Verify Button
                  Obx(
                    () => AppButton(
                      text: controller.isLoading.value
                          ? "Verifying..."
                          : "Verify",
                      onPressed: controller.isButtonEnabled.value &&
                              !controller.isLoading.value
                          ? () {}
                          : () => controller.verifyOTP(),
                      isLoading: controller.isLoading.value,
                      color: AppColors.dark,
                      textColor: Colors.white,
                      fullWidth: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Resend Option
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn't receive a code? ",
                          style:
                              TextStyle(color: Colors.grey[700], fontSize: 14),
                        ),
                        GestureDetector(
                          onTap: controller.canResend.value
                              ? controller.resendOTP
                              : null,
                          child: Text(
                            "Resend",
                            style: TextStyle(
                              color: controller.canResend.value
                                  ? AppColors.link
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        if (!controller.canResend.value)
                          Text(
                            " (${controller.timerCount.value}s)",
                            style: TextStyle(
                                color: Colors.grey[700], fontSize: 14),
                          ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
