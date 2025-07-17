import 'dart:developer';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/controller/cache/cache_helper.dart';
import 'package:maths_house/controller/dio/dio_helper.dart';
import 'package:maths_house/controller/dio/end_points.dart';
import 'package:maths_house/cubit/student/student_state.dart';
import 'package:maths_house/model/student_Model.dart';

class StudentCubit extends Cubit<StudentStates> {
  StudentCubit() : super(StudentInitialState());

  static StudentCubit get(context) => BlocProvider.of(context);

  List<Students> students = [];
  List<Students> filteredStudents = [];
  String currentSearchQuery = '';
  bool isLoading = false;

  // Cache management for performance
  DateTime? lastFetchTime;
  static const Duration cacheTimeout = Duration(minutes: 5);

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

  // Helper method to get category name by ID
  String? getCategoryNameById(num? categoryId) {
    if (categoryId == null) return null;

    final category = availableCategories.firstWhere(
          (category) => category.id == categoryId,
      orElse: () => Categories(),
    );
    return category.cateName;
  }

  // Helper method to get course name by ID
  String? getCourseNameById(num? courseId) {
    if (courseId == null) return null;

    final course = availableCourses.firstWhere(
          (course) => course.id == courseId,
      orElse: () => Courses(),
    );
    return course.courseName;
  }

  // Helper method to get category ID by name
  num? getCategoryIdByName(String? categoryName) {
    if (categoryName == null || categoryName.isEmpty) return null;

    final category = availableCategories.firstWhere(
          (category) => category.cateName?.toLowerCase() == categoryName.toLowerCase(),
      orElse: () => Categories(),
    );
    return category.id;
  }

  // Helper method to get course ID by name
  num? getCourseIdByName(String? courseName) {
    if (courseName == null || courseName.isEmpty) return null;

    final course = availableCourses.firstWhere(
          (course) => course.courseName?.toLowerCase() == courseName.toLowerCase(),
      orElse: () => Courses(),
    );
    return course.id;
  }

  // Helper method for optimized search
  bool _matchesSearchQuery(Students student, String query) {
    final searchFields = [
      student.fName?.toLowerCase() ?? '',
      student.lName?.toLowerCase() ?? '',
      student.nickName?.toLowerCase() ?? '',
      student.email?.toLowerCase() ?? '',
      student.phone?.toLowerCase() ?? '',
      student.parentEmail?.toLowerCase() ?? '',
      student.grade?.toLowerCase() ?? '',
      student.category?.toLowerCase() ?? '',
    ];

    return searchFields.any((field) => field.contains(query));
  }

  // Get all students with categories and courses - Enhanced with caching
  Future<void> getStudent({bool forceRefresh = false}) async {
    if (isLoading) return;

    // Check cache first
    if (!forceRefresh && lastFetchTime != null &&
        DateTime.now().difference(lastFetchTime!) < cacheTimeout &&
        students.isNotEmpty) {
      _applyCurrentFilter();
      emit(StudentSuccessState());
      return;
    }

    isLoading = true;
    emit(StudentLoadingState());

    try {
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        emit(StudentErrorState('Authentication token not found. Please login again.'));
        return;
      }

      final response = await DioHelper.getData(
        url: EndPoints.Student,
        token: token,
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          emit(StudentErrorState('No data received from server'));
          return;
        }

        final studentModel = StudentModel.fromJson(response.data);
        students = studentModel.students ?? [];

        // Load available options
        availableCourses = studentModel.courses ?? [];
        availableCategories = studentModel.categories ?? [];

        // Update cache timestamp
        lastFetchTime = DateTime.now();

        _applyCurrentFilter();
        emit(StudentSuccessState());
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        log('Failed to load students: ${response.statusMessage}');
        emit(StudentErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      log('Network error (getStudent): ${error.toString()}');
      emit(StudentErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  // Apply current search filter
  void _applyCurrentFilter() {
    if (currentSearchQuery.isEmpty) {
      filteredStudents = List.from(students);
    } else {
      final lowerQuery = currentSearchQuery.toLowerCase();
      filteredStudents = students.where((student) {
        return _matchesSearchQuery(student, lowerQuery);
      }).toList();
    }
  }

  /// Search students - Enhanced performance
  void searchStudents(String query) {
    try {
      currentSearchQuery = query.trim();

      if (currentSearchQuery.isEmpty) {
        filteredStudents = List.from(students);
      } else {
        final lowerQuery = currentSearchQuery.toLowerCase();

        filteredStudents = students.where((student) {
          return _matchesSearchQuery(student, lowerQuery);
        }).toList();
      }

      emit(StudentSuccessState());
    } catch (error) {
      log('Error in searchStudents: ${error.toString()}');
      emit(StudentErrorState('Error occurred while searching students'));
    }
  }

  /// Clear search
  void clearSearch() {
    currentSearchQuery = '';
    filteredStudents = List.from(students);
    emit(StudentSuccessState());
  }

  // Add Student - Fixed to send category_id instead of category_name
  Future<void> addStudent({
    required String fName,
    required String lName,
    required String nickName,
    required String email,
    required String phone,
    required String password,
    required String parentPhone,
    required String parentEmail,
    required String grade,
    String? categoryName, // Will be converted to category_id
    String? imageBase64,
  }) async {
    if (isLoading) {
      log('Process already running, skipping...');
      return;
    }

    final requestId = DateTime.now().millisecondsSinceEpoch.toString();
    log('[$requestId] Starting to add student...');

    isLoading = true;
    emit(StudentLoadingState());

    try {
      // Validate required fields
      final validationErrors = _validateStudentFields(
        fName: fName,
        lName: lName,
        nickName: nickName,
        email: email,
        phone: phone,
        password: password,
        parentPhone: parentPhone,
        parentEmail: parentEmail,
        grade: grade,
        categoryName: categoryName,
      );

      if (validationErrors.isNotEmpty) {
        final firstError = validationErrors.values.first;
        log('[$requestId] Validation failed: $firstError');
        emit(StudentErrorState(firstError!));
        return;
      }

      // Get authentication token
      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        log('[$requestId] Authentication failed - no token found');
        emit(StudentErrorState('Authentication token not found. Please login again.'));
        return;
      }

      // Prepare request data
      final Map<String, dynamic> data = {
        'f_name': fName.trim(),
        'l_name': lName.trim(),
        'nick_name': nickName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password.trim(),
        'parent_phone': parentPhone.trim(),
        'parent_email': parentEmail.trim(),
        'grade': grade.trim(),
      };

      // Convert category name to category_id if provided
      if (categoryName != null && categoryName.isNotEmpty) {
        final categoryId = getCategoryIdByName(categoryName);
        if (categoryId != null) {
          data['category_id'] = categoryId.toString();
        }
      }

      // Add image only if provided
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        data['image'] = imageBase64.startsWith('data:image/')
            ? imageBase64
            : 'data:image/png;base64,$imageBase64';
      }

      log('[$requestId] Sending data with ${data.length} fields: $data');

      // Make API request
      final response = await DioHelper.postData(
        url: EndPoints.AddStudent,
        data: data,
        token: token,
      );

      log('[$requestId] Response: ${response.statusCode}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        log('[$requestId] Student added successfully');
        await getStudent(forceRefresh: true); // Force refresh after adding
        emit(StudentAddSuccessState(message: 'Student added successfully'));
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        log('[$requestId] Failed to add student: $errorMessage');
        emit(StudentErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      log('[$requestId] Exception: $errorMessage');
      emit(StudentErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  // Update Student - Fixed to send category_id instead of category_name
  Future<void> updateStudent({
    required int studentId,
    required String fName,
    required String lName,
    required String nickName,
    required String email,
    required String phone,
    required String password,
    required String parentPhone,
    required String parentEmail,
    required String grade,
    String? categoryName, // Will be converted to category_id
    String? imageBase64,
  }) async {
    if (isLoading) return;

    isLoading = true;
    emit(StudentLoadingState());

    try {
      if (studentId <= 0) {
        emit(StudentErrorState('Invalid student ID'));
        return;
      }

      // Validate input data
      final validationErrors = _validateStudentFields(
        fName: fName,
        lName: lName,
        nickName: nickName,
        email: email,
        phone: phone,
        password: password,
        parentPhone: parentPhone,
        parentEmail: parentEmail,
        grade: grade,
        categoryName: categoryName,
      );

      if (validationErrors.isNotEmpty) {
        final firstError = validationErrors.values.first;
        emit(StudentErrorState(firstError!));
        return;
      }

      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        emit(StudentErrorState('Authentication token not found. Please login again.'));
        return;
      }

      // Prepare update data
      final Map<String, dynamic> data = {
        'f_name': fName.trim(),
        'l_name': lName.trim(),
        'nick_name': nickName.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'password': password.trim(),
        'parent_phone': parentPhone.trim(),
        'parent_email': parentEmail.trim(),
        'grade': grade.trim(),
      };

      // Convert category name to category_id if provided
      if (categoryName != null && categoryName.isNotEmpty) {
        final categoryId = getCategoryIdByName(categoryName);
        if (categoryId != null) {
          data['category_id'] = categoryId.toString();
        }
      }

      // Add image only if provided
      if (imageBase64 != null && imageBase64.isNotEmpty) {
        data['image'] = imageBase64.startsWith('data:image/')
            ? imageBase64
            : 'data:image/png;base64,$imageBase64';
      }

      log('Updating student $studentId with data: $data');

      final response = await DioHelper.postData(
        url: '${EndPoints.UpdateStudent}/$studentId',
        data: data,
        token: token,
      );

      if (response.statusCode == 200) {
        await getStudent(forceRefresh: true); // Force refresh after updating
        emit(StudentUpdateSuccessState(message: 'Student updated successfully'));
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        log('Failed to update student: ${response.statusMessage}');
        emit(StudentErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      log('Network error (updateStudent): ${error.toString()}');
      emit(StudentErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  // Validation method
  Map<String, String?> _validateStudentFields({
    required String fName,
    required String lName,
    required String nickName,
    required String email,
    required String phone,
    required String password,
    required String parentPhone,
    required String parentEmail,
    required String grade,
    String? categoryName,
  }) {
    Map<String, String?> errors = {};

    // First name validation
    if (fName.trim().isEmpty) {
      errors['f_name'] = 'First name is required';
    } else if (fName.trim().length < 2) {
      errors['f_name'] = 'First name must be at least 2 characters';
    }

    // Last name validation
    if (lName.trim().isEmpty) {
      errors['l_name'] = 'Last name is required';
    } else if (lName.trim().length < 2) {
      errors['l_name'] = 'Last name must be at least 2 characters';
    }

    // Nickname validation
    if (nickName.trim().isEmpty) {
      errors['nick_name'] = 'Nickname is required';
    } else if (nickName.trim().length < 2) {
      errors['nick_name'] = 'Nickname must be at least 2 characters';
    }

    // Email validation
    if (email.trim().isEmpty) {
      errors['email'] = 'Email is required';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email.trim())) {
      errors['email'] = 'Please enter a valid email address';
    }

    // Phone validation
    if (phone.trim().isEmpty) {
      errors['phone'] = 'Phone number is required';
    } else if (phone.trim().length < 8) {
      errors['phone'] = 'Phone number must be at least 8 digits';
    }

    // Password validation
    if (password.trim().isEmpty) {
      errors['password'] = 'Password is required';
    } else if (password.trim().length < 3) {
      errors['password'] = 'Password must be at least 3 characters';
    }

    // Parent phone validation
    if (parentPhone.trim().isEmpty) {
      errors['parent_phone'] = 'Parent phone number is required';
    } else if (parentPhone.trim().length < 8) {
      errors['parent_phone'] = 'Parent phone number must be at least 8 digits';
    }

    // Parent email validation
    if (parentEmail.trim().isEmpty) {
      errors['parent_email'] = 'Parent email is required';
    } else if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(parentEmail.trim())) {
      errors['parent_email'] = 'Please enter a valid parent email address';
    }

    // Grade validation
    if (grade.trim().isEmpty) {
      errors['grade'] = 'Grade is required';
    }

    // Category name validation (optional)
    if (categoryName != null && categoryName.trim().isNotEmpty && categoryName.trim().length < 2) {
      errors['category_name'] = 'Category name must be at least 2 characters';
    }

    return errors;
  }

  /// Delete student - ENABLED AND WORKING
  Future<void> deleteStudent(int studentId) async {
    if (isLoading) return;

    isLoading = true;
    emit(StudentLoadingState());

    try {
      if (studentId <= 0) {
        emit(StudentErrorState('Invalid student ID'));
        return;
      }

      final token = await _getAuthToken();
      if (token == null || token.isEmpty) {
        emit(StudentErrorState('Authentication token not found. Please login again.'));
        return;
      }

      final studentExists = students.any((student) => student.id == studentId);
      if (!studentExists) {
        emit(StudentErrorState('Student not found in the current list'));
        return;
      }

      final response = await DioHelper.deleteData(
        url: '${EndPoints.DeleteStudent}/$studentId',
        token: token,
      );

      if (response.statusCode == 200) {
        students.removeWhere((student) => student.id == studentId);
        _applyCurrentFilter();
        emit(StudentDeleteSuccessState(message: 'Student deleted successfully'));
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        log('Failed to delete student: ${response.statusMessage}');
        emit(StudentErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      log('Network error (deleteStudent): ${error.toString()}');
      emit(StudentErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  /// Reset state
  void resetState() {
    students.clear();
    filteredStudents.clear();
    currentSearchQuery = '';
    availableCourses.clear();
    availableCategories.clear();
    lastFetchTime = null;
    isLoading = false;
    emit(StudentInitialState());
  }

  /// Get student by ID
  Students? getStudentById(int id) {
    try {
      return students.firstWhere((student) => student.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get available course names
  List<String> get availableCourseNames {
    return availableCourses
        .where((course) => course.courseName != null && course.courseName!.isNotEmpty)
        .map((course) => course.courseName!)
        .toList();
  }

  /// Get available category names
  List<String> get availableCategoryNames {
    return availableCategories
        .where((category) => category.cateName != null && category.cateName!.isNotEmpty)
        .map((category) => category.cateName!)
        .toList();
  }

  /// Get course by ID
  Courses? getCourseById(num id) {
    try {
      return availableCourses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Get category by ID
  Categories? getCategoryById(num id) {
    try {
      return availableCategories.firstWhere((category) => category.id == id);
    } catch (e) {
      return null;
    }
  }

  /// Filter students by category
  List<Students> getStudentsByCategory(String categoryName) {
    return students.where((student) =>
    student.category?.toLowerCase() == categoryName.toLowerCase()
    ).toList();
  }

  /// Filter students by grade
  List<Students> getStudentsByGrade(String grade) {
    return students.where((student) =>
    student.grade?.toLowerCase() == grade.toLowerCase()
    ).toList();
  }

  /// Get unique grades from all students
  List<String> get availableGrades {
    return students
        .where((student) => student.grade != null && student.grade!.isNotEmpty)
        .map((student) => student.grade!)
        .toSet()
        .toList();
  }

  /// Get students count
  int get studentsCount => students.length;
  int get filteredStudentsCount => filteredStudents.length;
  bool get hasStudents => students.isNotEmpty;
  bool get hasFilteredStudents => filteredStudents.isNotEmpty;
  bool get hasAvailableCourses => availableCourses.isNotEmpty;
  bool get hasAvailableCategories => availableCategories.isNotEmpty;
}