import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class PrivacyPolicy extends StatelessWidget {
  const PrivacyPolicy({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 2),
        child: Column(
          children: [
            RichText(
              textAlign: TextAlign.center,
              text: TextSpan(
                text: "If you are creating a new account,\n ",
                style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                children: [
                  TextSpan(
                    text: "Terms & Conditions",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle Terms & Conditions tap
                      },
                  ),
                  TextSpan(
                    text: " and ",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  ),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(
                        color: Colors.blue, fontWeight: FontWeight.bold),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        // Handle Privacy Policy tap
                      },
                  ),
                  TextSpan(
                    text: " will apply.",
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
