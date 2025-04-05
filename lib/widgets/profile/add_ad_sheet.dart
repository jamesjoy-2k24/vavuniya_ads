import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/user/add_ad_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class AddAdSheet extends StatelessWidget {
  const AddAdSheet({super.key});

  // Unified Input Decoration
  InputDecoration _buildInputDecoration(String hintText,
      {bool isOptional = false}) {
    return InputDecoration(
      hintText: hintText,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      suffixIcon: isOptional
          ? const Padding(
              padding: EdgeInsets.only(right: 12.0),
              child: Text(
                'Optional',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
            )
          : null,
    );
  }

  // Label Style
  TextStyle _labelStyle() {
    return const TextStyle(
      color: Colors.black87,
      fontSize: 16,
      fontWeight: FontWeight.bold,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AddAdController controller = Get.put(AddAdController());

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Add New Ad",
                  style: AppTypography.subheading.copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
                // IconButton(
                //   icon: const Icon(Icons.close, color: Colors.black87),
                //   onPressed: () => Get.back(),
                // ),
              ],
            ),
            const SizedBox(height: 24),

            // Category
            Text("Category", style: _labelStyle()),
            const SizedBox(height: 8),
            Obx(() => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    value: controller.categoryId.value == 0
                        ? null
                        : controller.categoryId.value,
                    hint: const Text("Select Category"),
                    items: controller.categories
                        .map((category) => DropdownMenuItem<int>(
                              value: category['id'],
                              child: Text(category['name']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.categoryId.value = value;
                        controller.categoryName.value = controller.categories
                            .firstWhere((cat) => cat['id'] == value)['name'];
                        controller.fetchSubcategories(value);
                      }
                    },
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                )),
            const SizedBox(height: 24),

            // Subcategory
            Text("Subcategory", style: _labelStyle()),
            const SizedBox(height: 8),
            Obx(() => Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: DropdownButtonFormField<int>(
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    ),
                    value: controller.subcategoryId.value == 0
                        ? null
                        : controller.subcategoryId.value,
                    hint: const Text("Select Subcategory"),
                    items: controller.subcategories
                        .map((subcategory) => DropdownMenuItem<int>(
                              value: subcategory['id'],
                              child: Text(subcategory['name']),
                            ))
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        controller.subcategoryId.value = value;
                        controller.subcategoryName.value =
                            controller.subcategories.firstWhere(
                                (subcat) => subcat['id'] == value)['name'];
                      }
                    },
                    dropdownColor: Colors.white,
                    style: const TextStyle(color: Colors.black87, fontSize: 16),
                  ),
                )),
            const SizedBox(height: 24),

            // Location
            Text("Location", style: _labelStyle()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: _buildInputDecoration("Enter Your Location..."),
                onChanged: (value) => controller.location.value = value,
              ),
            ),
            const SizedBox(height: 24),

            // Title
            Text("Title", style: _labelStyle()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: _buildInputDecoration("Enter Ad Title..."),
                onChanged: (value) => controller.title.value = value,
              ),
            ),
            const SizedBox(height: 24),

            // Description
            Text("Description", style: _labelStyle()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: _buildInputDecoration("About your ad..."),
                maxLines: 4,
                onChanged: (value) => controller.description.value = value,
              ),
            ),
            const SizedBox(height: 24),

            // Price
            Text("Price (LKR)", style: _labelStyle()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: _buildInputDecoration("Enter Price"),
                keyboardType: TextInputType.number,
                onChanged: (value) {
                  controller.price.value = double.tryParse(value) ?? 0.0;
                },
              ),
            ),
            const SizedBox(height: 24),

            // Negotiable
            Text("Negotiable", style: _labelStyle()),
            const SizedBox(height: 8),
            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Radio<bool>(
                              value: true,
                              groupValue: controller.negotiable.value,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.negotiable.value = value;
                                }
                              },
                              activeColor: Colors.blueAccent,
                            ),
                            const Text("Yes",
                                style: TextStyle(color: Colors.black87)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Radio<bool>(
                              value: false,
                              groupValue: controller.negotiable.value,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.negotiable.value = value;
                                }
                              },
                              activeColor: Colors.blueAccent,
                            ),
                            const Text("No",
                                style: TextStyle(color: Colors.black87)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),

            // Condition
            Text("Condition", style: _labelStyle()),
            const SizedBox(height: 8),
            Obx(() => Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        blurRadius: 8,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'new',
                              groupValue: controller.itemCondition.value,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.itemCondition.value = value;
                                }
                              },
                              activeColor: Colors.blueAccent,
                            ),
                            const Text("New",
                                style: TextStyle(color: Colors.black87)),
                          ],
                        ),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Radio<String>(
                              value: 'used',
                              groupValue: controller.itemCondition.value,
                              onChanged: (value) {
                                if (value != null) {
                                  controller.itemCondition.value = value;
                                }
                              },
                              activeColor: Colors.blueAccent,
                            ),
                            const Text("Used",
                                style: TextStyle(color: Colors.black87)),
                          ],
                        ),
                      ),
                    ],
                  ),
                )),
            const SizedBox(height: 24),

            // Name (Optional)
            Text("Name", style: _labelStyle()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration:
                    _buildInputDecoration("Enter Your Name", isOptional: true),
                onChanged: (value) => controller.name.value = value,
              ),
            ),
            const SizedBox(height: 24),

            // Contact Number (Optional)
            Text("Contact Number", style: _labelStyle()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: _buildInputDecoration("Enter Contact Number",
                    isOptional: true),
                keyboardType: TextInputType.phone,
                onChanged: (value) => controller.contactNo.value = value,
              ),
            ),
            const SizedBox(height: 24),

            // Contact Email (Optional)
            Text("Contact Email", style: _labelStyle()),
            const SizedBox(height: 8),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: TextField(
                decoration: _buildInputDecoration("Enter Contact Email",
                    isOptional: true),
                keyboardType: TextInputType.emailAddress,
                onChanged: (value) => controller.contactEmail.value = value,
              ),
            ),
            const SizedBox(height: 24),

            // Error Message
            Obx(() {
              if (controller.error.value.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Text(
                    controller.error.value,
                    style:
                        const TextStyle(color: Colors.redAccent, fontSize: 14),
                  ),
                );
              }
              return const SizedBox.shrink();
            }),

            // Submit Button
            Obx(() => ElevatedButton(
                  onPressed: controller.isLoading.value
                      ? null
                      : () => controller.createAd(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blueAccent,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    minimumSize: const Size(double.infinity, 56),
                    elevation: 5,
                  ),
                  child: controller.isLoading.value
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "Submit Ad",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                )),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
