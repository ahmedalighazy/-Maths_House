import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/cubit/academic/academic_cubit.dart';
import 'package:maths_house/cubit/academic/academic_state.dart';
import 'package:maths_house/model/academic_model.dart';
import 'package:maths_house/core/widgets/custom_app_bar.dart';
import 'package:maths_house/controller/cache/cache_helper.dart';
import 'package:maths_house/views/home/teachers/widgets/custom_search_filter_bar.dart';

import '../../../../core/app_colors.dart';

class AcademicScreen extends StatefulWidget {
  final int? userId;

  const AcademicScreen({super.key, this.userId});

  @override
  State<AcademicScreen> createState() => _AcademicScreenState();
}

class _AcademicScreenState extends State<AcademicScreen> {
  late TextEditingController searchController;
  String searchQuery = '';
  bool showMyCoursesOnly = false;
  int? currentUserId;

  @override
  void initState() {
    super.initState();
    searchController = TextEditingController();

    // Load academic data when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeUserId();
    });
  }

  void _initializeUserId() async {
    if (widget.userId != null) {
      currentUserId = widget.userId;
    } else {
      currentUserId = await _getUserIdFromPrefs();

      if (currentUserId == null) {
        currentUserId = _getUserIdFromAuthCubit();
      }

      if (currentUserId == null) {
        await _promptUserForId();
      }
    }

    if (currentUserId != null) {
      _loadAcademicData();
    } else {
      _showErrorDialog('Unable to determine user ID');
    }
  }

  Future<int?> _getUserIdFromPrefs() async {
    try {
      final userId = CacheHelper.getData(key: 'user_id');
      return userId is int ? userId : (userId is String ? int.tryParse(userId) : null);
    } catch (e) {
      print('Error getting user ID from preferences: $e');
      return null;
    }
  }

  int? _getUserIdFromAuthCubit() {
    try {
      return null;
    } catch (e) {
      print('Error getting user ID from auth cubit: $e');
      return null;
    }
  }

  Future<void> _promptUserForId() async {
    final TextEditingController idController = TextEditingController();

    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Enter User ID'),
        content: TextField(
          controller: idController,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: 'User ID',
            hintText: 'Enter your user ID',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final id = int.tryParse(idController.text);
              if (id != null) {
                currentUserId = id;
                CacheHelper.saveData(key: 'user_id', value: id);
                Navigator.of(context).pop();
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Please enter a valid user ID')),
                );
              }
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  // Method to load academic data
  void _loadAcademicData() {
    if (currentUserId == null) {
      _showErrorDialog('User ID is not available');
      return;
    }

    final cubit = AcademicCubit.get(context);
    cubit.getAcademicData(userId: currentUserId!);
  }

  // Method to show error dialog
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void onSearchChanged(String query) {
    setState(() {
      searchQuery = query;
    });
  }

  void onFilterTap() {
    setState(() {
      showMyCoursesOnly = !showMyCoursesOnly;
    });
  }

  List<CoursesList> getFilteredCourses(List<CoursesList> courses) {
    if (searchQuery.isEmpty) return courses;

    return courses.where((course) {
      final name = course.courseName?.toLowerCase() ?? '';
      final description = course.courseDes?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();

      return name.contains(query) || description.contains(query);
    }).toList();
  }

  List<MyCourses> getFilteredMyCourses(List<MyCourses> courses) {
    if (searchQuery.isEmpty) return courses;

    return courses.where((course) {
      final name = course.courseName?.toLowerCase() ?? '';
      final description = course.courseDes?.toLowerCase() ?? '';
      final query = searchQuery.toLowerCase();

      return name.contains(query) || description.contains(query);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(
        title: 'Academic List',
        showAddIcon: true,
        onAddPressed: (){},

      ),
      body: BlocConsumer<AcademicCubit, AcademicState>(
        listener: (context, state) {
          if (state is AcademicErrorState) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.error),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 3),
              ),
            );
          }
        },
        builder: (context, state) {
          final cubit = AcademicCubit.get(context);

          return Column(
            children: [
              // if (currentUserId != null)
              //   Container(
              //     width: double.infinity,
              //     padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              //     color: AppColors.primary.withOpacity(0.1),
              //     child: Text(
              //       'User ID: $currentUserId',
              //       style: TextStyle(
              //         color:AppColors.primary,
              //         fontWeight: FontWeight.w500,
              //       ),
              //     ),
              //   ),

              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    CustomSearchFilterBar(controller:  searchController, onSearchChanged: onSearchChanged, onFilterTap: onFilterTap),


                    const SizedBox(height: 12),

                    // Filter Buttons
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                showMyCoursesOnly = false;
                              });
                            },
                            icon: const Icon(Icons.library_books),
                            label: const Text('All Courses'),
                            style: ElevatedButton.styleFrom(

                              backgroundColor: !showMyCoursesOnly
                                  ? AppColors.primary
                                  : Colors.grey[400],
                              foregroundColor: !showMyCoursesOnly
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {
                              setState(() {
                                showMyCoursesOnly = true;
                              });
                            },
                            icon: const Icon(Icons.bookmark),
                            label: const Text('My Courses'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: showMyCoursesOnly
                                  ? AppColors.primary
                                  : Colors.grey[300],
                              foregroundColor: showMyCoursesOnly
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Content Area
              Expanded(
                child: _buildContent(context, state, cubit),
              ),
            ],
          );
        },
      ),
    );
  }


  Widget _buildContent(BuildContext context, AcademicState state, AcademicCubit cubit) {
    if (state is AcademicLoadingState) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(color: AppColors.primary,),
            SizedBox(height: 16),
            Text(
              'Loading academic data...',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    if (state is AcademicErrorState) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            const SizedBox(height: 16),
            const Text(
              'Error loading data',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Text(
                state.error,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                cubit.refreshAcademicData();
              },
              icon: const Icon(Icons.refresh,color: AppColors.primary,),
              label: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state is AcademicSuccessState || cubit.hasAcademicData) {
      return RefreshIndicator(
        onRefresh: () async {
          await cubit.refreshAcademicData();
        },
        child: showMyCoursesOnly
            ? _buildMyCoursesView(cubit)
            : _buildAllCoursesView(cubit),
      );
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.school,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No academic data available',
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () {
              _loadAcademicData();
            },
            child: const Text('Load Data'),
          ),
        ],
      ),
    );
  }

  Widget _buildAllCoursesView(AcademicCubit cubit) {
    final filteredCourses = getFilteredCourses(cubit.coursesList);

    if (filteredCourses.isEmpty) {
      return _buildEmptyState('No courses found');
    }

    return Column(
      children: [
        // Stats Header
        // Container(
        //
        //   margin: const EdgeInsets.all(16),
        //   padding: const EdgeInsets.all(16),
        //   decoration: BoxDecoration(
        //     color: AppColors.primary.withOpacity(0.1),
        //     borderRadius: BorderRadius.circular(12),
        //   ),
        //   child: Row(
        //     mainAxisAlignment: MainAxisAlignment.spaceAround,
        //     children: [
        //       // _buildStatItem('Available', cubit.getAvailableCoursesCount()),
        //       // _buildStatItem('Enrolled', cubit.getEnrolledCoursesCount()),
        //       // _buildStatItem('Filtered', filteredCourses.length),
        //     ],
        //   ),
        // ),

        // Courses List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: filteredCourses.length,
            itemBuilder: (context, index) {
              final course = filteredCourses[index];
              final isEnrolled = cubit.isEnrolledInCourse(course.id!.toInt());

              return _buildCourseCard(course, isEnrolled, cubit);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildMyCoursesView(AcademicCubit cubit) {
    final filteredCourses = getFilteredMyCourses(cubit.myCourseslist);

    if (filteredCourses.isEmpty) {
      return _buildEmptyState('No enrolled courses found');
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: filteredCourses.length,
      itemBuilder: (context, index) {
        final course = filteredCourses[index];
        return _buildMyCoursesCard(course, cubit);
      },
    );
  }

  Widget _buildCourseCard(CoursesList course, bool isEnrolled, AcademicCubit cubit) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    course.courseName ?? 'Unnamed Course',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),

              ],
            ),

            if (course.courseDes != null && course.courseDes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                course.courseDes!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Teacher ID: ${course.teacherId ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                const Spacer(),

                // ElevatedButton(
                //   onPressed: () {
                //     if (isEnrolled) {
                //       cubit.simulateCourseUnenrollment(course.id!.toInt());
                //     } else {
                //       cubit.simulateCourseEnrollment(course);
                //     }
                //   },
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: isEnrolled ? AppColors.primary : AppColors.primary.withOpacity(0.5),
                //     foregroundColor: Colors.white,
                //   ),
                //   child: Text(isEnrolled ? 'Unenroll' : 'Enroll'),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMyCoursesCard(MyCourses course, AcademicCubit cubit) {
    return Card(
      color: Colors.white,
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    course.courseName ?? 'Unnamed Course',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                // Container(
                //   padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                //   decoration: BoxDecoration(
                //     color: Colors.green,
                //     borderRadius: BorderRadius.circular(8),
                //   ),
                //   child: const Text(
                //     'My Course',
                //     style: TextStyle(
                //       color: Colors.white,
                //       fontSize: 12,
                //     ),
                //   ),
                // ),
              ],
            ),

            if (course.courseDes != null && course.courseDes!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                course.courseDes!,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],

            const SizedBox(height: 12),

            Row(
              children: [
                Icon(Icons.person, size: 16, color: Colors.grey[600]),
                const SizedBox(width: 4),
                Text(
                  'Teacher ID: ${course.teacherId ?? 'N/A'}',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),

                const Spacer(),

                // ElevatedButton.icon(
                //   onPressed: () {
                //     // Navigate to course details or open course
                //   },
                //   icon: const Icon(Icons.play_arrow),
                //   label: const Text('Continue'),
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: AppColors.primary,
                //     foregroundColor: Colors.white,
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, int count) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey[60],
          ),
        ),
      ],
    );
  }

  Widget _buildEmptyState(String message) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            message,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[600],
            ),
          ),
        ],
      ),
    );
  }
}