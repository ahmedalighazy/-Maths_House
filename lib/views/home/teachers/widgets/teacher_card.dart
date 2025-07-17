import 'package:flutter/material.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/model/teacher_model.dart';

import 'custom_filled_button.dart';
import 'custom_outlined_button.dart';

class TeacherCard extends StatelessWidget {
  final Teachers teacher;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const TeacherCard({
    super.key,
    required this.teacher,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          gradient: LinearGradient(
            colors: [
              AppColors.primaryLight,
              AppColors.primaryLight.withOpacity(0.7),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 16),
            _buildDetails(),
            const SizedBox(height: 16),
            _buildActions(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      children: [
        Hero(
          tag: 'teacher_avatar_${teacher.id}',
          child: CircleAvatar(
            radius: 28,
            backgroundColor: AppColors.primary.withOpacity(0.1),
            backgroundImage: teacher.image != null
                ? NetworkImage(teacher.image!)
                : null,
            child: teacher.image == null
                ? Icon(
              Icons.person,
              size: 28,
              color: AppColors.primary,
            )
                : null,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                teacher.name ?? 'Unknown Teacher',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  'Active',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.primary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildDetails() {
    return Column(
      children: [
        _buildDetailRow(Icons.phone, teacher.phone ?? 'N/A'),
        const SizedBox(height: 8),
        _buildDetailRow(Icons.email, teacher.email ?? 'N/A'),
        const SizedBox(height: 8),
        _buildDetailRow(Icons.category, _getCategoriesText(teacher.categories)),
        const SizedBox(height: 8),
        _buildDetailRow(Icons.book, _getCoursesText(teacher.courses)),
      ],
    );
  }

  Widget _buildDetailRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[700],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildActions() {
    return Row(
      children: [
        Expanded(
          child: CustomFilledButton(
            text: 'Edit',
            icon: Icons.edit,
            onPressed: onEdit,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: CustomOutlinedButton(
            text: 'Delete',
            icon: Icons.delete,
            onPressed: onDelete,
          ),
        ),
      ],
    );
  }

  String _getCategoriesText(List<Categories>? categories) {
    if (categories == null || categories.isEmpty) return 'No categories';
    return categories.map((cat) => cat.cateName ?? 'Unknown').join(', ');
  }

  String _getCoursesText(List<Courses>? courses) {
    if (courses == null || courses.isEmpty) return 'No courses';
    return courses.map((course) => course.courseName ?? 'Unknown').join(', ');
  }
}