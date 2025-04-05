import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/core/controllers/admin/manage_ads_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class ManageAdsContent extends StatelessWidget {
  const ManageAdsContent({super.key});

  @override
  Widget build(BuildContext context) {
    final ManageAdsController controller = Get.put(ManageAdsController());

    final List<String> statusTabs = ['All', 'Pending', 'Approved', 'Rejected'];

    return DefaultTabController(
      length: statusTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Manage Ads"),
          backgroundColor: AppColors.secondary,
          titleTextStyle: AppTypography.subheading.copyWith(
            color: Colors.black,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
          bottom: TabBar(
            tabs: statusTabs.map((s) => Tab(text: s)).toList(),
            labelColor: Colors.black,
            indicatorColor: Colors.black,
            indicatorSize: TabBarIndicatorSize.tab,
            onTap: (index) {
              controller.selectedStatus.value = statusTabs[index].toLowerCase();
              controller.filterAds();
            },
          ),
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.error.value,
                      style: const TextStyle(color: Colors.red)),
                  const SizedBox(height: 16),
                  ElevatedButton(
                      onPressed: () => controller.fetchAds(),
                      child: const Text("Retry")),
                ],
              ),
            );
          }

          final ads = controller.filteredAds;

          if (ads.isEmpty) {
            return const Center(child: Text("No ads found"));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: ads.length,
            itemBuilder: (context, index) {
              final ad = ads[index];

              return ExpansionTile(
                tilePadding: const EdgeInsets.symmetric(horizontal: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                collapsedShape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                collapsedBackgroundColor: Colors.white,
                backgroundColor: Colors.white,
                childrenPadding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(ad['title'],
                          style: AppTypography.subheading.copyWith(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: _getStatusColor(ad['status']),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        ad['status'].toString().capitalizeFirst!,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 12),
                      ),
                    ),
                  ],
                ),
                children: [
                  _buildDetailRow("User", ad['user_name']),
                  _buildDetailRow("Category", ad['category_name']),
                  _buildDetailRow("Description", ad['description']),
                  _buildDetailRow(
                      "Price", "LKR ${ad['price'].toStringAsFixed(2)}"),
                  _buildDetailRow("Location", ad['location']),
                  _buildDetailRow(
                      "Negotiable", ad['negotiable'] == true ? "Yes" : "No"),
                  _buildDetailRow("Condition",
                      ad['item_condition'].toString().capitalizeFirst!),
                  if (ad['status'] == 'rejected' &&
                      ad['rejection_reason'] != null)
                    _buildDetailRow("Rejection Reason", ad['rejection_reason']),
                  const SizedBox(height: 10),
                  if (ad['status'] == 'pending')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () =>
                              _showRejectDialog(context, ad['id'], controller),
                          child: const Text("Reject",
                              style: TextStyle(color: Colors.redAccent)),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () => controller.approveAd(ad['id']),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: const Text("Approve"),
                        ),
                      ],
                    )
                ],
              );
            },
          );
        }),
      ),
    );
  }

  Widget _buildDetailRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("$title: ", style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child:
                  Text(value, style: const TextStyle(color: Colors.black87))),
        ],
      ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'active':
        return Colors.green;
      case 'approved':
        return Colors.green;
      case 'rejected':
        return Colors.red;
      case 'sold':
        return Colors.blue;
      case 'deleted':
        return Colors.grey;
      default:
        return Colors.black;
    }
  }

  void _showRejectDialog(
      BuildContext context, int adId, ManageAdsController controller) {
    final TextEditingController reasonController = TextEditingController();

    Get.dialog(
      AlertDialog(
        title: const Text("Reject Ad"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text("Please provide a reason for rejecting this ad:"),
            const SizedBox(height: 16),
            TextField(
              controller: reasonController,
              decoration: const InputDecoration(
                labelText: "Rejection Reason",
                border: OutlineInputBorder(),
              ),
              maxLines: 3,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text("Cancel")),
          ElevatedButton(
            onPressed: () {
              if (reasonController.text.isEmpty) {
                Get.snackbar('Error', 'Rejection reason is required');
                return;
              }
              controller.rejectAd(adId, reasonController.text);
              Get.back();
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text("Reject"),
          ),
        ],
      ),
    );
  }
}
