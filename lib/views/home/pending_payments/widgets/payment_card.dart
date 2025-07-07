import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';

class PaymentCard extends StatelessWidget {
  const PaymentCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title and status
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Vodafone Cash',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.shade100,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children:  [
                    Icon(Icons.watch_later, size: 14, color: AppColors.yellow),
                    SizedBox(width: 4),
                    Text(
                      'Pending',
                      style: TextStyle(fontSize: 12, color: AppColors.yellow),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Info section
          const Text('Price: \$500'),
          const Text('Student:  Ahmed Ibrahim (Hamata)'),
          Row(
            children: const [
              Text('Material: '),
              Text('View', style: TextStyle(color: AppColors.primary)),
            ],
          ),
          const Text('Service: Chapters'),
          Row(
            children: const [
              Text('Receipt: '),
              Text('View', style: TextStyle(color: AppColors.primary)),
            ],
          ),
          const Text('Date:  2025-06-29'),
          const SizedBox(height: 12),
          // Buttons
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor:AppColors.primary,
                    padding:  EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Approv',style: TextStyle(fontSize: 13,color: Colors.white),),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color:AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Reject',
                    style: TextStyle(color: AppColors.primary,fontSize: 13),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
