import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Color(0xFFE0E0E0),
            Color(0xFFE0E0E0),
          ],
        ),
      ),
      child: const Center(
        child: Text('Home Screen'),
      ),
    );
  }
}
