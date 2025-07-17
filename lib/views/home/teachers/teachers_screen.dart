import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/views/home/teachers/widgets/add_Teacher_Dialog.dart';
import 'package:maths_house/views/home/teachers/widgets/filter_teacher.dart';
import 'package:maths_house/cubit/teacher/teacher_cubit.dart';
import 'package:maths_house/cubit/teacher/teacher_state.dart';
import 'package:maths_house/model/teacher_model.dart';
import 'package:maths_house/views/home/teachers/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/teachers/widgets/edit_teacher_dialog.dart';
import 'package:maths_house/views/home/teachers/widgets/teacher_card.dart';


class TeachersScreen extends StatefulWidget {
  const TeachersScreen({super.key});

  @override
  State<TeachersScreen> createState() => _TeachersScreenState();
}

class _TeachersScreenState extends State<TeachersScreen> {
  late TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    context.read<TeacherCubit>().getTeachers();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showSnackBar(String message, {Color? backgroundColor}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: backgroundColor ?? AppColors.primary,
        behavior: SnackBarBehavior.fixed,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  void _onSearchChanged(String query) {
    context.read<TeacherCubit>().searchTeachers(query);
  }

  void _onClearSearch() {
    context.read<TeacherCubit>().searchTeachers('');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Teachers',
        showAddIcon: true,
        onAddPressed: () {
          showAddTeacherDialog(context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomSearchFilterBar(
              controller: _searchController,
              onSearchChanged: _onSearchChanged,
              onFilterTap: _navigateToFilter,
            ),

            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Expanded(
              child: BlocConsumer<TeacherCubit, TeacherStates>(
                listener: (context, state) {
                  if (state is TeacherErrorState) {
                    _showSnackBar(state.error, backgroundColor: Colors.red);
                  }
                  if (state is TeacherUpdateSuccessState) {
                    _showSnackBar(
                      'Teacher updated successfully',
                      backgroundColor: Colors.green,
                    );
                  }
                  if (state is TeacherDeleteSuccessState) {
                    _showSnackBar(
                      'Teacher deleted successfully',
                      backgroundColor: Colors.green,
                    );
                  }
                },
                builder: (context, state) {
                  if (state is TeacherLoadingState) {
                    return const Center(
                      child: CircularProgressIndicator(color: AppColors.primary),
                    );
                  }

                  final teachers = context.watch<TeacherCubit>().filteredTeachers;

                  if (teachers.isEmpty) {
                    return _buildEmptyState();
                  }

                  return _buildTeachersList(teachers);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.person_off_outlined,
            size: 80,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No teachers found',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filter criteria',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () {
              _searchController.clear();
              context.read<TeacherCubit>().searchTeachers('');
            },
            icon: const Icon(Icons.refresh),
            label: const Text('Reset'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeachersList(List<Teachers> teachers) {
    return RefreshIndicator(
      onRefresh: () async {
        context.read<TeacherCubit>().getTeachers();
      },
      child: ListView.builder(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: teachers.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeInOut,
            child: TeacherCard(
              teacher: teachers[index],
              onEdit: () => _showEditDialog(teachers[index]),
              onDelete: () => _showDeleteConfirmation(teachers[index]),
            ),
          );
        },
      ),
    );
  }

  void _navigateToFilter() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const FilterTeacher()),
    );
  }

  void _showEditDialog(Teachers teacher) {
    showDialog(
      context: context,
      builder: (context) => EditTeacherDialog(teacher: teacher),
    );
  }

  void _showDeleteConfirmation(Teachers teacher) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: Row(
            children: [
              Icon(Icons.warning, color: Colors.orange[600]),
              const SizedBox(width: 10),
              const Text('Delete Teacher'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete ${teacher.name}?\n\nThis action cannot be undone.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                context.read<TeacherCubit>().deleteTeacher(teacher.id!.toInt());
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

void showAddTeacherDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => const AddTeacherDialog(),
  );
}