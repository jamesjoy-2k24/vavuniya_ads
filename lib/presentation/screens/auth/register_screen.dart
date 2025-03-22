import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/core/controllers/auth/register_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/auth/back.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/auth/already_account.dart';
import 'package:vavuniya_ads/widgets/auth/mobile_number_field.dart';
import 'package:vavuniya_ads/widgets/auth/or_divider.dart';
import 'package:vavuniya_ads/widgets/auth/privacy.dart';
import 'package:vavuniya_ads/widgets/auth/social_icons.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterController controller = Get.put(RegisterController());

    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Back(),
                  const SizedBox(height: 50),
                  Text("Your Mobile Number", style: AppTypography.heading),
                  const SizedBox(height: 10),
                  Text(
                    "We'll send you an OTP to verify.",
                    style: AppTypography.caption,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  Obx(
                    () => MobileNumberField(
                      label: "Mobile Number",
                      hintText: "771234567",
                      controller: controller.phoneController,
                      validator: controller.validatePhoneNumber,
                      fillColor: Colors.white,
                      errorText: controller.phoneError.value.isNotEmpty
                          ? controller.phoneError.value
                          : null,
                    ),
                  ),
                  Obx(
                    () => controller.errorMessage.value.isNotEmpty
                        ? Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              controller.errorMessage.value,
                              style: const TextStyle(
                                  color: Colors.red, fontSize: 12),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                  const SizedBox(height: 20),
                  Obx(
                    () => AppButton(
                      text: controller.isLoading.value
                          ? "Sending..."
                          : "Send OTP",
                      onPressed: controller.isLoading.value
                          ? () {}
                          : controller.sendOtp,
                      color: AppColors.dark,
                      textColor: Colors.white,
                      fullWidth: true,
                      icon: controller.isLoading.value
                          ? const Padding(
                              padding: EdgeInsets.only(left: 10),
                              child: SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              ),
                            )
                          : null,
                    ),
                  ),
                  const SizedBox(height: 20),
                  AlreadyAccount(
                    message: "Already have an account?",
                    actionText: "Login",
                    onTap: () => Get.offNamed(AppRoutes.login),
                  ),
                  const OrDivider(heading: "Or Register with"),
                  SocialIcons(
                    assetPath: "assets/images/fb.png",
                    text: "Continue With Facebook",
                    onPressed: () =>
                        Get.snackbar("Info", "Facebook login coming soon!"),
                  ),
                  SocialIcons(
                    assetPath: "assets/images/google.png",
                    text: "Continue With Google",
                    onPressed: () =>
                        Get.snackbar("Info", "Google login coming soon!"),
                  ),
                  const Spacer(),
                  const PrivacyPolicy(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
