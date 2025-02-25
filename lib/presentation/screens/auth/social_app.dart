import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SocialLoginButtons extends StatelessWidget {
  const SocialLoginButtons({super.key});

  get icon => null;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          icon: Icon(Icons.facebook),
          onPressed: () {
            // Login with Facebook
          },
        ),
        IconButton(
          icon: FaIcon(FontAwesomeIcons.google),
          onPressed: () {
            // Login with Google
          },
        ),
      ],
    );
  }
}
