abstract class StudentStates {}

class StudentInitialState extends StudentStates {}

class StudentLoadingState extends StudentStates {}

class StudentSuccessState extends StudentStates {}

class StudentErrorState extends StudentStates {
  final String error;
  final String? errorCode;

  StudentErrorState(this.error, {this.errorCode});
}

// Validation state
class StudentValidatingState extends StudentStates {}

// Authentication state
class StudentAuthenticatingState extends StudentStates {}

// Upload state
class StudentUploadingState extends StudentStates {}

// Refresh state
class StudentRefreshingState extends StudentStates {}

// CRUD operation states
class StudentAddSuccessState extends StudentStates {
  final String message;

  StudentAddSuccessState({required this.message});
}

class StudentUpdateSuccessState extends StudentStates {
  final String message;

  StudentUpdateSuccessState({required this.message});
}

class StudentDeleteSuccessState extends StudentStates {
  final String message;

  StudentDeleteSuccessState({required this.message});
}