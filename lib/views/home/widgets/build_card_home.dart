import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';

class HomeCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final int count;
  final VoidCallback? onTap;

  const HomeCard({
    super.key,
    required this.icon,
    required this.title,
    required this.count,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          SizedBox(
            height: 240,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.primaryLight,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon, size: 48, color: AppColors.primary),
                  const SizedBox(height: 16),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.primary,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 20,
            right: 20,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white,
                border: Border.all(color: AppColors.primary),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  color: AppColors.primary,
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
