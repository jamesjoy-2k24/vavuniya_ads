import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstTimeNoticeController extends GetxController {
  final RxBool isFirstVisit = true.obs;

  @override
  void onInit() {
    super.onInit();
    _checkFirstVisit();
  }

  Future<void> _checkFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    final hasSeenNotice = prefs.getBool('hasSeenFirstTimeNotice') ?? false;
    isFirstVisit.value = !hasSeenNotice;
  }

  Future<void> dismissFirstVisit() async {
    isFirstVisit.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenFirstTimeNotice', true);
  }

  // Optional: Reset for testing
  Future<void> resetFirstVisit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('hasSeenFirstTimeNotice');
    isFirstVisit.value = true;
  }
}
