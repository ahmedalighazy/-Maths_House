abstract class TeacherStates {}

class TeacherInitialState extends TeacherStates {}

class TeacherLoadingState extends TeacherStates {}

class TeacherSuccessState extends TeacherStates {}

class TeacherErrorState extends TeacherStates {
  final String error;
  TeacherErrorState(this.error);
}

// Add Teacher States
class TeacherAddSuccessState extends TeacherStates {}

// Update Teacher States
class TeacherUpdateSuccessState extends TeacherStates {}

// Delete Teacher States
class TeacherDeleteSuccessState extends TeacherStates {}