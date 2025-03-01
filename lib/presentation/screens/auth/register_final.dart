import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/auth/register_final_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_text_field.dart';

class RegisterFinal extends StatelessWidget {
  const RegisterFinal({super.key});

  @override
  Widget build(BuildContext context) {
    final RegisterFinalController controller =
        Get.put(RegisterFinalController());

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
                      "Enter Your Details",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 24,
                              ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Enter your details to complete registration and \n continue with your account.",
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[700],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 30),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: "Name",
                          hintText: "Enter your name",
                          controller: controller.nameController,
                          keyboardType: TextInputType.numberWithOptions(),
                          validator: controller.validateName,
                          icon: Icons.person_outline,
                        ),
                        Obx(
                          () => controller.nameError.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, top: 4),
                                  child: Text(
                                    controller.nameError.value,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: "Password",
                          hintText: "Enter your password",
                          controller: controller.passwordController,
                          keyboardType: TextInputType.visiblePassword,
                          obscureText: true,
                          validator: controller.validatePassword,
                          icon: Icons.lock_outline,
                        ),
                        Obx(
                          () => controller.passwordError.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, top: 4),
                                  child: Text(
                                    controller.passwordError.value,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AppTextField(
                          label: "Confirm Password",
                          hintText: "Confirm your password",
                          controller: controller.confirmPasswordController,
                          obscureText: true,
                          validator: controller.validateConfirmPassword,
                          icon: Icons.lock_outline,
                          keyboardType: TextInputType.visiblePassword,
                        ),
                        Obx(
                          () => controller.confirmPasswordError.isNotEmpty
                              ? Padding(
                                  padding:
                                      const EdgeInsets.only(left: 16, top: 4),
                                  child: Text(
                                    controller.confirmPasswordError.value,
                                    style: const TextStyle(
                                        color: Colors.red, fontSize: 12),
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Button
                    Obx(
                      () => AppButton(
                        text: "Done",
                        onPressed: controller.isFormValid.value
                            ? () => controller.submit()
                            : () {},
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
          ),
        ],
      ),
    );
  }
}
