import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/auth/already_account.dart';

class GetStart extends StatelessWidget {
  final VoidCallback onGetStarted;
  final VoidCallback onLogin;

  const GetStart({
    super.key,
    required this.onGetStarted,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppButton(
          text: "Get Started",
          onPressed: onGetStarted,
        ),
        AlreadyAccount(
          message: "Already have an account?",
          actionText: "Login",
          onTap: onLogin,
        ),
      ],
    );
  }
}
