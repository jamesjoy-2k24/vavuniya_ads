import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:vavuniya_ads/core/controllers/home/first_time_notice_controller.dart';

class FirstTimeNotice extends StatelessWidget {
  const FirstTimeNotice({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FirstTimeNoticeController());

    return Obx(
      () => controller.isFirstVisit.value
          ? Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Card(
                elevation: 4,
                color: AppColors.secondary.withOpacity(0.95),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Icon with subtle animation
                      const Icon(
                        Icons.store_rounded,
                        color: AppColors.blue,
                        size: 40,
                      )
                          .animate()
                          .scale(duration: 500.ms, curve: Curves.easeInOut),
                      const SizedBox(width: 16),
                      // Welcome Text
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Welcome to Vavuniya Ads!",
                              style: AppTypography.body.copyWith(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              "Discover amazing deals near you.",
                              style: AppTypography.caption.copyWith(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Dismiss Button
                      IconButton(
                        icon: const Icon(Icons.close, color: AppColors.dark),
                        onPressed: controller.dismissFirstVisit,
                        tooltip: "Dismiss",
                      ),
                    ],
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }
}
