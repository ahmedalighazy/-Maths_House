import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/views/home/students/widgets/custom_text_field.dart';

class AddStudentScreen extends StatefulWidget {
  const AddStudentScreen({super.key});

  @override
  State<AddStudentScreen> createState() => _AddStudentScreenState();
}

class _AddStudentScreenState extends State<AddStudentScreen> {
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final nickNameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final gradeController = TextEditingController();
  final parentEmailController = TextEditingController();
  final parentPhoneController = TextEditingController();
  final passwordController = TextEditingController();

  bool obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(title: 'Add Student'),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            CustomTextField(label: 'First Name', controller: firstNameController),
            CustomTextField(label: 'Last Name', controller: lastNameController),
            CustomTextField(label: 'Nick Name', controller: nickNameController),
            CustomTextField(label: 'E-Mail', controller: emailController),
            CustomTextField(label: 'Phone', controller: phoneController),
            CustomTextField(label: 'Grade', controller: gradeController),
            CustomTextField(label: 'Parent E-Mail', controller: parentEmailController),
            CustomTextField(label: 'Parent Phone', controller: parentPhoneController),
            CustomTextField(
              label: 'Password',
              controller: passwordController,
              obscureText: obscurePassword,
              suffixIcon: IconButton(
                icon: Icon(
                  obscurePassword ? Icons.visibility_off : Icons.visibility,
                  color: AppColors.primary,
                ),
                onPressed: () {
                  setState(() {
                    obscurePassword = !obscurePassword;
                  });
                },
              ),
            ),
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Save action
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text('Done', style: TextStyle(fontSize: 18, color: Colors.white)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
