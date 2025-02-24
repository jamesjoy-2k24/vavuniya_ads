import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class GetStart extends StatelessWidget {
  const GetStart({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          
          // Get Started Button
          AppButton(
            text: "Get Started",
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/register");
            },
          ),

          SizedBox(height: 20),

          // Already have an account
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, "/login");
            },
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text("Already have an account?",
                    style:
                        TextStyle(fontSize: 14, color: AppColors.textPrimary)),
                SizedBox(width: 5),
                Text("Login",
                    style: TextStyle(
                        fontSize: 14,
                        color: AppColors.link,
                        fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
