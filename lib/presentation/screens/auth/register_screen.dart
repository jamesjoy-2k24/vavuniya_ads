import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/auth/already_account.dart';
import 'package:vavuniya_ads/widgets/auth/back.dart';
import 'package:vavuniya_ads/widgets/app/app_bg.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/widgets/auth/mobile_number_field.dart';
import 'package:vavuniya_ads/widgets/auth/or_divider.dart';
import 'package:vavuniya_ads/widgets/auth/privacy.dart';
import 'package:vavuniya_ads/widgets/auth/social_icons.dart';

class RegisterScreen extends StatelessWidget {
  RegisterScreen({super.key});

  final TextEditingController mobileController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AppBg(),
          SafeArea(
              child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Top Section
                      Column(
                        children: [
                          Back(),
                          SizedBox(height: 60),
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

                      // Body Section
                      Expanded(
                        child: Column(
                          children: [
                            MobileNumberField(
                              label: "Mobile Number",
                              hintText: "Enter your mobile number",
                              controller: mobileController,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please enter your mobile number";
                                }
                                if (value.length != 9) {
                                  return "Mobile number must be exactly 9 digits";
                                }
                                return null;
                              },
                            ),
                            AppButton(
                              text: "Send OTP",
                              onPressed: () {
                                if (Form.of(context).validate()) {
                                  Navigator.pushNamed(context, "/verify");
                                }
                              },
                            ),
                            AlreadyAccount(
                              message: "Already have an account?",
                              actionText: "Login",
                              routeName: "/login",
                            ),
                            OrDivider(heading: "Or login with"),
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

                      // Privacy Policy
                      PrivacyPolicy(),
                    ],
                  )))
        ],
      ),
    );
  }
}
