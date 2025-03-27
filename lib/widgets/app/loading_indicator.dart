import 'package:flutter/cupertino.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CupertinoActivityIndicator(
      radius: 18,
      color: AppColors.dark,
    );
  }
} 
