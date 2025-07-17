import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/controller/dio/dio_helper.dart';
import 'package:maths_house/controller/dio/end_points.dart';
import 'package:maths_house/cubit/teacher/teacher_state.dart';
import 'package:maths_house/model/teacher_model.dart';
import 'package:maths_house/controller/cache/cache_helper.dart';
import 'package:dio/dio.dart';

class TeacherCubit extends Cubit<TeacherStates> {
  TeacherCubit() : super(TeacherInitialState());

  static TeacherCubit get(context) => BlocProvider.of(context);

  List<Teachers> teachers = [];
  List<Teachers> filteredTeachers = [];
  String currentSearchQuery = '';
  bool isLoading = false;

  // Available options from server
  List<Courses> availableCourses = [];
  List<Categories> availableCategories = [];

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
        return 'Server error occurred. Please contact support or try again later.';
      case 502:
        return 'Bad gateway. Server is temporarily unavailable.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Server error (${statusCode ?? 'Unknown'}). Please try again.';
    }
  }

  // Helper method to validate required fields
  Map<String, String?> _validateTeacherData({
    required String nickName,
    required String email,
    required String phone,
    required String password,
    required List<String> courseNames,
    required List<String> categoryNames,
  }) {
    Map<String, String?> errors = {};

    // Validate required fields
    if (nickName.trim().isEmpty) {
      errors['nickName'] = 'Nickname is required';
    } else if (nickName.trim().length < 2) {
      errors['nickName'] = 'Nickname must be at least 2 characters';
    }

    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email)) {
      errors['email'] = 'Please enter a valid email address';
    }

    if (phone.trim().isEmpty) {
      errors['phone'] = 'Phone is required';
    } else if (!RegExp(r'^[0-9+\-\s()]{10,}$').hasMatch(phone)) {
      errors['phone'] = 'Please enter a valid phone number';
    }

    if (password.trim().isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.length < 6) {
      errors['password'] = 'Password must be at least 6 characters';
    }

    if (courseNames.isEmpty) {
      errors['courseNames'] = 'At least one course must be selected';
    }

    if (categoryNames.isEmpty) {
      errors['categoryNames'] = 'At least one category must be selected';
    }

    return errors;
  }

  // Helper method to convert course names to IDs
  List<int> _getCourseIdsByNames(List<String> courseNames) {
    List<int> courseIds = [];
    for (String courseName in courseNames) {
      final course = availableCourses.firstWhere(
            (course) => course.courseName == courseName,
        orElse: () => Courses(),
      );
      if (course.id != null) {
        courseIds.add(course.id!.toInt());
      }
    }
    return courseIds;
  }

  // Helper method to convert category names to IDs
  List<int> _getCategoryIdsByNames(List<String> categoryNames) {
    List<int> categoryIds = [];
    for (String categoryName in categoryNames) {
      final category = availableCategories.firstWhere(
            (category) => category.cateName == categoryName,
        orElse: () => Categories(),
      );
      if (category.id != null) {
        categoryIds.add(category.id!.toInt());
      }
    }
    return categoryIds;
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

  // Enhanced image preparation with validation
  String _prepareImageData(String imageBase64) {
    if (imageBase64.isEmpty) return '';

    try {
      String cleanedImage = imageBase64;

      // Remove data:image prefix if present
      if (imageBase64.startsWith('data:image/')) {
        final parts = imageBase64.split(',');
        if (parts.length > 1) {
          cleanedImage = parts[1];
        }
      }

      // Validate base64 format
      final imageBytes = base64.decode(cleanedImage);

      // Check image size (max 5MB)
      if (imageBytes.length > 5 * 1024 * 1024) {
        throw Exception('Image size too large. Maximum 5MB allowed.');
      }

      log('✅ Image prepared successfully. Size: ${imageBytes.length} bytes');
      return cleanedImage;
    } catch (e) {
      log('❌ Error preparing image: $e');
      throw Exception('Invalid image format or size too large');
    }
  }

  // Get all teachers and load available options
  Future<void> getTeachers() async {
    if (isLoading) return;

    isLoading = true;
    emit(TeacherLoadingState());

    try {
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        emit(TeacherErrorState('Authentication token not found. Please login again.'));
        return;
      }

      final response = await DioHelper.getData(
        url: EndPoints.Teachers,
        token: token,
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          emit(TeacherErrorState('No data received from server'));
          return;
        }

        final teacherModel = TeacherModel.fromJson(response.data);
        teachers = teacherModel.teachers ?? [];

        // Load available options
        availableCourses = teacherModel.courses ?? [];
        availableCategories = teacherModel.categories ?? [];

        _applyCurrentFilter();
        emit(TeacherSuccessState());
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        log('Failed to load teachers: ${response.statusMessage}');
        emit(TeacherErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      log('Network error (getTeachers): ${error.toString()}');
      emit(TeacherErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  // Apply current search filter
  void _applyCurrentFilter() {
    if (currentSearchQuery.isEmpty) {
      filteredTeachers = List.from(teachers);
    } else {
      filteredTeachers = teachers.where((teacher) {
        final name = teacher.name?.toLowerCase() ?? '';
        final email = teacher.email?.toLowerCase() ?? '';
        final phone = teacher.phone?.toLowerCase() ?? '';
        final query = currentSearchQuery.toLowerCase();

        return name.contains(query) ||
            email.contains(query) ||
            phone.contains(query);
      }).toList();
    }
  }

  /// Search teachers
  void searchTeachers(String query) {
    try {
      currentSearchQuery = query.trim();
      _applyCurrentFilter();
      emit(TeacherSuccessState());
    } catch (error) {
      log('Error in searchTeachers: ${error.toString()}');
      emit(TeacherErrorState('Error occurred while searching teachers'));
    }
  }

  /// Clear search
  void clearSearch() {
    currentSearchQuery = '';
    filteredTeachers = List.from(teachers);
    emit(TeacherSuccessState());
  }

  /// Add teacher - Enhanced with names support
  Future<void> addTeacher({
    required String nickName,
    required String email,
    required String phone,
    required String password,
    required List<String> courseNames,
    required List<String> categoryNames,
    required String imageBase64,
  }) async {
    if (isLoading) return;

    isLoading = true;
    emit(TeacherLoadingState());

    try {
      // Validate input data
      final validationErrors = _validateTeacherData(
        nickName: nickName,
        email: email,
        phone: phone,
        password: password,
        courseNames: courseNames,
        categoryNames: categoryNames,
      );

      if (validationErrors.isNotEmpty) {
        final firstError = validationErrors.values.first;
        emit(TeacherErrorState(firstError!));
        return;
      }

      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        emit(TeacherErrorState('Authentication token not found. Please login again.'));
        return;
      }

      // Convert names to IDs
      final courseIds = _getCourseIdsByNames(courseNames);
      final categoryIds = _getCategoryIdsByNames(categoryNames);

      if (courseIds.isEmpty) {
        emit(TeacherErrorState('Selected courses are not valid'));
        return;
      }

      if (categoryIds.isEmpty) {
        emit(TeacherErrorState('Selected categories are not valid'));
        return;
      }

      // Create proper data structure
      final Map<String, dynamic> data = {
        'nick_name': nickName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password.trim(),
        'course_ids': courseIds,
        'category_ids': categoryIds,
      };

      // Handle image with enhanced validation
      if (imageBase64.isNotEmpty) {
        try {
          data['image'] = _prepareImageData(imageBase64);
        } catch (e) {
          emit(TeacherErrorState(e.toString()));
          return;
        }
      }

      // Enhanced debugging
      log('🔍 Adding teacher with data:');
      log('📝 Nick name: ${data['nick_name']}');
      log('📧 Email: ${data['email']}');
      log('📞 Phone: ${data['phone']}');
      log('🔐 Password: ${data['password']}');
      log('📚 Course Names: $courseNames');
      log('📚 Course IDs: ${data['course_ids']}');
      log('📂 Category Names: $categoryNames');
      log('📂 Category IDs: ${data['category_ids']}');
      log('🖼️ Has image: ${imageBase64.isNotEmpty}');

      final response = await DioHelper.postData(
        url: EndPoints.AddTeachers,
        data: data,
        token: token,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('✅ Teacher added successfully');
        await getTeachers();
        emit(TeacherAddSuccessState());
      } else {
        String errorMessage = 'Failed to add teacher';

        if (response.data != null) {
          log('❌ Server response: ${response.data}');

          if (response.data is Map) {
            final responseData = response.data as Map;

            if (responseData['message'] != null) {
              errorMessage = responseData['message'].toString();
            } else if (responseData['errors'] != null) {
              final errors = responseData['errors'];
              if (errors is Map) {
                final firstError = errors.values.first;
                if (firstError is List && firstError.isNotEmpty) {
                  errorMessage = firstError.first.toString();
                } else {
                  errorMessage = firstError.toString();
                }
              }
            }
          } else if (response.data is String) {
            errorMessage = response.data.toString();
          }
        }

        log('❌ Failed to add teacher: $errorMessage');
        emit(TeacherErrorState(errorMessage));
      }
    } catch (error) {
      String errorMessage = 'Failed to add teacher';

      if (error is DioException) {
        log('❌ Enhanced DioException Details:');
        log('Status Code: ${error.response?.statusCode}');
        log('Status Message: ${error.response?.statusMessage}');
        log('Response Headers: ${error.response?.headers}');
        log('Response Data: ${error.response?.data}');
        log('Request URL: ${error.requestOptions.uri}');
        log('Request Method: ${error.requestOptions.method}');
        log('Request Headers: ${error.requestOptions.headers}');

        if (error.response?.statusCode == 500) {
          errorMessage = 'Server error occurred. Please contact support or try again later.';
        } else if (error.response?.data != null) {
          final responseData = error.response?.data;
          if (responseData is Map) {
            if (responseData['message'] != null) {
              errorMessage = responseData['message'].toString();
            } else if (responseData['errors'] != null) {
              final errors = responseData['errors'];
              if (errors is Map) {
                final firstError = errors.values.first;
                if (firstError is List && firstError.isNotEmpty) {
                  errorMessage = firstError.first.toString();
                } else {
                  errorMessage = firstError.toString();
                }
              }
            }
          } else if (responseData is String) {
            errorMessage = responseData;
          }
        } else {
          errorMessage = _getErrorMessage(error);
        }
      } else if (error is Exception) {
        errorMessage = error.toString();
      }

      log('❌ Network error (addTeacher): ${error.toString()}');
      emit(TeacherErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  /// Update teacher - Enhanced with names support
  Future<void> updateTeacher({
    required int teacherId,
    required String nickName,
    required String email,
    required String phone,
    required String password,
    required List<String> courseNames,
    required List<String> categoryNames,
    required String imageBase64,
  }) async {
    if (isLoading) return;

    isLoading = true;
    emit(TeacherLoadingState());

    try {
      if (teacherId <= 0) {
        emit(TeacherErrorState('Invalid teacher ID'));
        return;
      }

      // Validate input data
      final validationErrors = _validateTeacherData(
        nickName: nickName,
        email: email,
        phone: phone,
        password: password,
        courseNames: courseNames,
        categoryNames: categoryNames,
      );

      if (validationErrors.isNotEmpty) {
        final firstError = validationErrors.values.first;
        emit(TeacherErrorState(firstError!));
        return;
      }

      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        emit(TeacherErrorState('Authentication token not found. Please login again.'));
        return;
      }

      // Convert names to IDs
      final courseIds = _getCourseIdsByNames(courseNames);
      final categoryIds = _getCategoryIdsByNames(categoryNames);

      if (courseIds.isEmpty) {
        emit(TeacherErrorState('Selected courses are not valid'));
        return;
      }

      if (categoryIds.isEmpty) {
        emit(TeacherErrorState('Selected categories are not valid'));
        return;
      }

      // Create data structure
      final Map<String, dynamic> data = {
        'nick_name': nickName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password.trim(),
        'course_ids': courseIds,
        'category_ids': categoryIds,
      };

      // Handle image with enhanced validation
      if (imageBase64.isNotEmpty) {
        try {
          data['image'] = _prepareImageData(imageBase64);
        } catch (e) {
          emit(TeacherErrorState(e.toString()));
          return;
        }
      }

      // Enhanced debugging
      log('🔍 Updating teacher ${teacherId} with data:');
      log('📝 Nick name: ${data['nick_name']}');
      log('📧 Email: ${data['email']}');
      log('📞 Phone: ${data['phone']}');
      log('🔐 Password: ${data['password']}');
      log('📚 Course Names: $courseNames');
      log('📚 Course IDs: ${data['course_ids']}');
      log('📂 Category Names: $categoryNames');
      log('📂 Category IDs: ${data['category_ids']}');
      log('🖼️ Has image: ${imageBase64.isNotEmpty}');

      final response = await DioHelper.postData(
        url: '${EndPoints.UpdateTeachers}/$teacherId',
        data: data,
        token: token,
      );

      if (response.statusCode == 200) {
        log('✅ Teacher updated successfully');
        await getTeachers();
        emit(TeacherUpdateSuccessState());
      } else {
        String errorMessage = 'Failed to update teacher';

        if (response.data != null) {
          log('❌ Server response: ${response.data}');

          if (response.data is Map) {
            final responseData = response.data as Map;

            if (responseData['message'] != null) {
              errorMessage = responseData['message'].toString();
            } else if (responseData['errors'] != null) {
              final errors = responseData['errors'];
              if (errors is Map) {
                final firstError = errors.values.first;
                if (firstError is List && firstError.isNotEmpty) {
                  errorMessage = firstError.first.toString();
                } else {
                  errorMessage = firstError.toString();
                }
              }
            }
          } else if (response.data is String) {
            errorMessage = response.data.toString();
          }
        }

        log('❌ Failed to update teacher: $errorMessage');
        emit(TeacherErrorState(errorMessage));
      }
    } catch (error) {
      String errorMessage = 'Failed to update teacher';

      if (error is DioException) {
        log('❌ Enhanced DioException Details:');
        log('Status Code: ${error.response?.statusCode}');
        log('Status Message: ${error.response?.statusMessage}');
        log('Response Headers: ${error.response?.headers}');
        log('Response Data: ${error.response?.data}');
        log('Request URL: ${error.requestOptions.uri}');
        log('Request Method: ${error.requestOptions.method}');
        log('Request Headers: ${error.requestOptions.headers}');

        if (error.response?.statusCode == 500) {
          errorMessage = 'Server error occurred. Please contact support or try again later.';
        } else if (error.response?.data != null) {
          final responseData = error.response?.data;
          if (responseData is Map) {
            if (responseData['message'] != null) {
              errorMessage = responseData['message'].toString();
            } else if (responseData['errors'] != null) {
              final errors = responseData['errors'];
              if (errors is Map) {
                final firstError = errors.values.first;
                if (firstError is List && firstError.isNotEmpty) {
                  errorMessage = firstError.first.toString();
                } else {
                  errorMessage = firstError.toString();
                }
              }
            }
          } else if (responseData is String) {
            errorMessage = responseData;
          }
        } else {
          errorMessage = _getErrorMessage(error);
        }
      } else if (error is Exception) {
        errorMessage = error.toString();
      }

      log('❌ Network error (updateTeacher): ${error.toString()}');
      emit(TeacherErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  /// Delete teacher
  Future<void> deleteTeacher(int teacherId) async {
    if (isLoading) return;

    isLoading = true;
    emit(TeacherLoadingState());

    try {
      if (teacherId <= 0) {
        emit(TeacherErrorState('Invalid teacher ID'));
        return;
      }

      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        emit(TeacherErrorState('Authentication token not found. Please login again.'));
        return;
      }

      final teacherExists = teachers.any((teacher) => teacher.id == teacherId);
      if (!teacherExists) {
        emit(TeacherErrorState('Teacher not found in the current list'));
        return;
      }

      final response = await DioHelper.deleteData(
        url: '${EndPoints.DeleteTeachers}/$teacherId',
        token: token,
      );

      if (response.statusCode == 200) {
        teachers.removeWhere((teacher) => teacher.id == teacherId);
        _applyCurrentFilter();
        emit(TeacherDeleteSuccessState());
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        log('Failed to delete teacher: ${response.statusMessage}');
        emit(TeacherErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      log('Network error (deleteTeacher): ${error.toString()}');
      emit(TeacherErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  /// Reset state
  void resetState() {
    teachers.clear();
    filteredTeachers.clear();
    currentSearchQuery = '';
    availableCourses.clear();
    availableCategories.clear();
    isLoading = false;
    emit(TeacherInitialState());
  }

  /// Get teacher by ID
  Teachers? getTeacherById(int id) {
    try {
      return teachers.firstWhere((teacher) => teacher.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get available course names
  List<String> get availableCourseNames {
    return availableCourses
        .where((course) => course.courseName != null)
        .map((course) => course.courseName!)
        .toList();
  }

  /// Get available category names
  List<String> get availableCategoryNames {
    return availableCategories
        .where((category) => category.cateName != null)
        .map((category) => category.cateName!)
        .toList();
  }

  /// Get teachers count
  int get teachersCount => teachers.length;
  int get filteredTeachersCount => filteredTeachers.length;
  bool get hasTeachers => teachers.isNotEmpty;
  bool get hasFilteredTeachers => filteredTeachers.isNotEmpty;
}