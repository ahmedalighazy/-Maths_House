import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/core/app_colors.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/core/widgets/custom_search_filter_bar.dart';
import 'package:maths_house/views/home/payment/widgets/custom_card.dart';
import 'package:maths_house/cubit/paynmant_history/paymant_cubit.dart';
import 'package:maths_house/cubit/paynmant_history/paymant_stste.dart';
import 'package:maths_house/model/paymant_history_model.dart';

class PaymentHistory extends StatefulWidget {
  final int? userId;

  const PaymentHistory({super.key, this.userId});

  @override
  State<PaymentHistory> createState() => _PaymentHistoryState();
}

class _PaymentHistoryState extends State<PaymentHistory> {
  late PaymantCubit paymentCubit;
  String selectedFilter = 'All';
  final List<String> filterOptions = ['All', 'Course', 'Teacher', 'Type'];

  @override
  void initState() {
    super.initState();
    paymentCubit = PaymantCubit();
    // Load payment history after cubit initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      paymentCubit.getPaymentHistory(userId: widget.userId);
    });
  }

  @override
  void dispose() {
    paymentCubit.close();
    super.dispose();
  }

  void _showFilterDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter Options'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...filterOptions.map((option) => RadioListTile<String>(
              title: Text(option),
              value: option,
              groupValue: selectedFilter,
              onChanged: (value) {
                setState(() {
                  selectedFilter = value!;
                });
                Navigator.pop(context);
                _applyFilter();
              },
            )),
          ],
        ),
      ),
    );
  }

  void _applyFilter() {
    switch (selectedFilter) {
      case 'All':
        paymentCubit.resetFilters();
        break;
      case 'Course':
        _showCourseFilterDialog();
        break;
      case 'Teacher':
        _showTeacherFilterDialog();
        break;
      case 'Type':
        _showTypeFilterDialog();
        break;
    }
  }

  void _showCourseFilterDialog() {
    final courseNames = paymentCubit.getUniqueCourseNames();

    if (courseNames.isEmpty) {
      _showNoDataDialog('No courses available');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Course'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: courseNames.length,
            itemBuilder: (context, index) {
              final courseName = courseNames[index];
              return ListTile(
                title: Text(courseName),
                onTap: () {
                  Navigator.pop(context);
                  paymentCubit.filterByCourseName(courseName);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showTeacherFilterDialog() {
    final teacherNames = paymentCubit.getUniqueTeacherNames();

    if (teacherNames.isEmpty) {
      _showNoDataDialog('No teachers available');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Teacher'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: teacherNames.length,
            itemBuilder: (context, index) {
              final teacherName = teacherNames[index];
              return ListTile(
                title: Text(teacherName),
                onTap: () {
                  Navigator.pop(context);
                  paymentCubit.filterByTeacherName(teacherName);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showTypeFilterDialog() {
    final types = paymentCubit.getUniqueTypes();

    if (types.isEmpty) {
      _showNoDataDialog('No types available');
      return;
    }

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Filter by Type'),
        content: SizedBox(
          width: double.maxFinite,
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: types.length,
            itemBuilder: (context, index) {
              final type = types[index];
              return ListTile(
                title: Text(type),
                onTap: () {
                  Navigator.pop(context);
                  paymentCubit.filterByType(type);
                },
              );
            },
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _showNoDataDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('No Data'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget _buildChapterCard(Chapters chapter) {
    return CustomCard(
      title: chapter.chapterName ?? 'Unknown Chapter',
      status: 'Paid',
      statusColor: AppColors.green,
      statusIcon: Icons.check_circle,
      details: [
        if (chapter.id != null)
          Text('Chapter ID: ${chapter.id}'),
        if (chapter.course?.courseName != null)
          Text('Course: ${chapter.course!.courseName}'),
        if (chapter.teacherId != null)
          Text('Teacher: ${paymentCubit.getTeacherNameById(chapter.teacherId!.toInt())}'),
        if (chapter.chDes != null && chapter.chDes!.isNotEmpty)
          Text('Description: ${chapter.chDes}'),
        Row(
          children: [
            const Text('Material: '),
            TextButton(
              onPressed: chapter.chUrl != null && chapter.chUrl!.isNotEmpty
                  ? () => _showChapterContent(chapter)
                  : null,
              child: Text(
                chapter.chUrl != null && chapter.chUrl!.isNotEmpty ? 'View' : 'N/A',
                style: TextStyle(
                  color: chapter.chUrl != null && chapter.chUrl!.isNotEmpty
                      ? AppColors.primary
                      : Colors.grey,
                ),
              ),
            ),
          ],
        ),
        if (chapter.gain != null && chapter.gain!.isNotEmpty)
          Text('Gain: ${chapter.gain}'),
        if (chapter.type != null && chapter.type!.isNotEmpty)
          Text('Type: ${chapter.type}'),
        if (chapter.currancyId != null)
          Text('Currency ID: ${chapter.currancyId}'),
        if (chapter.preRequisition != null && chapter.preRequisition!.isNotEmpty)
          Text('Prerequisites: ${chapter.preRequisition}'),
        if (chapter.createdAt != null)
          Text('Created: ${_formatDate(chapter.createdAt)}'),
        if (chapter.updatedAt != null)
          Text('Updated: ${_formatDate(chapter.updatedAt)}'),
      ],
    );
  }

  void _showChapterContent(Chapters chapter) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(chapter.chapterName ?? 'Chapter Details'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (chapter.chDes != null && chapter.chDes!.isNotEmpty) ...[
                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(chapter.chDes!),
                const SizedBox(height: 12),
              ],
              if (chapter.chUrl != null && chapter.chUrl!.isNotEmpty) ...[
                const Text('URL:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(chapter.chUrl!),
                const SizedBox(height: 12),
              ],
              if (chapter.gain != null && chapter.gain!.isNotEmpty) ...[
                const Text('Gain:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(chapter.gain!),
                const SizedBox(height: 12),
              ],
              if (chapter.preRequisition != null && chapter.preRequisition!.isNotEmpty) ...[
                const Text('Prerequisites:', style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(chapter.preRequisition!),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  String _formatDate(String? dateString) {
    if (dateString == null || dateString.isEmpty) return 'N/A';
    try {
      final date = DateTime.parse(dateString);
      return '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';
    } catch (e) {
      return dateString;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
      value: paymentCubit,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(title: 'Payment History'),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              CustomSearchFilterBar(
                onFilterTap: _showFilterDialog,
                onSearchChanged: (query) {
                  paymentCubit.searchChapters(query);
                },
              ),
              const SizedBox(height: 20),
              Expanded(
                child: BlocBuilder<PaymantCubit, PaymantHistoryState>(
                  builder: (context, state) {
                    if (state is PaymantHistoryLoading) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }

                    if (state is PaymantHistoryError) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: 64,
                              color: Colors.red[300],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'Error',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.red[700],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16),
                              child: Text(
                                state.message,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.red[600],
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            ElevatedButton(
                              onPressed: () {
                                paymentCubit.refreshPaymentHistory();
                              },
                              child: const Text('Retry'),
                            ),
                          ],
                        ),
                      );
                    }

                    if (state is PaymantHistorySuccess) {
                      final chapters = paymentCubit.filteredChapters;

                      if (chapters.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.receipt_long,
                                size: 64,
                                color: Colors.grey[400],
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'No Payment History',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.grey[600],
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                paymentCubit.isSearching || selectedFilter != 'All'
                                    ? 'No results found for your search/filter'
                                    : 'No payment history available',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Colors.grey[500],
                                ),
                              ),
                              if (paymentCubit.isSearching || selectedFilter != 'All') ...[
                                const SizedBox(height: 16),
                                ElevatedButton(
                                  onPressed: () {
                                    paymentCubit.resetFilters();
                                    setState(() {
                                      selectedFilter = 'All';
                                    });
                                  },
                                  child: const Text('Clear Filters'),
                                ),
                              ],
                            ],
                          ),
                        );
                      }

                      return RefreshIndicator(
                        onRefresh: () async {
                          await paymentCubit.refreshPaymentHistory();
                        },
                        child: ListView.builder(
                          itemCount: chapters.length,
                          itemBuilder: (context, index) {
                            final chapter = chapters[index];
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 16.0),
                              child: _buildChapterCard(chapter),
                            );
                          },
                        ),
                      );
                    }

                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}