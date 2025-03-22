import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/core/controllers/auth/otp_verification_controller.dart';

class OTPInputBoxes extends StatelessWidget {
  final OTPVerificationController controller;

  const OTPInputBoxes({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    // List of FocusNodes for each box
    final List<FocusNode> focusNodes = List.generate(6, (_) => FocusNode());

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: List.generate(6, (index) {
        return SizedBox(
          width: 50,
          height: 50,
          child: TextField(
            focusNode: focusNodes[index],
            onChanged: (value) {
              if (value.length == 1) {
                // Update otpController safely
                String currentText =
                    controller.otpController.text.padRight(6, ' ');
                controller.otpController.text =
                    currentText.substring(0, index) +
                        value +
                        currentText.substring(index + 1, 6);
                controller.isButtonEnabled.value =
                    controller.otpController.text.trim().length != 6;

                // Move focus to next box
                if (index < 5) {
                  FocusScope.of(context).requestFocus(focusNodes[index + 1]);
                } else {
                  FocusScope.of(context).unfocus();
                }
              } else if (value.isEmpty) {
                // Clear the digit and move back
                String currentText =
                    controller.otpController.text.padRight(6, ' ');
                controller.otpController.text =
                    '${currentText.substring(0, index)} ${currentText.substring(index + 1, 6)}';
                controller.isButtonEnabled.value =
                    controller.otpController.text.trim().length != 6;

                if (index > 0) {
                  FocusScope.of(context).requestFocus(focusNodes[index - 1]);
                }
              }
            },
            keyboardType: TextInputType.number,
            textAlign: TextAlign.center,
            maxLength: 1,
            decoration: InputDecoration(
              counterText: '',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.dark, width: 2),
              ),
            ),
          ),
        );
      }),
    );
  }
}
