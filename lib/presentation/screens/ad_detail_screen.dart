import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vavuniya_ads/core/controllers/home_controller.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';
import 'package:carousel_slider/carousel_slider.dart';

class AdDetailScreen extends StatelessWidget {
  const AdDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final HomeController controller = Get.find<HomeController>();
    final Map<String, dynamic> ad = Get.arguments ?? {};

    return Scaffold(
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppColors.dark))
            : CustomScrollView(
                slivers: [
                  _buildAppBar(context, controller, ad),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTitlePrice(ad),
                          const SizedBox(height: 16),
                          _buildImageCarousel(ad),
                          const SizedBox(height: 16),
                          _buildDetails(ad),
                          const SizedBox(height: 16),
                          _buildDescription(ad),
                          const SizedBox(height: 24),
                          FutureBuilder<Widget>(
                            future:
                                _buildActionButtons(context, controller, ad),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              } else if (snapshot.hasError) {
                                return const Center(
                                    child: Text('Error loading actions'));
                              } else {
                                return snapshot.data ?? const SizedBox.shrink();
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  SliverAppBar _buildAppBar(BuildContext context, HomeController controller,
      Map<String, dynamic> ad) {
    return SliverAppBar(
      expandedHeight: 200.0,
      floating: false,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          ad['title'] ?? 'Untitled',
          style: AppTypography.subheading.copyWith(color: Colors.white),
        ),
        background: ad['images']?.isNotEmpty == true
            ? Image.network(ad['images'][0], fit: BoxFit.cover)
            : Container(color: AppColors.grey),
      ),
      actions: [
        IconButton(
          icon: Icon(
            controller.favoriteAds.any((fav) => fav['id'] == ad['id'])
                ? Icons.favorite
                : Icons.favorite_border,
            color: Colors.redAccent,
          ),
          onPressed: () => controller.toggleFavorite(ad['id'].toString()),
        ),
      ],
    );
  }

  Widget _buildTitlePrice(Map<String, dynamic> ad) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            ad['title'] ?? 'Untitled',
            style: AppTypography.heading
                .copyWith(fontSize: 24, color: AppColors.textPrimary),
          ),
        ),
        Text(
          "LKR ${ad['price']?.toStringAsFixed(2) ?? '0.00'}",
          style: AppTypography.subheading
              .copyWith(fontSize: 20, color: AppColors.primary),
        ),
      ],
    );
  }

  Widget _buildImageCarousel(Map<String, dynamic> ad) {
    final images = ad['images'] as List<dynamic>? ?? [];
    return images.isEmpty
        ? Container(
            height: 200,
            color: AppColors.grey,
            child: const Center(
                child:
                    Text("No Images", style: TextStyle(color: Colors.white))),
          )
        : CarouselSlider(
            options: CarouselOptions(
              height: 200,
              autoPlay: true,
              enlargeCenterPage: true,
              aspectRatio: 16 / 9,
              viewportFraction: 0.8,
            ),
            items: images
                .map((imageUrl) => Image.network(imageUrl, fit: BoxFit.cover))
                .toList(),
          );
  }

  Widget _buildDetails(Map<String, dynamic> ad) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow(
                Icons.location_on, "Location", ad['location'] ?? 'Unknown'),
            _buildDetailRow(
                Icons.build, "Condition", ad['item_condition'] ?? 'Unknown'),
            _buildDetailRow(Icons.calendar_today, "Posted",
                ad['created_at']?.substring(0, 10) ?? 'Unknown'),
            _buildDetailRow(
                Icons.verified, "Status", ad['is_verified'] ?? 'Unknown'),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 8),
          Text("$label: ",
              style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value, style: AppTypography.body)),
        ],
      ),
    );
  }

  Widget _buildDescription(Map<String, dynamic> ad) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Description",
            style: AppTypography.subheading.copyWith(fontSize: 18)),
        const SizedBox(height: 8),
        Text(
          ad['description'] ?? 'No description available.',
          style: AppTypography.body.copyWith(color: AppColors.textSecondary),
        ),
      ],
    );
  }

  Future<Widget> _buildActionButtons(BuildContext context,
      HomeController controller, Map<String, dynamic> ad) async {
    final userId = (await SharedPreferences.getInstance())
        .getString('user_id'); // Adjust based on your auth
    final isOwner = userId != null && userId == ad['user_id'].toString();

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton.icon(
          onPressed: () =>
              Get.snackbar("Contact", "Contact seller feature coming soon!"),
          icon: const Icon(Icons.message),
          label: const Text("Contact Seller"),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          ),
        ),
        if (isOwner) ...[
          ElevatedButton.icon(
            onPressed: () => _showEditDialog(context, controller, ad),
            icon: const Icon(Icons.edit),
            label: const Text("Edit"),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.secondary,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
          ElevatedButton.icon(
            onPressed: () =>
                _confirmDelete(context, controller, ad['id'].toString()),
            icon: const Icon(Icons.delete),
            label: const Text("Delete"),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ],
    );
  }

  void _showEditDialog(BuildContext context, HomeController controller,
      Map<String, dynamic> ad) {
    final titleController = TextEditingController(text: ad['title']);
    final descController = TextEditingController(text: ad['description']);
    final priceController =
        TextEditingController(text: ad['price']?.toString());

    Get.dialog(
      AlertDialog(
        title: const Text("Edit Ad"),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: const InputDecoration(labelText: "Title"),
              ),
              TextField(
                controller: descController,
                decoration: const InputDecoration(labelText: "Description"),
                maxLines: 3,
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "Price (LKR)"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.updateAd(ad['id'].toString(), {
                'title': titleController.text,
                'description': descController.text,
                'price': double.tryParse(priceController.text) ?? ad['price'],
              });
              Get.back();
            },
            child: const Text("Save"),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(
      BuildContext context, HomeController controller, String adId) {
    Get.dialog(
      AlertDialog(
        title: const Text("Confirm Delete"),
        content: const Text("Are you sure you want to delete this ad?"),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              controller.deleteAd(adId);
              Get.back();
              Get.back(); // Return to previous screen
            },
            child: const Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
