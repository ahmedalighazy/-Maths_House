import 'package:flutter/material.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/students/add_filtter_screens/add_students.dart';
import 'package:maths_house/views/home/students/add_filtter_screens/filter_students.dart';
import 'package:maths_house/views/home/students/widgets/CustomStudentCard.dart';

class StudentsScreen extends StatelessWidget {
  const StudentsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Students',showAddIcon: true,onAddPressed: (){
        Navigator.push(context, MaterialPageRoute(builder: (context) => const AddStudentScreen()));
      },),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchFilterBar(onFilterTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FilterStudentScreen(),
                ),
              );
            }),
            const SizedBox(height: 20),
            Expanded(
              child: ListView.builder(
                itemCount: 2, // replace with actual data
                itemBuilder: (context, index) {
                  return CustomStudentCard(
                    name: 'Ahmed Abdelghany',
                    phone: '01000616771',
                    email: 'Asmaa123@Gmail.Com',
                    parentPhone: '01000616771',
                    payment: 'Free',
                    imageUrl: 'assets/images/man.png',
                    onEdit: () {},
                    onDelete: () {},
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
