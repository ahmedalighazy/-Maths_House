import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/payment/widgets/custom_card.dart';

class PaymentMethod extends StatelessWidget {
  const PaymentMethod({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Payment Method'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchFilterBar(onFilterTap: (){},),
            const SizedBox(height: 20),
            CustomCard(
              title: 'Instapay',
              status: 'On',
              statusColor: AppColors.green,
              statusIcon: Icons.check_circle,
              details: [
                const Text('Description: Now You Can Use Paymob With Your Payment Methods'),
                const SizedBox(height: 4),
                const Text('Currencies: EGP / USD'),
              ],
              showButtons: true,
              primaryButtonText: 'Edit',
              secondaryButtonText: 'Delete',
              onPrimaryPressed: () {},
              onSecondaryPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}
