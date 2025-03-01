import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/auth/login_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Welcome Back",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Login to continue with your account",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    // Phone Input
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: "Phone Number",
                          hintText: "Enter your phone number",
                          controller: controller.phoneController,
                          icon: Icons.phone,
                          keyboardType: TextInputType.phone,
                        ),
                        Obx(
                          () => controller.errorMessage.isNotEmpty &&
                                  controller.phoneController.text.isEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, top: 4),
                                  child: Text(
                                    "Phone number is required",
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),

                    // Password Input
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: "Password",
                          hintText: "Enter your password",
                          controller: controller.passwordController,
                          obscureText: true,
                          icon: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        Obx(
                          () => controller.errorMessage.isNotEmpty &&
                                  controller.passwordController.text.isEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, top: 4),
                                  child: Text(
                                    "Password is required",
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Login Button
                    Obx(
                      () => AppButton(
                        text: "Login",
                        onPressed: controller.isFormValid.value
                            ? () => controller.login()
                            : () {},
                        isLoading: controller.isLoading.value,
                        color: AppColors.dark,
                        textColor: Colors.white,
                        fullWidth: true,
                      ),
                    ),

                    // Forgot Password (Optional)
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        // TODO: Implement forgot password flow
                        Get.snackbar(
                            "Info", "Forgot Password feature coming soon!");
                      },
                      child: const Text(
                        "Forgot Password?",
                        style: TextStyle(color: AppColors.link),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
