import 'package:flutter/material.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/pending_payments/widgets/payment_card.dart';

class PendingScreen extends StatelessWidget {
  const PendingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Pending Payments'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Filter
            CustomSearchFilterBar(onFilterTap: (){},),
            const SizedBox(height: 16),
            // List of Pending Payments
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) {
                  return PaymentCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

