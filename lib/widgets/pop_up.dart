import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/widgets/app/app_button.dart';

class CustomDialogPopup extends StatelessWidget {
  final IconData icon;
  final String title;
  final String content;
  final String buttonText;
  final VoidCallback? onPressed;
  final Color iconColor;
  final bool autoDismiss;

  const CustomDialogPopup({
    super.key,
    required this.icon,
    required this.title,
    required this.content,
    required this.buttonText,
    this.onPressed,
    this.iconColor = Colors.teal,
    this.autoDismiss = false,
  });

  @override
  Widget build(BuildContext context) {
    if (autoDismiss) {
      Future.delayed(const Duration(seconds: 2), () {
        if (Get.isDialogOpen ?? false) {
          Get.back();
          if (onPressed != null) onPressed!();
        }
      });
    }

    return AlertDialog(
      title: Text(
        title,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 24,
          color: Colors.black87,
        ),
      ),
      content: Text(
        content,
        textAlign: TextAlign.center,
        style: const TextStyle(
          fontSize: 16,
          color: Colors.black54,
        ),
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      backgroundColor: Colors.white,
      elevation: 8,
      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
      actions: [
        AppButton(
          text: buttonText,
          onPressed: onPressed ?? () => Get.back(),
        ),
      ],
      icon: Icon(
        icon,
        color: iconColor,
        size: 40,
      ),
    );
  }
}

void showCustomDialogPopup({
  required IconData icon,
  required String title,
  required String content,
  required String buttonText,
  VoidCallback? onPressed,
  Color iconColor = Colors.teal,
  bool barrierDismissible = true,
  bool autoDismiss = false,
}) {
  Get.dialog(
    CustomDialogPopup(
      icon: icon,
      title: title,
      content: content,
      buttonText: buttonText,
      onPressed: onPressed,
      iconColor: iconColor,
      autoDismiss: autoDismiss,
    ),
    barrierDismissible: barrierDismissible,
    barrierColor: Colors.black.withOpacity(0.3),
  );
}
