import 'package:flutter/material.dart';

class AppBg extends StatelessWidget {
  const AppBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 0, 219, 243),
            Color.fromARGB(255, 183, 244, 255)
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
      ),
    );
  }
}
