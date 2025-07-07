import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/payment/widgets/custom_card.dart';

class WalletPending extends StatelessWidget {
  const WalletPending({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Wallet Pending'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchFilterBar(onFilterTap: (){},),
            const SizedBox(height: 20),
            CustomCard(
              title: 'Ahmed Gouda',
              status: 'Pending',
              statusColor: AppColors.yellow,
              statusIcon: Icons.timelapse,
              details: [
                const Text('Price: \$500'),
                const SizedBox(height: 4),
                const Text('Date: 18-09-2024'),
                Row(
                  children: [
                    const Text('Receipt: '),
                    TextButton(
                      onPressed: () {},
                      child: const Text('View', style: TextStyle(color: AppColors.primary)),
                    ),
                  ],
                ),
              ],
              showButtons: true,
              primaryButtonText: 'Approve',
              secondaryButtonText: 'Reject',
              onPrimaryPressed: () {},
              onSecondaryPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
