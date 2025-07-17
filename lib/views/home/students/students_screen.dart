import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/students/add_filtter_screens/add_students.dart';
import 'package:maths_house/views/home/students/add_filtter_screens/filter_students.dart';
import 'package:maths_house/cubit/student/student_cubit.dart';
import 'package:maths_house/cubit/student/student_state.dart';
import 'package:maths_house/model/student_Model.dart';
import 'package:maths_house/views/home/students/widgets/academic_screen.dart';
import 'package:maths_house/views/home/students/widgets/edit_Student_Screen.dart';
import 'package:maths_house/views/home/students/widgets/view_payment_hisory.dart';
import 'package:maths_house/views/home/students/widgets/wallet_balance.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  late StudentCubit studentCubit;
  String searchQuery = '';

  @override
  void initState() {
    super.initState();
    studentCubit = context.read<StudentCubit>();
    studentCubit.getStudent();
  }

  void _showAddDialog() {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.all(16),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
            maxWidth: 800,
            maxHeight: 800,
          ),
          child: AddStudentScreen(
            onStudentAdded: () {
              Navigator.of(context).pop();
              studentCubit.getStudent();
            },
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Students',
        showAddIcon: true,
        onAddPressed: _showAddDialog,
      ),
      body: BlocListener<StudentCubit, StudentStates>(
        listener: (context, state) {
          if (state is StudentDeleteSuccessState ||
              state is StudentAddSuccessState ||
              state is StudentUpdateSuccessState) {
            final message = (state as dynamic).message;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: Colors.green,
                duration: const Duration(seconds: 2),
              ),
            );
          } else if (state is StudentErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        child: RefreshIndicator(
          onRefresh: () async {
            await studentCubit.getStudent(forceRefresh: true);
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                CustomSearchFilterBar(
                  onSearchChanged: (query) {
                    setState(() {
                      searchQuery = query;
                    });
                    studentCubit.searchStudents(query);
                  },
                  onFilterTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const FilterStudentScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: BlocBuilder<StudentCubit, StudentStates>(
                    builder: (context, state) {
                      if (state is StudentLoadingState) {
                        return const Center(
                          child: CircularProgressIndicator(
                            color: AppColors.primary,
                          ),
                        );
                      } else if (state is StudentErrorState) {
                        return Center(
                          child: Text(
                            'Error: ${state.error}',
                            style: const TextStyle(color: Colors.red),
                          ),
                        );
                      }

                      List<Students> filteredStudents = studentCubit.filteredStudents;

                      if (filteredStudents.isEmpty) {
                        return const Center(child: Text('No students found.'));
                      }

                      return ListView.builder(
                        itemCount: filteredStudents.length,
                        itemBuilder: (context, index) {
                          final student = filteredStudents[index];
                          return CustomStudentCard(
                            student: student,
                            name: '${student.fName ?? ''} ${student.lName ?? ''}',
                            phone: student.phone ?? '',
                            email: student.email ?? '',
                            parentPhone: student.parentPhone?.toString() ?? '',
                            payment: student.payment ?? '',
                            imageUrl: student.image ?? '',
                            onEdit: () {
                              _showEditDialog(student);
                            },
                            onDelete: () {
                              _showDeleteDialog(student);
                            },
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showEditDialog(Students student) {
    showDialog(
      context: context,
      builder: (context) => EditStudentScreen(
        student: student,
        onStudentUpdated: () {
          studentCubit.getStudent(forceRefresh: true);
        },
      ),
    );
  }

  void _showDeleteDialog(Students student) {
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
              const Text('Delete Student'),
            ],
          ),
          content: Text(
            'Are you sure you want to delete ${student.fName ?? ''} ${student.lName ?? ''}?\n\nThis action cannot be undone.',
            style: const TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.of(context).pop();
                await studentCubit.deleteStudent(student.id!.toInt());
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


class CustomStudentCard extends StatelessWidget {
  final Students student;
  final String name;
  final String phone;
  final String email;
  final String parentPhone;
  final String payment;
  final String imageUrl;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const CustomStudentCard({
    super.key,
    required this.student,
    required this.name,
    required this.phone,
    required this.email,
    required this.parentPhone,
    required this.payment,
    required this.imageUrl,
    required this.onEdit,
    required this.onDelete,
  });

  ImageProvider? _getImageProvider(String imageUrl) {
    if (imageUrl.isEmpty) return null;
    if (imageUrl.startsWith('assets')) return AssetImage(imageUrl);
    if (imageUrl.startsWith('http')) return NetworkImage(imageUrl);
    return null;
  }

  @override
  Widget build(BuildContext context) {

    Widget buildRow(String label, String value) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '$label: ',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color:  Colors.black87,
                fontSize: 14,
              ),
            ),
            Expanded(
              child: Text(
                value.isEmpty ? 'N/A' : value,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14.5,
                  height: 1.4,
                ),
              ),
            ),
          ],
        ),
      );
    }


    Widget buildLink(String label, String text, {VoidCallback? onTap}) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if (label.isNotEmpty)
              Text(
                label,
                style: const TextStyle(
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                  fontSize: 15,
                ),
              ),
            const SizedBox(width: 8),
            Row(
              children: [
                const Icon(Icons.link, size: 18, color: AppColors.primary),
                const SizedBox(width: 4),
                Text(
                  text,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryLight,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Avatar + Name
          Row(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundImage: _getImageProvider(imageUrl),
                child: imageUrl.isEmpty ? const Icon(Icons.person, size: 28) : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name.trim().isEmpty ? 'Undefined Name' : name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Details
          buildRow('Phone:', phone),
          buildRow('Email:', email),
          buildRow('Parent Phone:', parentPhone),
          buildRow('Payment:', payment),

          buildLink('History:', 'View', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ViewPaymentHistory(userId: student.id!.toInt()),
              ),
            );
          }),

          buildLink('Academic:', 'View', onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => AcademicScreen(userId: student.id!.toInt(),),
              ),
            );
          }),

          Row(
            children: [
              buildLink('Wallet:', 'View', onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => WalletBalance(userId: student.id!.toInt()),
                  ),
                );
              }),

            ],
          ),

          const SizedBox(height: 16),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: CustomFilledButton(
                  text: 'Edit',
                  onPressed: onEdit,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: CustomOutlinedButton(
                  text: 'Delete',
                  onPressed: onDelete,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CustomFilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomFilledButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.primary,
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text, style: const TextStyle(color: Colors.white)),
    );
  }
}

class CustomOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.primary,
        side: const BorderSide(color: AppColors.primary),
        padding: const EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      child: Text(text),
    );
  }
}
