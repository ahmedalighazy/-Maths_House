import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/views/home/packages/widgets/custom_input_field.dart';

class AddPackages extends StatelessWidget {
  const AddPackages({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Add Packages'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            const CustomInputField(label: "Package Name"),
            const SizedBox(height: 10),
            const CustomDropdownField(label: "Module"),
            const SizedBox(height: 10),
            const CustomDropdownField(label: "Category"),
            const SizedBox(height: 10),
            const CustomDropdownField(label: "Course"),
            const SizedBox(height: 10),
            const CustomInputField(label: "Number"),
            const SizedBox(height: 10),
            const CustomInputField(label: "Price"),
            const SizedBox(height: 10),
            const CustomInputField(label: "Duration"),
            const SizedBox(height: 30),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text("Done", style: TextStyle(fontSize: 18,color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

