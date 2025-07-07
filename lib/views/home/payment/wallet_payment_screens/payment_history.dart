import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/payment/widgets/custom_card.dart';

class PaymentHistory extends StatelessWidget {
  const PaymentHistory({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Payment History'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchFilterBar(onFilterTap: (){},),
            const SizedBox(height: 20),
            CustomCard(
              title: 'Wallet',
              status: 'Approve',
              statusColor: AppColors.green,
              statusIcon: Icons.check_circle,
              details: [
                const Text('Student: Samar Mahfouz'),
                const Text('Service: Package'),
                Row(
                  children: [
                    const Text('Material: '),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
                const Text('Price: \$8'),
                Row(
                  children: [
                    const Text('Receipt: '),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
                const Text('Date: 2025-07-05'),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
