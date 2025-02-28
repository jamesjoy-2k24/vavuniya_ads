import 'package:flutter/material.dart';

class LogoWithText extends StatelessWidget {
  const LogoWithText({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          "assets/images/logo.png",
        ),
        SizedBox(height: 10),
        Text(
          "POST - BUY - SELL",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontSize: 16,
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.2,
                  ) ??
              TextStyle(
                fontSize: 16,
                color: Colors.black87,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
        ),
      ],
    );
  }
}
