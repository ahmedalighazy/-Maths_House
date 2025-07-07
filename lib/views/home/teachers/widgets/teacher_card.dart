import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';

class TeacherCard extends StatelessWidget {
  const TeacherCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Teacher Info Row
          Row(
            children: [
              // Teacher Image
              const CircleAvatar(
                radius: 24,
                backgroundImage: AssetImage('assets/images/man.png'),
              ),
              const SizedBox(width: 12),
              // Teacher Name
              const Text(
                'Miss. Asmaa',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 12),

          const Text('Phone: 0123456789'),
          const SizedBox(height: 6),
          const Text('Email: Asmaa123@Gmail.Com'),
          const SizedBox(height: 6),
          const Text('Category: American Diploma'),
          const SizedBox(height: 6),
          const Text('Course: EST 1 / EST 2 / SAT / ACT'),
          const SizedBox(height: 12),

          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Edit', style: TextStyle(color: Colors.white)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: OutlinedButton(
                  onPressed: () {},
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: AppColors.primary),
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text('Delete', style: TextStyle(color:AppColors.primary)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
