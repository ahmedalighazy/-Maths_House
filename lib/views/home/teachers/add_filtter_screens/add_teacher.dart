import 'package:flutter/material.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/views/home/teachers/widgets/buildDropdown.dart';
import 'package:maths_house/views/home/teachers/widgets/custom_text_field.dart';

class AddTeacher extends StatefulWidget {
  const AddTeacher({super.key});

  @override
  State<AddTeacher> createState() => _AddTeacherState();
}

class _AddTeacherState extends State<AddTeacher> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final imageController = TextEditingController();

  String? selectedCategory;
  String? selectedCourse;
  bool obscurePassword = true;

  final List<String> categories = ['American Diploma', 'IGCSE', 'National'];
  final List<String> courses = ['SAT', 'ACT', 'EST 1', 'EST 2'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Add'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(label: 'Name', controller: nameController),
            const SizedBox(height: 12),
            CustomTextField(label: 'E-Mail', controller: emailController),
            const SizedBox(height: 12),
            CustomTextField(label: 'Phone', controller: phoneController),
            const SizedBox(height: 12),
            buildDropdown('Category', selectedCategory, categories, (val) {
              setState(() => selectedCategory = val);
            }),
            const SizedBox(height: 12),
            buildDropdown('Course', selectedCourse, courses, (val) {
              setState(() => selectedCourse = val);
            }),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Image',
              controller: imageController,
              readOnly: true,
              suffixIcon: IconButton(
                icon: const Icon(Icons.upload, color: AppColors.primary),
                onPressed: () {
                  // Handle upload
                },
              ),
            ),
            const SizedBox(height: 12),
            CustomTextField(
              label: 'Password',
              controller: passwordController,
              isPassword: true,
              obscureText: obscurePassword,
              onToggleVisibility: () {
                setState(() => obscurePassword = !obscurePassword);
              },
            ),
             SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Submit action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 20,color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
