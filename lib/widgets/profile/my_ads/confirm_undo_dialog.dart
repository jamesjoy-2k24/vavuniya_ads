import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/my_ads_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class ConfirmUndoDialog extends StatelessWidget {
  final int adId;

  const ConfirmUndoDialog({super.key, required this.adId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Restore Ad"),
      content: const Text("Do you want to restore this ad?"),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel", style: TextStyle(color: AppColors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
          onPressed: () {
            Get.find<MyAdsController>().undoDelete(adId);
            Get.back();
          },
          child: const Text("Restore"),
        ),
      ],
    );
  }
}
