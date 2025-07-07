import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';

class CustomSearchFilterBar extends StatelessWidget {
  final VoidCallback onFilterTap;

  const CustomSearchFilterBar({super.key, required this.onFilterTap});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.08,
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.primary),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          const SizedBox(width: 8),
          const Icon(Icons.calendar_today, color: AppColors.primary),
          const SizedBox(width: 8),
          const Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'From / To',
                border: InputBorder.none,
              ),
            ),
          ),
          Container(
            width: 50,
            height: double.infinity,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(7),
                bottomRight: Radius.circular(7),
              ),
            ),
            child: IconButton(
              icon: const Icon(Icons.filter_list, color: Colors.white),
              onPressed: onFilterTap,
            ),
          )
        ],
      ),
    );
  }
}
