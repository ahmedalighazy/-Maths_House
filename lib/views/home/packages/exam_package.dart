import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_buttons.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/packages/add_filter_screens/add_packages.dart';
import 'package:maths_house/views/home/packages/add_filter_screens/filter_packages.dart';

class ExamPackage extends StatelessWidget {
  const ExamPackage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar:CustomAppBar(title: 'Exam Packages',showAddIcon: true,onAddPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddPackages()));
      },),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
              CustomSearchFilterBar(onFilterTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterPackages()));

              },),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 2,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Diamond Package ACT',
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        const Text('Module:        Question'),
                        const Text('Category:     American Diploma'),
                        const Text('Course:        ACT'),
                        const Text('Number:       100'),
                        const Text('Price:           20'),
                        const Text('Duration:     60'),
                        const SizedBox(height: 10),
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
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
