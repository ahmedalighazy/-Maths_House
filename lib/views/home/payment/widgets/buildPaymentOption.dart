import 'package:flutter/material.dart';

Widget buildPaymentOption({
  required IconData icon,
  required String label,
  required VoidCallback onTap,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      width: double.infinity,

      padding: const EdgeInsets.symmetric(vertical: 60),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.red, size: 32),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w500,
              fontSize: 16,
            ),
          )
        ],
      ),
    ),
  );
}