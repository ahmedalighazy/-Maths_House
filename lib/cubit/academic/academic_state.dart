import 'package:maths_house/model/academic_model.dart';

abstract class AcademicState {}

class AcademicInitial extends AcademicState {}

class AcademicLoadingState extends AcademicState {}

class AcademicSuccessState extends AcademicState {
  final AcademicModel academicModel;

  AcademicSuccessState(this.academicModel);
}

class AcademicErrorState extends AcademicState {
  final String error;

  AcademicErrorState(this.error);
}

class AcademicAddingCoursesState extends AcademicState {}

class AcademicCoursesAddedSuccessState extends AcademicState {
  final String message;

  AcademicCoursesAddedSuccessState({required this.message});
}