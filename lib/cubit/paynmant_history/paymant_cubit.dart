import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/controller/dio/dio_helper.dart';
import 'package:maths_house/controller/dio/end_points.dart';
import 'package:maths_house/cubit/paynmant_history/paymant_stste.dart';
import 'package:maths_house/controller/cache/cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:maths_house/model/paymant_history_model.dart';

class PaymantCubit extends Cubit<PaymantHistoryState> {
  PaymantCubit() : super(PaymantHistoryInitial());

  static PaymantCubit get(context) => BlocProvider.of(context);

  List<Chapters> chapters = [];
  List<Chapters> filteredChapters = [];
  String currentSearchQuery = '';
  bool isLoading = false;
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
        return 'Resource not found.';
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

  // Apply current search filter
  void _applyCurrentFilter() {
    if (currentSearchQuery.isEmpty) {
      filteredChapters = List.from(chapters);
    } else {
      filteredChapters = chapters.where((chapter) {
        final chapterName = chapter.chapterName?.toLowerCase() ?? '';
        final chDes = chapter.chDes?.toLowerCase() ?? '';
        final gain = chapter.gain?.toLowerCase() ?? '';
        final courseName = chapter.course?.courseName?.toLowerCase() ?? '';
        final query = currentSearchQuery.toLowerCase();

        return chapterName.contains(query) ||
            chDes.contains(query) ||
            gain.contains(query) ||
            courseName.contains(query);
      }).toList();
    }
  }

  /// Get payment history for a specific user
  Future<void> getPaymentHistory({int? userId}) async {
    if (isLoading) return;

    isLoading = true;
    emit(PaymantHistoryLoading());

    try {
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        emit(PaymantHistoryError('Authentication token not found. Please login again.'));
        return;
      }

      // Set current user ID
      if (userId != null) {
        currentUserId = userId;
      }

      // Construct URL with user ID
      String url;
      if (currentUserId != null) {
        url = '${EndPoints.Paymant}/$currentUserId';
      } else {
        url = EndPoints.Paymant;
      }

      log('🔍 Fetching payment history from: $url');

      final response = await DioHelper.getData(
        url: url,
        token: token,
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          emit(PaymantHistoryError('No data received from server'));
          return;
        }

        log('✅ Payment history response received');
        log('📄 Response data: ${response.data}');

        final paymentModel = PaymantHistoryModel.fromJson(response.data);
        chapters = paymentModel.chapters ?? [];
        _applyCurrentFilter();

        log('📊 Loaded ${chapters.length} chapters');
        emit(PaymantHistorySuccess());
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        log('❌ Failed to load payment history: ${response.statusMessage}');
        emit(PaymantHistoryError(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      log('❌ Network error (getPaymentHistory): ${error.toString()}');
      emit(PaymantHistoryError(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  /// Search chapters in payment history
  void searchChapters(String query) {
    try {
      currentSearchQuery = query.trim();
      _applyCurrentFilter();
      emit(PaymantHistorySuccess());
    } catch (error) {
      log('Error in searchChapters: ${error.toString()}');
      emit(PaymantHistoryError('Error occurred while searching chapters'));
    }
  }

  /// Clear search
  void clearSearch() {
    currentSearchQuery = '';
    filteredChapters = List.from(chapters);
    emit(PaymantHistorySuccess());
  }

  /// Filter chapters by course name instead of ID
  void filterByCourseName(String courseName) {
    try {
      filteredChapters = chapters.where((chapter) =>
      chapter.course?.courseName?.toLowerCase().contains(courseName.toLowerCase()) ?? false
      ).toList();
      emit(PaymantHistorySuccess());
    } catch (error) {
      log('Error in filterByCourseName: ${error.toString()}');
      emit(PaymantHistoryError('Error occurred while filtering chapters'));
    }
  }

  /// Filter chapters by teacher name (if available in teacher field)
  void filterByTeacherName(String teacherName) {
    try {
      filteredChapters = chapters.where((chapter) {
        // If teacher is a string containing the name
        if (chapter.teacher is String) {
          return chapter.teacher.toString().toLowerCase().contains(teacherName.toLowerCase());
        }
        // If teacher is an object with name property
        else if (chapter.teacher is Map && chapter.teacher['name'] != null) {
          return chapter.teacher['name'].toString().toLowerCase().contains(teacherName.toLowerCase());
        }
        return false;
      }).toList();
      emit(PaymantHistorySuccess());
    } catch (error) {
      log('Error in filterByTeacherName: ${error.toString()}');
      emit(PaymantHistoryError('Error occurred while filtering chapters'));
    }
  }

  /// Filter chapters by type
  void filterByType(String type) {
    try {
      filteredChapters = chapters.where((chapter) => chapter.type == type).toList();
      emit(PaymantHistorySuccess());
    } catch (error) {
      log('Error in filterByType: ${error.toString()}');
      emit(PaymantHistoryError('Error occurred while filtering chapters'));
    }
  }

  /// Reset all filters
  void resetFilters() {
    currentSearchQuery = '';
    filteredChapters = List.from(chapters);
    emit(PaymantHistorySuccess());
  }

  /// Refresh payment history
  Future<void> refreshPaymentHistory() async {
    await getPaymentHistory(userId: currentUserId);
  }

  /// Get chapter by ID
  Chapters? getChapterById(int id) {
    try {
      return chapters.firstWhere((chapter) => chapter.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get chapters by course name
  List<Chapters> getChaptersByCourseName(String courseName) {
    return chapters.where((chapter) =>
    chapter.course?.courseName?.toLowerCase().contains(courseName.toLowerCase()) ?? false
    ).toList();
  }

  /// Get chapters by teacher name
  List<Chapters> getChaptersByTeacherName(String teacherName) {
    return chapters.where((chapter) {
      if (chapter.teacher is String) {
        return chapter.teacher.toString().toLowerCase().contains(teacherName.toLowerCase());
      } else if (chapter.teacher is Map && chapter.teacher['name'] != null) {
        return chapter.teacher['name'].toString().toLowerCase().contains(teacherName.toLowerCase());
      }
      return false;
    }).toList();
  }

  /// Get unique course names
  List<String> getUniqueCourseNames() {
    return chapters
        .map((chapter) => chapter.course?.courseName ?? '')
        .where((name) => name.isNotEmpty)
        .toSet()
        .toList();
  }

  /// Get unique teacher names
  List<String> getUniqueTeacherNames() {
    Set<String> teacherNames = {};

    for (var chapter in chapters) {
      if (chapter.teacher is String && chapter.teacher.toString().isNotEmpty) {
        teacherNames.add(chapter.teacher.toString());
      } else if (chapter.teacher is Map && chapter.teacher['name'] != null) {
        teacherNames.add(chapter.teacher['name'].toString());
      }
    }

    return teacherNames.toList();
  }

  /// Get unique chapter types
  List<String> getUniqueTypes() {
    return chapters
        .map((chapter) => chapter.type ?? '')
        .where((type) => type.isNotEmpty)
        .toSet()
        .toList();
  }

  /// Helper method to get course name by ID
  String getCourseNameById(int? courseId) {
    if (courseId == null) return 'Unknown Course';

    try {
      final chapter = chapters.firstWhere((ch) => ch.courseId == courseId);
      return chapter.course?.courseName ?? 'Course #$courseId';
    } catch (e) {
      return 'Course #$courseId';
    }
  }

  /// Helper method to get teacher name by ID
  String getTeacherNameById(int? teacherId) {
    if (teacherId == null) return 'Unknown Teacher';

    try {
      final chapter = chapters.firstWhere((ch) => ch.teacherId == teacherId);
      if (chapter.teacher is String) {
        return chapter.teacher.toString();
      } else if (chapter.teacher is Map && chapter.teacher['name'] != null) {
        return chapter.teacher['name'].toString();
      }
      return 'Teacher #$teacherId';
    } catch (e) {
      return 'Teacher #$teacherId';
    }
  }

  /// Reset state
  void resetState() {
    chapters.clear();
    filteredChapters.clear();
    currentSearchQuery = '';
    currentUserId = null;
    isLoading = false;
    emit(PaymantHistoryInitial());
  }

  // Getters
  int get chaptersCount => chapters.length;
  int get filteredChaptersCount => filteredChapters.length;
  bool get hasChapters => chapters.isNotEmpty;
  bool get hasFilteredChapters => filteredChapters.isNotEmpty;
  bool get isSearching => currentSearchQuery.isNotEmpty;
}