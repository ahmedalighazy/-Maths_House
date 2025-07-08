import 'package:flutter/material.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/views/home/teachers/widgets/filter_card_widget.dart';

class FilterTeacher extends StatefulWidget {
  const FilterTeacher({super.key});

  @override
  State<FilterTeacher> createState() => _FilterTeacherState();
}

class _FilterTeacherState extends State<FilterTeacher> {

  final List<String> categories = [
    'American Diploma',
    'American Diploma',
    'American Diploma',
    'American Diploma',
  ];

  final List<String> courses = ['EST 1', 'EST 2', 'SAT', 'ACT'];
  List<bool> categoryChecked = [true, true, true, true];
  List<bool> courseChecked = [true, true, true, true];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(title: 'Filter Teacher'),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            FilterCardWidget(
              title: 'Filter By Category:',
              items: categories,
              checked: categoryChecked,
              onChanged: (index, value) {
                setState(() {
                  categoryChecked[index] = value!;
                });
              },
            ),
            const SizedBox(height: 16),
            FilterCardWidget(
              title: 'Filter By Course:',
              items: courses,
              checked: courseChecked,
              onChanged: (index, value) {
                setState(() {
                  courseChecked[index] = value!;
                });
              },
            ),
          ],
        ),
      ),
    );
  }
}
