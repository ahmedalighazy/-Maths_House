import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';

class WalletHistory extends StatelessWidget {
  const WalletHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(title: 'Wallet History'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomSearchFilterBar(),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red.shade50,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text("Wallet", style: TextStyle(fontWeight: FontWeight.bold)),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.green.shade100,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.check_circle, color: AppColors.green, size: 16),
                            SizedBox(width: 4),
                            Text("Approve", style: TextStyle(color: AppColors.green)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text("Student: Samar Mahfouz"),
                  const Text("Service: Package"),
                  Row(
                    children: [
                      const Text("Material: "),
                      Text("View", style: TextStyle(color: AppColors.primary)),
                    ],
                  ),
                  Row(
                    children: const [
                      Text("Price: "),
                      Text("\$8", style: TextStyle(color: AppColors.primary)),
                    ],
                  ),
                  Row(
                    children: [
                      const Text("Receipt: "),
                      Text("View", style: TextStyle(color: AppColors.primary)),
                    ],
                  ),
                  const Text("Date: 2025-07-05"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
