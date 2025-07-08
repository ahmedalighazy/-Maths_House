import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';

class CustomPasswordField extends StatelessWidget {
  final bool isPasswordVisible;
  final bool obscureText;
  final VoidCallback onToggleVisibility;

  const CustomPasswordField({
    super.key,
    required this.isPasswordVisible,
    required this.obscureText,
    required this.onToggleVisibility,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      decoration: InputDecoration(
        prefixIcon: Icon(Icons.lock, color: AppColors.primary),
        labelText: 'Password',
        labelStyle: TextStyle(color: AppColors.primary),
        filled: true,
        fillColor: Colors.grey.shade100,
        contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: AppColors.primary, width: 2),
        ),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AppColors.primary,
          ),
          onPressed: onToggleVisibility,
        ),
      ),
    );
  }
}
