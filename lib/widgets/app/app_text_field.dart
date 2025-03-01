import 'package:flutter/material.dart';
import 'package:vavuniya_ads/widgets/app/app_color.dart';
import 'package:vavuniya_ads/widgets/app/app_typography.dart';

class AppTextField extends StatefulWidget {
  final String label;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final Color? fillColor;
  final Color? borderColor;
  final double borderRadius;
  final IconData? icon;

  const AppTextField({
    super.key,
    required this.label,
    required this.hintText,
    required this.controller,
    this.obscureText = false,
    this.validator,
    this.prefixIcon,
    this.fillColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.icon, required TextInputType keyboardType,
  });

  @override
  _AppTextFieldState createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: widget.controller,
            obscureText: _obscureText,
            validator: widget.validator,
            style: AppTypography.body.copyWith(color: AppColors.textPrimary),
            decoration: InputDecoration(
              filled: false,
              labelText: widget.label,
              labelStyle: TextStyle(
                color: AppColors.textPrimary.withOpacity(0.8),
                fontWeight: FontWeight.w600,
              ),
              hintText: widget.hintText,
              hintStyle: AppTypography.body.copyWith(
                color: AppColors.grey.withOpacity(0.7),
              ),
              prefixIcon: widget.prefixIcon != null
                  ? Icon(
                      widget.prefixIcon,
                      color: AppColors.dark.withOpacity(0.7),
                      size: 20,
                    )
                  : null,
              suffixIcon: widget.obscureText
                  ? IconButton(
                      icon: Icon(
                        _obscureText ? Icons.visibility_off : Icons.visibility,
                        color: AppColors.dark.withOpacity(0.7),
                      ),
                      onPressed: () {
                        setState(() {
                          _obscureText = !_obscureText;
                        });
                      },
                    )
                  : null,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 16, // Increased vertical padding
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide.none,
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: widget.borderColor ?? Colors.grey.withOpacity(0.3),
                  width: 1,
                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: BorderSide(
                  color: AppColors.dark.withOpacity(0.7),
                  width: 1.5,
                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(widget.borderRadius),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              floatingLabelBehavior: FloatingLabelBehavior.auto, // Adjusted
            ),
          ),
        ],
      ),
    );
  }
}
