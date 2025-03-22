import 'package:get/get.dart';

class HomeController extends GetxController {
  final RxList<Map<String, dynamic>> ads = <Map<String, dynamic>>[].obs;
  final RxBool isLoading = false.obs;

  void updateAds(List<Map<String, dynamic>> newAds) {
    ads.value = newAds;
  }
}
