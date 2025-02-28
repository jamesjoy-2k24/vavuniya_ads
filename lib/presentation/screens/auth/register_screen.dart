import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/auth/back.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/auth/privacy.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/auth/or_divider.dart';
import 'package:vavuniya_ads/widgets/auth/social_icons.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/auth/already_account.dart';
import 'package:vavuniya_ads/widgets/auth/mobile_number_field.dart';
import 'package:vavuniya_ads/core/controllers/auth/register_controller.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final RegisterController controller = Get.put(RegisterController());

  @override
  Widget build(BuildContext context) {
    final bool showBackButton =
        ModalRoute.of(context)?.settings.arguments as bool? ?? false;

    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Column(
                    children: [
                      if (showBackButton) Back(),
                      SizedBox(height: 50),
                      Text(
                        "Your Mobile Number",
                        style: AppTypography.heading,
                      ),
                      SizedBox(height: 10),
                      Text(
                        "We'll send you an authentication code\nor OTP next.",
                        style: AppTypography.caption,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                    ],
                  ),
                  Expanded(
                    child: Column(
                      children: [
                        MobileNumberField(
                          label: "Mobile Number",
                          hintText: "Enter your mobile number",
                          controller: controller.phoneController,
                          validator: controller.validatePhoneNumber,
                        ),
                        Obx(() {
                          final error = controller.errorMessage.value;
                          return error.isNotEmpty
                              ? Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 5),
                                  child: Text(
                                    error,
                                    style: AppTypography.caption.copyWith(
                                      color: Colors.red,
                                    ),
                                  ),
                                )
                              : SizedBox.shrink();
                        }),
                        SizedBox(height: 10),
                        Obx(() => AppButton(
                              text: controller.isLoading.value
                                  ? "Sending..."
                                  : "Send OTP",
                              onPressed: controller.isLoading.value
                                  ? () {}
                                  : controller.sendOtp,
                              icon: controller.isLoading.value
                                  ? Padding(
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
                            )),
                        AlreadyAccount(
                          message: "Already have an account?",
                          actionText: "Login",
                          onTap: () {
                            Get.offNamed(AppRoutes.login);
                          },
                        ),
                        OrDivider(heading: "Or Register with"),
                        SocialIcons(
                          assetPath: "assets/images/fb.png",
                          text: "Continue With Facebook",
                          onPressed: () {},
                        ),
                        SocialIcons(
                          assetPath: "assets/images/google.png",
                          text: "Continue With Google",
                          onPressed: () {},
                        ),
                      ],
                    ),
                  ),
                  PrivacyPolicy(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
