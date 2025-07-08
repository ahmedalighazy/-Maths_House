import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/views/home/packages/exam_package.dart';
import 'package:maths_house/views/home/packages/widgets/custom_package_tile.dart';

class PackagesScreen extends StatelessWidget {
  const PackagesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Packages'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: MediaQuery.of(context).size.height * 0.1,
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Text(
                'Total: 15',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  CustomPackageTile(
                    icon: Icons.assignment,
                    title: 'Exam Package',
                    onTap: () {
                     Navigator.push(context, MaterialPageRoute(builder: (context) => const ExamPackage()));
                    },
                  ),
                  const SizedBox(height: 16),
                  CustomPackageTile(
                    icon: Icons.play_circle_fill,
                    title: 'Live Package',
                    onTap: () {

                    },
                  ),
                  const SizedBox(height: 16),
                  CustomPackageTile(
                    icon: Icons.help_outline,
                    title: 'Question Package',
                    onTap: () {

                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
