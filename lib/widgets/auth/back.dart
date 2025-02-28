import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class Back extends StatelessWidget {
  const Back({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.topLeft,
      child: TextButton(
        onPressed: () {
          Navigator.pop(context);
        },
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.arrow_back_ios_new, size: 16),
            Text("Back",
                style: TextStyle(fontSize: 14, color: AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }
}
