import 'package:flutter/material.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/teachers/add_filtter_screens/add_teacher.dart';
import 'package:maths_house/views/home/teachers/add_filtter_screens/filter_teacher.dart';
import 'package:maths_house/views/home/teachers/widgets/teacher_card.dart';

class TeachersScreen extends StatelessWidget {
  const TeachersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Teachers',showAddIcon: true,onAddPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddTeacher()));
      },),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchFilterBar(
              onFilterTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => const FilterTeacher()));
              },
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) {
                  return const TeacherCard();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

