import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/my_ads_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class ConfirmDeleteDialog extends StatelessWidget {
  final int adId;

  const ConfirmDeleteDialog({super.key, required this.adId});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text("Delete Ad"),
      content: const Text(
          "Are you sure you want to delete this ad? It will be scheduled for deletion in 1 day."),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel", style: TextStyle(color: AppColors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
          onPressed: () {
            Get.find<MyAdsController>().deleteAd(adId);
            Get.back();
          },
          child: const Text("Delete"),
        ),
      ],
    );
  }
}
