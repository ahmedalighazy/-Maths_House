import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/controller/dio/dio_helper.dart';
import 'package:maths_house/controller/dio/end_points.dart';
import 'package:maths_house/cubit/academic/academic_state.dart';
import 'package:maths_house/controller/cache/cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:maths_house/model/academic_model.dart';

class AcademicCubit extends Cubit<AcademicState> {
  AcademicCubit() : super(AcademicInitial());

  static AcademicCubit get(context) => BlocProvider.of(context);

  AcademicModel? academicModel;
  List<CoursesList>? availableCourses;
  List<MyCourses>? myCourses;
  bool isLoading = false;
  String? lastError;
  DateTime? lastUpdated;
  int? currentUserId;

  // Helper method to get user-friendly error messages
  String _getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Request timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Server response timeout. Please try again.';
        case DioExceptionType.connectionError:
          return 'Connection error. Please check your internet connection.';
        case DioExceptionType.badResponse:
          return _handleBadResponse(error.response?.statusCode);
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        case DioExceptionType.unknown:
          return 'Network error. Please check your connection.';
        default:
          return 'An unexpected error occurred.';
      }
    } else if (error is SocketException) {
      return 'No internet connection. Please check your network.';
    } else if (error is FormatException) {
      return 'Invalid data format received from server.';
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }

  String _handleBadResponse(int? statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your data.';
      case 401:
        return 'Unauthorized. Please login again.';
      case 403:
        return 'Access denied. You don\'t have permission.';
      case 404:
        return 'Academic data not found.';
      case 422:
        return 'Validation error. Please check your input.';
      case 500:
        return 'Server error. Please try again later.';
      default:
        return 'Server error (${statusCode ?? 'Unknown'}). Please try again.';
    }
  }

  // Helper method to get authentication token
  Future<String?> _getAuthToken() async {
    try {
      final token = await CacheHelper.getData(key: 'token');
      return token?.toString();
    } catch (e) {
      log('Error getting token: $e');
      return null;
    }
  }

  /// Get academic data (courses list and my courses)
  Future<void> getAcademicData({required int userId}) async {
    if (isLoading) return;

    isLoading = true;
    currentUserId = userId;
    emit(AcademicLoadingState());

    try {
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        lastError = 'Authentication token not found. Please login again.';
        emit(AcademicErrorState(lastError!));
        return;
      }

      final String url = '${EndPoints.AcademicList}/$userId';

      log('🔍 Fetching academic data from: $url');

      final response = await DioHelper.getData(
        url: url,
        token: token,
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          lastError = 'No data received from server';
          emit(AcademicErrorState(lastError!));
          return;
        }

        log('✅ Academic data response received');
        log('📄 Response data: ${response.data}');

        academicModel = AcademicModel.fromJson(response.data);
        availableCourses = academicModel?.coursesList ?? [];
        myCourses = academicModel?.myCourses ?? [];
        lastUpdated = DateTime.now();
        lastError = null;

        log('📚 Available courses: ${availableCourses?.length ?? 0}');
        log('📖 My courses: ${myCourses?.length ?? 0}');
        emit(AcademicSuccessState(academicModel!));
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        lastError = errorMessage;
        log('❌ Failed to load academic data: ${response.statusMessage}');
        emit(AcademicErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      lastError = errorMessage;
      log('❌ Network error (getAcademicData): ${error.toString()}');
      emit(AcademicErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }


  /// Refresh academic data
  Future<void> refreshAcademicData() async {
    if (currentUserId != null) {
      await getAcademicData(userId: currentUserId!);
    }
  }

  /// Check if user is enrolled in a specific course
  bool isEnrolledInCourse(int courseId) {
    if (myCourses == null) return false;
    return myCourses!.any((course) => course.id == courseId);
  }

  /// Get enrolled courses count
  int getEnrolledCoursesCount() {
    return myCourses?.length ?? 0;
  }

  /// Get available courses count
  int getAvailableCoursesCount() {
    return availableCourses?.length ?? 0;
  }

  /// Get course by ID from available courses
  CoursesList? getCourseById(int courseId) {
    if (availableCourses == null) return null;
    try {
      return availableCourses!.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  /// Get my course by ID
  MyCourses? getMyCourseById(int courseId) {
    if (myCourses == null) return null;
    try {
      return myCourses!.firstWhere((course) => course.id == courseId);
    } catch (e) {
      return null;
    }
  }

  /// Get courses by category
  List<CoursesList> getCoursesByCategory(int categoryId) {
    if (availableCourses == null) return [];
    return availableCourses!.where((course) => course.categoryId == categoryId).toList();
  }

  /// Get my courses by category
  List<MyCourses> getMyCoursesByCategory(int categoryId) {
    if (myCourses == null) return [];
    return myCourses!.where((course) => course.categoryId == categoryId).toList();
  }

  /// Search courses by name
  List<CoursesList> searchCoursesByName(String searchTerm) {
    if (availableCourses == null || searchTerm.isEmpty) return [];
    return availableCourses!.where((course) =>
    course.courseName?.toLowerCase().contains(searchTerm.toLowerCase()) ?? false
    ).toList();
  }

  /// Check if data is fresh (less than 10 minutes old)
  bool isDataFresh() {
    if (lastUpdated == null) return false;
    return DateTime.now().difference(lastUpdated!).inMinutes < 10;
  }

  /// Get last update time formatted
  String getLastUpdateTime() {
    if (lastUpdated == null) return 'Never';

    final now = DateTime.now();
    final difference = now.difference(lastUpdated!);

    if (difference.inMinutes < 1) {
      return 'Just now';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minutes ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hours ago';
    } else {
      return '${difference.inDays} days ago';
    }
  }

  /// Simulate course enrollment (for UI purposes only)
  void simulateCourseEnrollment(CoursesList course) {
    if (availableCourses != null && myCourses != null) {
      // Convert CoursesList to MyCourses
      final myCourse = MyCourses(
        id: course.id,
        courseName: course.courseName,
        categoryId: course.categoryId,
        courseDes: course.courseDes,
        courseUrl: course.courseUrl,
        preRequisition: course.preRequisition,
        gain: course.gain,
        createdAt: course.createdAt,
        updatedAt: course.updatedAt,
        teacherId: course.teacherId,
        userId: course.userId,
        type: course.type,
        currancyId: course.currancyId,
        pivot: Pivot(userId: currentUserId, courseId: course.id),
      );

      myCourses!.add(myCourse);

      // Update the model
      if (academicModel != null) {
        academicModel!.myCourses = myCourses;
      }

      emit(AcademicSuccessState(academicModel!));

      // Refresh from server after a short delay
      Future.delayed(Duration(seconds: 1), () {
        refreshAcademicData();
      });
    }
  }

  /// Simulate course unenrollment (for UI purposes only)
  void simulateCourseUnenrollment(int courseId) {
    if (myCourses != null) {
      myCourses!.removeWhere((course) => course.id == courseId);

      // Update the model
      if (academicModel != null) {
        academicModel!.myCourses = myCourses;
      }

      emit(AcademicSuccessState(academicModel!));

      // Refresh from server after a short delay
      Future.delayed(Duration(seconds: 1), () {
        refreshAcademicData();
      });
    }
  }

  /// Clear error state
  void clearError() {
    lastError = null;
    if (academicModel != null) {
      emit(AcademicSuccessState(academicModel!));
    } else {
      emit(AcademicInitial());
    }
  }

  /// Reset state
  void resetState() {
    academicModel = null;
    availableCourses = null;
    myCourses = null;
    lastError = null;
    lastUpdated = null;
    isLoading = false;
    currentUserId = null;
    emit(AcademicInitial());
  }

  // Getters
  bool get hasAcademicData => academicModel != null;
  bool get hasError => lastError != null;
  bool get hasAvailableCourses => availableCourses != null && availableCourses!.isNotEmpty;
  bool get hasMyCourses => myCourses != null && myCourses!.isNotEmpty;
  String? get errorMessage => lastError;
  DateTime? get lastUpdateTime => lastUpdated;
  List<CoursesList> get coursesList => availableCourses ?? [];
  List<MyCourses> get myCourseslist => myCourses ?? [];
}