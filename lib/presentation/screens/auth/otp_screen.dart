import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/auth/otp_verification_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/auth/otp_input.dart';

class OtpScreen extends StatelessWidget {
  final String phoneNumber;

  const OtpScreen({super.key, required this.phoneNumber});

  static final OTPVerificationController controller =
      Get.put(OTPVerificationController(), permanent: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Verify OTP"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Stack(
        children: [
          AppBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Verification Code",
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 24,
                        ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    "We have just sent you a 6-digit code via your mobile number starting with $phoneNumber",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[700],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),

                  // OTP Input Boxes
                  OTPInputBoxes(controller: controller),
                  const SizedBox(height: 20),

                  // Resend Text
                  Obx(
                    () => Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Didn’t receive code? ",
                          style: TextStyle(color: Colors.grey[700]),
                        ),
                        GestureDetector(
                          onTap: controller.canResend.value
                              ? controller.resendOTP
                              : null,
                          child: Text(
                            "Resend Code",
                            style: TextStyle(
                              color: controller.canResend.value
                                  ? AppColors.link
                                  : Colors.grey,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        if (!controller.canResend.value)
                          Text(
                            " (${controller.timerCount.value}s)",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Verify Button
                  Obx(
                    () => AppButton(
                      text: "Verify",
                      onPressed: controller.isButtonDisabled.value
                          ? () {}
                          : () => controller
                              .verifyOTP(controller.otpController.text),
                      isLoading: controller.isLoading.value,
                      color: AppColors.dark,
                      textColor: Colors.white,
                      fullWidth: true,
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
