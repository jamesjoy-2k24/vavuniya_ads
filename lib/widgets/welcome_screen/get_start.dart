import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/auth/already_account.dart';

class GetStart extends StatelessWidget {
  const GetStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Get Started Button
        AppButton(
          text: "Get Started",
          onPressed: () {
            Navigator.pushReplacementNamed(context, "/register");
          },
        ),

        // Already have an account
        AlreadyAccount(
          message: "Already have an account?",
          actionText: "login",
          routeName: "/login",
        ),
      ],
    );
  }
}
