import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/config/app_routes.dart';
import 'package:vavuniya_ads/core/controllers/auth/login_controller.dart';
import 'package:vavuniya_ads/widgets/auth/back.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/app/app_text_field.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/auth/already_account.dart';
import 'package:vavuniya_ads/widgets/auth/or_divider.dart';
import 'package:vavuniya_ads/widgets/auth/privacy.dart';
import 'package:vavuniya_ads/widgets/auth/social_icons.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height - 32,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Back(),
                          const SizedBox(height: 20),
                          Text("Welcome Back!", style: AppTypography.heading),
                          const SizedBox(height: 10),
                          Text(
                            "Enter your credentials to continue.",
                            style: AppTypography.caption,
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 30),

                          // Mobile Number Field
                          Obx(() => AppTextField(
                                label: "Mobile",
                                hintText: "Enter your mobile number",
                                controller: controller.phoneController,
                                keyboardType: TextInputType.number,
                                icon: Icons.phone_android_outlined,
                                errorText:
                                    controller.phoneError.value.isNotEmpty
                                        ? controller.phoneError.value
                                        : null,
                                onChanged: (value) {},
                                suffixIcon: IconButton(
                                  icon: const Icon(Icons.clear),
                                  onPressed: () {
                                    controller.phoneController.clear();
                                  },
                                ),
                              )),

                          // Password Field
                          Obx(
                            () => AppTextField(
                              label: "Password",
                              hintText: "Enter your password",
                              controller: controller.passwordController,
                              obscureText: true,
                              icon: Icons.lock_outline,
                              errorText:
                                  controller.passwordError.value.isNotEmpty
                                      ? controller.passwordError.value
                                      : null,
                              suffixIcon: IconButton(
                                icon: const Icon(Icons.visibility_off),
                                onPressed: () {
                                  // Toggle visibility (requires additional state in controller)
                                  // For now, placeholder
                                  Get.snackbar("Info", "Visibility toggle TBD");
                                },
                              ),
                              keyboardType: TextInputType.text,
                              onChanged: (value) {},
                            ),
                          ),

                          // Remember Me & Forgot Password
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Checkbox(
                                    value: false,
                                    onChanged: (value) {
                                      // TODO: Implement Remember Me
                                    },
                                    activeColor: AppColors.dark,
                                  ),
                                  const Text("Remember Me",
                                      style: TextStyle(
                                          color: AppColors.textPrimary)),
                                ],
                              ),
                              TextButton(
                                onPressed: () {
                                  Get.snackbar(
                                      "Info", "Forgot Password coming soon!");
                                },
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                    color: AppColors.link,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ],
                          ),

                          // Login Button
                          Obx(
                            () => AppButton(
                              text: "Login",
                              onPressed: controller.isFormValid.value
                                  ? controller.login
                                  : () {},
                              isLoading: controller.isLoading.value,
                              color: AppColors.dark,
                              textColor: Colors.white,
                              fullWidth: true,
                            ),
                          ),

                          // Register Link
                          AlreadyAccount(
                            message: "Don't have an account?",
                            actionText: "Register",
                            onTap: () => Get.offNamed(AppRoutes.register),
                          ),

                          // Social Login (placeholders)
                          const OrDivider(heading: "Or Login with"),
                          SocialIcons(
                            assetPath: "assets/images/fb.png",
                            text: "Continue With Facebook",
                            onPressed: () => Get.snackbar(
                                "Info", "Facebook login coming soon!"),
                          ),
                          SocialIcons(
                            assetPath: "assets/images/google.png",
                            text: "Continue With Google",
                            onPressed: () => Get.snackbar(
                                "Info", "Google login coming soon!"),
                          ),
                        ],
                      ),
                      const PrivacyPolicy(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
