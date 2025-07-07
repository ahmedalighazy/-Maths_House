import 'package:flutter/material.dart';

class CustomSearchFilterBar extends StatelessWidget {
  const CustomSearchFilterBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(10),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: const [
                Icon(Icons.calendar_today, color: Colors.red),
                SizedBox(width: 8),
                Text(
                  'From / To',
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          height: MediaQuery.of(context).size.height * 0.06,
          width: MediaQuery.of(context).size.height * 0.06,
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10),
          ),
          child: const Icon(Icons.filter_list, color: Colors.white),
        ),
      ],
    );
  }
}
