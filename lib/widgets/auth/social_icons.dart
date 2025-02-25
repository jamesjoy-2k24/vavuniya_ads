import 'package:flutter/material.dart';

class SocialIcons extends StatelessWidget {
  final String text;
  final String assetPath;
  final VoidCallback onPressed;

  const SocialIcons({
    super.key,
    required this.text,
    required this.onPressed,
    required this.assetPath,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(color: Colors.grey.shade300),
          ),
          padding: EdgeInsets.symmetric(vertical: 12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Image.asset(assetPath, width: 20),
            ),
            SizedBox(width: 12),
            Flexible(
              child: Text(
                text,
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.w600),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
