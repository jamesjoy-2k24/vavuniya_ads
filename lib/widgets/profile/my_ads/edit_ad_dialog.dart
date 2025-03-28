import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/my_ads_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class EditAdDialog extends StatelessWidget {
  final Map<String, dynamic> ad;

  const EditAdDialog({super.key, required this.ad});

  @override
  Widget build(BuildContext context) {
    final titleController = TextEditingController(text: ad['title']);
    final descController = TextEditingController(text: ad['description']);
    final imageController = TextEditingController(text: ad['imageUrl'] ?? "");

    final formKey = GlobalKey<FormState>();

    return AlertDialog(
      title: const Text(
        "Edit Ad",
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      content: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildTextField(
                controller: titleController,
                label: "Title",
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Title is required"
                    : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                controller: descController,
                label: "Description",
                maxLines: 3,
                validator: (value) => value == null || value.trim().isEmpty
                    ? "Description is required"
                    : null,
              ),
              const SizedBox(height: 12),
              _buildTextField(
                  controller: imageController, label: "Image URL (optional)"),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text("Cancel", style: TextStyle(color: AppColors.grey)),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.secondary,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
          onPressed: () {
            if (formKey.currentState!.validate()) {
              Get.find<MyAdsController>().editAd(
                ad['id'],
                titleController.text.trim(),
                descController.text.trim(),
                imageController.text.trim().isEmpty
                    ? null
                    : imageController.text.trim(),
              );

              Get.back();
              Get.snackbar(
                "Success",
                "Ad updated successfully",
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                margin: const EdgeInsets.all(16),
              );
            }
          },
          child: const Text("Save"),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      validator: validator,
    );
  }
}
