import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';

Widget buildDropdown(
    String label,
    String? selectedValue,
    List<String> items,
    Function(String?) onChanged,
    ) {
  return DropdownButtonFormField<String>(
    value: selectedValue,
    decoration: InputDecoration(
      labelText: label,
      labelStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: Colors.grey.shade100,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: AppColors.primary),
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    icon: const Icon(Icons.keyboard_arrow_down, color: AppColors.primary),
    items: items.map((item) => DropdownMenuItem(value: item, child: Text(item))).toList(),
    onChanged: onChanged,
  );
}