import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:vavuniya_ads/presentation/screens/home_screen.dart';

class BottomBarController extends GetxController {
  final RxInt selectedIndex = 0.obs;

  void changeIndex(int index) {
    selectedIndex.value = index;
    switch (index) {
      case 0:
        Get.offAll(() => const HomeScreen());
        break;
      case 1:
        Get.toNamed('/chat');
        break;
      case 2:
        Get.toNamed('/post');
        break;
      case 3:
        Get.toNamed('/favorites');
        break;
      case 4:
        Get.toNamed('/profile');
        break;
    }
  }
}

class BottomBar extends StatelessWidget {
  const BottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BottomBarController());

    return Container(
      height: 60,
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.9),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: Obx(
        () => Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildNavItem(
              icon: Icons.home,
              index: 0,
              isSelected: controller.selectedIndex.value == 0,
              onTap: () => controller.changeIndex(0),
            ),
            _buildNavItem(
              icon: Icons.message,
              index: 1,
              isSelected: controller.selectedIndex.value == 1,
              onTap: () => controller.changeIndex(1),
            ),
            _buildNavItem(
              icon: Icons.add,
              index: 2,
              isSelected: controller.selectedIndex.value == 2,
              onTap: () => controller.changeIndex(2),
              isFab: true,
            ),
            _buildNavItem(
              icon: Icons.favorite,
              index: 3,
              isSelected: controller.selectedIndex.value == 3,
              onTap: () => controller.changeIndex(3),
            ),
            _buildNavItem(
              icon: Icons.person,
              index: 4,
              isSelected: controller.selectedIndex.value == 4,
              onTap: () => controller.changeIndex(4),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavItem({
    required IconData icon,
    required int index,
    required bool isSelected,
    required VoidCallback onTap,
    bool isFab = false,
  }) {
    return isFab
        ? Container(
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue,
            ),
            child: IconButton(
              icon: Icon(icon, size: 30, color: Colors.white),
              onPressed: onTap,
            ),
          )
        : IconButton(
            icon: Icon(
              icon,
              color: isSelected ? Colors.blue : Colors.grey,
              size: 28,
            ),
            onPressed: onTap,
          );
  }
}
