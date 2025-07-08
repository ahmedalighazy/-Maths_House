import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_buttons.dart';

class CustomStudentCard extends StatelessWidget {
  final String name;
  final String phone;
  final String email;
  final String parentPhone;
  final String payment;
  final String imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomStudentCard({
    super.key,
    required this.name,
    required this.phone,
    required this.email,
    required this.parentPhone,
    required this.payment,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    TextStyle labelStyle = const TextStyle(color: Colors.grey, fontWeight: FontWeight.w500);
    TextStyle linkStyle = const TextStyle(
      color: AppColors.primary,
      decoration: TextDecoration.underline,
      fontWeight: FontWeight.w500,
    );

    Widget buildRow(String label, String value) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: RichText(
        text: TextSpan(
          text: '$label ',
          style: labelStyle,
          children: [TextSpan(text: value, style: const TextStyle(color: Colors.grey))],
        ),
      ),
    );

    Widget buildLink(String label, String text) => Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          if (label.isNotEmpty) Text(label, style: labelStyle),
          GestureDetector(
            onTap: () {},
            child: Text(text, style: linkStyle),
          ),
        ],
      ),
    );

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Profile and name
          Row(
            children: [
              CircleAvatar(radius: 28, backgroundImage: NetworkImage(imageUrl)),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Info
          buildRow('Phone:', phone),
          buildRow('Email:', email),
          buildLink('Details:', 'View'),
          buildRow('Parent Phone:', parentPhone),
          buildRow('Payment:', payment),
          buildLink('History:', 'View'),
          Row(
            children: [
              buildLink('Wallet:', 'View'),
              const SizedBox(width: 12),
              buildLink('', 'Top Up'),
            ],
          ),

          const SizedBox(height: 16),

          // Buttons
          Row(
            children: [
              Expanded(
                child: CustomFilledButton(
                  text: 'Edit',
                  onPressed: (){},
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomOutlinedButton(
                  text: 'Delete',
                  onPressed: (){},
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
