import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/core/controllers/auth/register_final_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_text_field.dart';

class RegisterFinal extends StatelessWidget {
  const RegisterFinal({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(RegisterFinalController());

    return Scaffold(
      body: Stack(
        children: [
          const AppBg(),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "Complete Your Profile",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 28,
                                color: AppColors.dark,
                              ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      "Add your name and password to finish registration.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                            fontSize: 16,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),

                    // Name Field
                    Obx(
                      () => AppTextField(
                        label: "Name",
                        hintText: "e.g., John Doe",
                        controller: controller.nameController,
                        keyboardType: TextInputType.text,
                        errorText: controller.nameError.value.isNotEmpty
                            ? controller.nameError.value
                            : null,
                        icon: Icons.person_outline,
                        suffixIcon: IconButton(
                          icon: controller.nameError.value.isNotEmpty
                              ? const Icon(Icons.error_outline,
                                  color: Colors.red)
                              : const Icon(Icons.check, color: Colors.green),
                          onPressed: () {},
                        ),
                        onChanged: (value) {},
                      ).animate(
                        effects: controller.showErrors.value &&
                                controller.nameError.value.isNotEmpty
                            ? [
                                const ShakeEffect(
                                    duration: Duration(milliseconds: 300))
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Password Field
                    Obx(
                      () => AppTextField(
                        label: "Password",
                        hintText: "Min 6 characters",
                        controller: controller.passwordController,
                        keyboardType: TextInputType.text,
                        onChanged: (value) {},
                        obscureText: controller.obscurePassword.value,
                        errorText: controller.passwordError.value.isNotEmpty
                            ? controller.passwordError.value
                            : null,
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscurePassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color: controller.passwordError.value.isNotEmpty
                                ? Colors.red
                                : Colors.grey,
                          ),
                          onPressed: controller.togglePasswordVisibility,
                        ),
                      ).animate(
                        effects: controller.showErrors.value &&
                                controller.passwordError.value.isNotEmpty
                            ? [
                                const ShakeEffect(
                                    duration: Duration(milliseconds: 300))
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Confirm Password Field
                    Obx(
                      () => AppTextField(
                        label: "Confirm Password",
                        hintText: "Repeat password",
                        controller: controller.confirmPasswordController,
                        obscureText: controller.obscureConfirmPassword.value,
                        errorText:
                            controller.confirmPasswordError.value.isNotEmpty
                                ? controller.confirmPasswordError.value
                                : null,
                        icon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            controller.obscureConfirmPassword.value
                                ? Icons.visibility_off
                                : Icons.visibility,
                            color:
                                controller.confirmPasswordError.value.isNotEmpty
                                    ? Colors.red
                                    : Colors.grey,
                          ),
                          onPressed: controller.toggleConfirmPasswordVisibility,
                        ),
                        keyboardType: TextInputType.text,
                        onChanged: (value) {},
                      ).animate(
                        effects: controller.showErrors.value &&
                                controller.confirmPasswordError.value.isNotEmpty
                            ? [
                                const ShakeEffect(
                                    duration: Duration(milliseconds: 300))
                              ]
                            : [],
                      ),
                    ),
                    const SizedBox(height: 30),

                    // Submit Button with Tooltip
                    Obx(
                      () => Tooltip(
                        message: controller.isFormValid.value
                            ? "Finish registration"
                            : "Please fix the errors above",
                        child: AppButton(
                          text: controller.isLoading.value
                              ? "Registering..."
                              : "Finish",
                          onPressed: controller.isLoading.value
                              ? () {}
                              : controller.submit,
                          isLoading: controller.isLoading.value,
                          color: controller.isFormValid.value
                              ? AppColors.dark
                              : Colors.grey,
                          textColor: Colors.white,
                          fullWidth: true,
                        ),
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
