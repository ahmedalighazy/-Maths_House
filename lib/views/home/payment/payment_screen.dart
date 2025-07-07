import 'package:flutter/material.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/views/home/payment/wallet_payment_screens/payment_history.dart';
import 'package:maths_house/views/home/payment/wallet_payment_screens/payment_method.dart';
import 'package:maths_house/views/home/payment/wallet_payment_screens/wallet_pending.dart';
import 'wallet_payment_screens/wallet_history.dart';
import 'widgets/buildPaymentOption.dart';

class PaymentScreen extends StatelessWidget {
  const PaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Payment'),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Column(
          children: [
            buildPaymentOption(
              icon: Icons.account_balance_wallet,
              label: 'Wallet History',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletHistory()));
              },
            ),
            const SizedBox(height: 12),
            buildPaymentOption(
              icon: Icons.access_time,
              label: 'Wallet Pending',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const WalletPending()));
              },
            ),
            const SizedBox(height: 12),
            buildPaymentOption(
              icon: Icons.history,
              label: 'Payment History',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentHistory()));
              },
            ),
            const SizedBox(height: 12),
            buildPaymentOption(
              icon: Icons.credit_card,
              label: 'Payment Method',
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const PaymentMethod()));
              },
            ),
          ],
        ),
      ),
    );
  }
}
