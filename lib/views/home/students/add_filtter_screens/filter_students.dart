import 'package:flutter/material.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/app_colors.dart';

class FilterStudentScreen extends StatefulWidget {
  const FilterStudentScreen({super.key});

  @override
  State<FilterStudentScreen> createState() => _FilterStudentScreenState();
}

class _FilterStudentScreenState extends State<FilterStudentScreen> {
  bool filterFree = true;
  bool filterPaid = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Filter'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          width: double.infinity,
          height: MediaQuery.of(context).size.height * 0.3,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.red.shade50,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Filter By Payment:',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              const SizedBox(height: 10),
              buildCheckbox('Free', filterFree, (val) {
                setState(() => filterFree = val!);
              }),
              buildCheckbox('Paid', filterPaid, (val) {
                setState(() => filterPaid = val!);
              }),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildCheckbox(String label, bool value, ValueChanged<bool?> onChanged) {
    return CheckboxListTile(
      value: value,
      onChanged: onChanged,
      title: Text(label),
      controlAffinity: ListTileControlAffinity.leading,
      activeColor: AppColors.primary,
      contentPadding: EdgeInsets.zero,
    );
  }
}
