// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'package:vavuniya_ads/core/controllers/home/home_controller.dart';
// import 'package:vavuniya_ads/widgets/app/app_color.dart';
// import 'package:vavuniya_ads/widgets/app/app_typography.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'package:share_plus/share_plus.dart';

// class AdDetailScreen extends StatelessWidget {
//   const AdDetailScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final HomeController controller = Get.find<HomeController>();
//     final Rx<Map<String, dynamic>> ad =
//         Rx<Map<String, dynamic>>(Get.arguments ?? {});

//     _fetchAdDetails(controller, ad);

//     return Scaffold(
//       body: Obx(
//         () => controller.isLoading.value && ad.value.isEmpty
//             ? const Center(
//                 child: LoadingIndicator())
//             : CustomScrollView(
//                 slivers: [
//                   _buildAppBar(context, ad),
//                   SliverToBoxAdapter(
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: FadeTransition(
//                         opacity: const AlwaysStoppedAnimation(1.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             _buildTitlePrice(ad),
//                             const SizedBox(height: 16),
//                             _buildImageCarousel(context, ad),
//                             const SizedBox(height: 16),
//                             _buildDetails(ad),
//                             const SizedBox(height: 16),
//                             _buildDescription(ad),
//                           ],
//                         ),
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//       ),
//       floatingActionButton: Obx(
//         () => FloatingActionButton(
//           onPressed: ad.value['id'] != null
//               ? () => controller.toggleFavorite(ad.value['id'].toString())
//               : null,
//           backgroundColor:
//               ad.value['id'] != null ? AppColors.primary : AppColors.grey,
//           child: Icon(
//             ad.value['is_favorite'] == true
//                 ? Icons.favorite
//                 : Icons.favorite_border,
//             color: Colors.white,
//           ),
//         ),
//       ),
//       bottomNavigationBar: FutureBuilder<Widget>(
//         future: _buildBottomActions(context, controller, ad),
//         builder: (context, snapshot) =>
//             snapshot.connectionState == ConnectionState.done && snapshot.hasData
//                 ? snapshot.data!
//                 : const SizedBox.shrink(),
//       ),
//     );
//   }

//   void _fetchAdDetails(HomeController controller, Rx<Map<String, dynamic>> ad) {
//     if (ad.value['id'] != null) {
//       controller.fetchAdDetail(ad.value['id'].toString()).then((freshAd) {
//         if (freshAd != null) ad.value = freshAd;
//       });
//     }
//   }

//   SliverAppBar _buildAppBar(BuildContext context, Rx<Map<String, dynamic>> ad) {
//     return SliverAppBar(
//       expandedHeight: 200.0,
//       floating: false,
//       pinned: true,
//       backgroundColor: AppColors.primary,
//       flexibleSpace: FlexibleSpaceBar(
//         title: Text(
//           ad.value['title'] ?? 'Untitled',
//           style: AppTypography.subheading.copyWith(color: Colors.white),
//           overflow: TextOverflow.ellipsis,
//         ),
//         background: (ad.value['images'] as List?)?.isNotEmpty == true
//             ? Image.network(ad.value['images'][0], fit: BoxFit.cover)
//             : Container(color: AppColors.grey),
//       ),
//       actions: [
//         IconButton(
//           icon: const Icon(Icons.share, color: Colors.white),
//           onPressed: () => Share.share(
//             'Check out this ad: ${ad.value['title']} - LKR ${ad.value['price']?.toStringAsFixed(2) ?? '0.00'} at ${ad.value['location'] ?? 'Unknown'}',
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildTitlePrice(Rx<Map<String, dynamic>> ad) {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Expanded(
//           child: Text(
//             ad.value['title'] ?? 'Untitled',
//             style: AppTypography.heading
//                 .copyWith(fontSize: 24, color: AppColors.textPrimary),
//             maxLines: 2,
//             overflow: TextOverflow.ellipsis,
//           ),
//         ),
//         Text(
//           "LKR ${ad.value['price']?.toStringAsFixed(2) ?? '0.00'}",
//           style: AppTypography.subheading
//               .copyWith(fontSize: 20, color: AppColors.primary),
//         ),
//       ],
//     );
//   }

//   Widget _buildImageCarousel(
//       BuildContext context, Rx<Map<String, dynamic>> ad) {
//     final images = (ad.value['images'] as List?)?.cast<String>() ?? [];
//     return images.isEmpty
//         ? Container(
//             height: 200,
//             color: AppColors.grey,
//             child: const Center(
//                 child:
//                     Text("No Images", style: TextStyle(color: Colors.white))),
//           )
//         : Column(
//             children: [
//               CarouselSlider(
//                 options: CarouselOptions(
//                   height: 200,
//                   autoPlay: images.length > 1,
//                   enlargeCenterPage: true,
//                   aspectRatio: 16 / 9,
//                   viewportFraction: 0.8,
//                   enableInfiniteScroll: images.length > 1,
//                   onPageChanged: (index, reason) =>
//                       ad.value['currentImageIndex'] = index,
//                 ),
//                 items: images.map((imageUrl) {
//                   return GestureDetector(
//                     onTap: () => _showFullScreenImage(context, imageUrl),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(8),
//                       child: Image.network(
//                         imageUrl,
//                         fit: BoxFit.cover,
//                         width: double.infinity,
//                         errorBuilder: (_, __, ___) =>
//                             const Icon(Icons.broken_image, size: 50),
//                       ),
//                     ),
//                   );
//                 }).toList(),
//               ),
//               if (images.length > 1) ...[
//                 const SizedBox(height: 8),
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: images.map((url) {
//                     final index = images.indexOf(url);
//                     return Container(
//                       width: 8.0,
//                       height: 8.0,
//                       margin: const EdgeInsets.symmetric(horizontal: 4.0),
//                       decoration: BoxDecoration(
//                         shape: BoxShape.circle,
//                         color: index == (ad.value['currentImageIndex'] ?? 0)
//                             ? AppColors.primary
//                             : AppColors.grey,
//                       ),
//                     );
//                   }).toList(),
//                 ),
//               ],
//             ],
//           );
//   }

//   void _showFullScreenImage(BuildContext context, String imageUrl) {
//     Get.dialog(
//       GestureDetector(
//         onTap: Get.back,
//         child: InteractiveViewer(
//             child: Image.network(imageUrl, fit: BoxFit.contain)),
//       ),
//       barrierDismissible: true,
//     );
//   }

//   Widget _buildDetails(Rx<Map<String, dynamic>> ad) {
//     return Card(
//       elevation: 2,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             _buildDetailRow(Icons.location_on, "Location",
//                 ad.value['location'] ?? 'Unknown'),
//             _buildDetailRow(Icons.build, "Condition",
//                 ad.value['item_condition'] ?? 'Unknown'),
//             _buildDetailRow(Icons.calendar_today, "Posted",
//                 ad.value['created_at']?.substring(0, 10) ?? 'Unknown'),
//             _buildDetailRow(
//                 Icons.verified, "Status", ad.value['status'] ?? 'Unknown'),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildDetailRow(IconData icon, String label, String value) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Icon(icon, size: 20, color: AppColors.primary),
//           const SizedBox(width: 8),
//           Text("$label: ",
//               style: AppTypography.body.copyWith(fontWeight: FontWeight.bold)),
//           Expanded(child: Text(value, style: AppTypography.body)),
//         ],
//       ),
//     );
//   }

//   Widget _buildDescription(Rx<Map<String, dynamic>> ad) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text("Description",
//             style: AppTypography.subheading.copyWith(fontSize: 18)),
//         const SizedBox(height: 8),
//         Text(
//           ad.value['description'] ?? 'No description available.',
//           style: AppTypography.body.copyWith(color: AppColors.textSecondary),
//         ),
//       ],
//     );
//   }

//   Future<Widget> _buildBottomActions(BuildContext context,
//       HomeController controller, Rx<Map<String, dynamic>> ad) async {
//     final prefs = await SharedPreferences.getInstance();
//     final userId = prefs.getString('user_id');
//     final isOwner = userId != null && userId == ad.value['user_id']?.toString();

//     return BottomAppBar(
//       child: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             ElevatedButton.icon(
//               onPressed: () => Get.snackbar(
//                   "Contact", "Contact seller feature coming soon!",
//                   snackPosition: SnackPosition.BOTTOM),
//               icon: const Icon(Icons.message),
//               label: const Text("Contact Seller"),
//               style: ElevatedButton.styleFrom(
//                 backgroundColor: AppColors.primary,
//                 foregroundColor: Colors.white,
//                 shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(8)),
//               ),
//             ),
//             PopupMenuButton<String>(
//               onSelected: (value) {
//                 switch (value) {
//                   case 'edit':
//                     if (isOwner) _showEditDialog(context, controller, ad);
//                     break;
//                   case 'delete':
//                     if (isOwner) {
//                       _confirmDelete(
//                           context, controller, ad.value['id'].toString());
//                     }
//                     break;
//                   case 'report':
//                     Get.snackbar("Report", "Report ad feature coming soon!");
//                     break;
//                 }
//               },
//               itemBuilder: (context) => [
//                 if (isOwner)
//                   const PopupMenuItem(value: 'edit', child: Text("Edit")),
//                 if (isOwner)
//                   const PopupMenuItem(value: 'delete', child: Text("Delete")),
//                 const PopupMenuItem(value: 'report', child: Text("Report Ad")),
//               ],
//               icon: const Icon(Icons.more_vert),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   void _showEditDialog(BuildContext context, HomeController controller,
//       Rx<Map<String, dynamic>> ad) {
//     final titleController = TextEditingController(text: ad.value['title']);
//     final descController = TextEditingController(text: ad.value['description']);
//     final priceController =
//         TextEditingController(text: ad.value['price']?.toString());
//     final locationController =
//         TextEditingController(text: ad.value['location']);
//     final conditionController =
//         TextEditingController(text: ad.value['item_condition']);
//     final RxList<XFile> selectedImages = <XFile>[].obs;
//     final RxList<String> existingImages =
//         (ad.value['images'] as List?)?.cast<String>().toList().obs ??
//             <String>[].obs;

//     Get.dialog(
//       AlertDialog(
//         title: const Text("Edit Ad"),
//         content: SingleChildScrollView(
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: [
//               TextField(
//                   controller: titleController,
//                   decoration: const InputDecoration(labelText: "Title")),
//               TextField(
//                   controller: descController,
//                   decoration: const InputDecoration(labelText: "Description"),
//                   maxLines: 3),
//               TextField(
//                   controller: priceController,
//                   decoration: const InputDecoration(labelText: "Price (LKR)"),
//                   keyboardType: TextInputType.number),
//               TextField(
//                   controller: locationController,
//                   decoration: const InputDecoration(labelText: "Location")),
//               DropdownButtonFormField<String>(
//                 value: conditionController.text.isNotEmpty
//                     ? conditionController.text
//                     : null,
//                 decoration: const InputDecoration(labelText: "Condition"),
//                 items: ['new', 'used']
//                     .map((condition) => DropdownMenuItem(
//                         value: condition, child: Text(condition.capitalize!)))
//                     .toList(),
//                 onChanged: (value) =>
//                     conditionController.text = value ?? 'used',
//               ),
//               const SizedBox(height: 16),
//               ElevatedButton(
//                 onPressed: () async {
//                   final picker = ImagePicker();
//                   final pickedFiles = await picker.pickMultiImage();
//                   selectedImages.addAll(pickedFiles);
//                 },
//                 child: const Text("Add Images"),
//               ),
//               Obx(
//                 () => Wrap(
//                   spacing: 8,
//                   children: [
//                     ...existingImages.map((url) => Stack(
//                           children: [
//                             Image.network(url,
//                                 width: 100, height: 100, fit: BoxFit.cover),
//                             Positioned(
//                               right: 0,
//                               child: IconButton(
//                                 icon: const Icon(Icons.remove_circle,
//                                     color: Colors.red),
//                                 onPressed: () => existingImages.remove(url),
//                               ),
//                             ),
//                           ],
//                         )),
//                     ...selectedImages.map((file) => Stack(
//                           children: [
//                             Image.file(File(file.path),
//                                 width: 100, height: 100, fit: BoxFit.cover),
//                             Positioned(
//                               right: 0,
//                               child: IconButton(
//                                 icon: const Icon(Icons.remove_circle,
//                                     color: Colors.red),
//                                 onPressed: () => selectedImages.remove(file),
//                               ),
//                             ),
//                           ],
//                         )),
//                   ],
//                 ),
//               ),
//             ],
//           ),
//         ),
//         actions: [
//           TextButton(onPressed: Get.back, child: const Text("Cancel")),
//           TextButton(
//             onPressed: () {
//               final updatedData = {
//                 'title': titleController.text,
//                 'description': descController.text,
//                 'price':
//                     double.tryParse(priceController.text) ?? ad.value['price'],
//                 'location': locationController.text,
//                 'item_condition': conditionController.text,
//                 'images': existingImages.toList(),
//               };
//               controller
//                   .updateAd(ad.value['id'].toString(), updatedData,
//                       images: selectedImages.toList())
//                   .then((_) {
//                 ad.value = {
//                   ...ad.value,
//                   ...updatedData,
//                   'images': [
//                     ...existingImages,
//                     ...(selectedImages.map((x) => x.path).toList())
//                   ]
//                 };
//                 Get.back();
//               });
//             },
//             child: const Text("Save"),
//           ),
//         ],
//       ),
//     );
//   }

//   void _confirmDelete(
//       BuildContext context, HomeController controller, String adId) {
//     Get.dialog(
//       AlertDialog(
//         title: const Text("Confirm Delete"),
//         content: const Text("Are you sure you want to delete this ad?"),
//         actions: [
//           TextButton(onPressed: Get.back, child: const Text("Cancel")),
//           TextButton(
//             onPressed: () {
//               controller.deleteAd(adId);
//               Get.back();
//               Get.back();
//             },
//             child: const Text("Delete", style: TextStyle(color: Colors.red)),
//           ),
//         ],
//       ),
//     );
//   }
// }
