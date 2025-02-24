import 'package:flutter/material.dart';

class AppBg extends StatelessWidget {
  const AppBg({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
      gradient: LinearGradient(
        colors: [Color(0xFF00E3FD), Color(0xFFC4F6FF)],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ),
      ),
    );
  }
}
