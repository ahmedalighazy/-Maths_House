import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';

class FilterCardWidget extends StatelessWidget {
  final String title;
  final List<String> items;
  final List<bool> checked;
  final Function(int, bool?) onChanged;

  const FilterCardWidget({
    super.key,
    required this.title,
    required this.items,
    required this.checked,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 8),
          ...List.generate(items.length, (index) {
            return Row(
              children: [
                Checkbox(
                  value: checked[index],
                  onChanged: (value) => onChanged(index, value),
                  activeColor: AppColors.primary,
                ),
                Text(items[index]),
              ],
            );
          }),
        ],
      ),
    );
  }
}
