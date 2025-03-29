import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/add_ad_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class AddAdSheet extends StatelessWidget {
  const AddAdSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final AddAdController controller = Get.put(AddAdController());

    return Container(
      padding: const EdgeInsets.all(16.0),
      decoration: const BoxDecoration(
        color: AppColors.blue,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Add Post",
              style: AppTypography.subheading.copyWith(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            // Category Dropdown
            Obx(() => DropdownButtonFormField<int>(
                  decoration: InputDecoration(
                    labelText: "Category",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  value: controller.categoryId.value == 0 ? null : controller.categoryId.value,
                  items: [
                    const DropdownMenuItem<int>(
                      value: null,
                      child: Text("-- Select Category --"),
                    ),
                    ...controller.categories.map((category) => DropdownMenuItem<int>(
                          value: category['id'],
                          child: Text(category['name']),
                        )),
                  ],
                  onChanged: (value) {
                    if (value != null) {
                      controller.categoryId.value = value;
                      controller.categoryName.value = controller.categories
                          .firstWhere((cat) => cat['id'] == value)['name'];
                    }
                  },
                )),
            const SizedBox(height: 16),
            // Location Dropdown
            Obx(() => DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                    labelText: "Location",
                    labelStyle: const TextStyle(color: Colors.white),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  value: controller.location.value,
                  items: controller.locations
                      .map((loc) => DropdownMenuItem<String>(
                            value: loc,
                            child: Text(loc),
                          ))
                      .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      controller.location.value = value;
                    }
                  },
                )),
            const SizedBox(height: 16),
            // Title
            TextField(
              decoration: InputDecoration(
                labelText: "Enter Ad Title...",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              onChanged: (value) => controller.title.value = value,
            ),
            const SizedBox(height: 16),
            // Description
            TextField(
              decoration: InputDecoration(
                labelText: "About your ad...",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              maxLines: 3,
              onChanged: (value) => controller.description.value = value,
            ),
            const SizedBox(height: 16),
            // Price
            TextField(
              decoration: InputDecoration(
                labelText: "Price (LKR)",
                labelStyle: const TextStyle(color: Colors.white),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
              ),
              keyboardType: TextInputType.number,
              onChanged: (value) {
                controller.price.value = double.tryParse(value) ?? 0.0;
              },
            ),
            const SizedBox(height: 16),
            // Negotiable Toggle
            Row(
  children: [
    const Text("Negotiable", style: TextStyle(color: Colors.white)),
    const SizedBox(width: 16),
    Obx(() => Row(
          children: [
            Radio<bool>(
              value: true,
              groupValue: controller.negotiable.value,
              onChanged: (value) {
                if (value != null) controller.negotiable.value = value;
              },
              activeColor: Colors.white,
            ),
            const Text("Yes", style: TextStyle(color: Colors.white)),
            const SizedBox(width: 16),
            Radio<bool>(
              value: false,
              groupValue: controller.negotiable.value,
              onChanged: (value) {
                if (value != null) controller.negotiable.value = value;
              },
              activeColor: Colors.white,
            ),
            const Text("No", style: TextStyle(color: Colors.white)),
          ],
        )),
  ],
),
            const SizedBox(height: 16),
            // Item Condition
            Obx(() => Row(
                  children: [
                    const Text("Condition", style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 16),
                    Radio<String>(
                      value: 'new',
                      groupValue: controller.itemCondition.value,
                      onChanged: (value) {
                        if (value != null) controller.itemCondition.value = value;
                      },
                      activeColor: Colors.white,
                    ),
                    const Text("New", style: TextStyle(color: Colors.white)),
                    const SizedBox(width: 16),
                    Radio<String>(
                      value: 'used',
                      groupValue: controller.itemCondition.value,
                      onChanged: (value) {
                        if (value != null) controller.itemCondition.value = value;
                      },
                      activeColor: Colors.white,
                    ),
                    const Text("Used", style: TextStyle(color: Colors.white)),
                  ],
                )),
            const SizedBox(height: 16),
            // Submit Button
            ElevatedButton(
              onPressed: () => controller.createAd(),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.blue,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                minimumSize: const Size(double.infinity, 50),
              ),
              child: const Text("Submit"),
            ),
          ],
        ),
      ),
    );
  }
}