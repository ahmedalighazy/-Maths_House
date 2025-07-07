import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String status;
  final Color statusColor;
  final IconData statusIcon;
  final List<Widget> details;
  final bool showButtons;
  final String primaryButtonText;
  final String secondaryButtonText;
  final VoidCallback? onPrimaryPressed;
  final VoidCallback? onSecondaryPressed;

  const CustomCard({
    super.key,
    required this.title,
    required this.status,
    required this.statusColor,
    required this.statusIcon,
    required this.details,
    this.showButtons = false,
    this.primaryButtonText = '',
    this.secondaryButtonText = '',
    this.onPrimaryPressed,
    this.onSecondaryPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    Icon(statusIcon, size: 16, color: statusColor),
                    const SizedBox(width: 4),
                    Text(status, style: TextStyle(color: statusColor)),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Details
          ...details,
          const SizedBox(height: 12),

          // Buttons
          if (showButtons)
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: onPrimaryPressed,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(primaryButtonText, style: const TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: OutlinedButton(
                    onPressed: onSecondaryPressed,
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(secondaryButtonText, style: const TextStyle(color: AppColors.primary)),
                  ),
                ),
              ],
            )
        ],
      ),
    );
  }
}
