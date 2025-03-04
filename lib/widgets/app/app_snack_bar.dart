import 'package:flutter/material.dart';

class AppSnackBar extends StatelessWidget {
  const AppSnackBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      content: Text('This is a custom SnackBar'),
      action: SnackBarAction(
      label: 'Undo',
      onPressed: () {
        // Some code to undo the change.
      },
      ),
    );
  }
}