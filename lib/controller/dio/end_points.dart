abstract class EndPoints {
  static const String Login = '/admin_app/login';
  static const String Teachers = '/admin_app/teacher';
  static const String AddTeachers = '/admin_app/teacher/add';
  static const String UpdateTeachers = '/admin_app/teacher/update';
  static const String DeleteTeachers = '/admin_app/teacher/delete';
  static const String Student = '/admin_app/student';
  static const String AddStudent = '/admin_app/student/add';
  static const String UpdateStudent = '/admin_app/student/update';
  static const String DeleteStudent = '/admin_app/student/delete';
  static const String Paymant = '/admin_app/student/payment_history';
  static const String WalletBalance = '/admin_app/student/wallet_balance';
  static const String WalletBalanceCharge = '/admin_app/student/charge_wallet';
  static const String AcademicList = '/admin_app/student/academic_list';
  ///academic list
  static const String baseUrl = 'https://login.mathshouse.net/';
  static const String adminAppUrl = 'admin_app/';
  static const String studentUrl = 'student/';
  static const String AcademicListStu = '${baseUrl}${adminAppUrl}${studentUrl}academic_list';
  static const String AcademicListAdd = '${baseUrl}${adminAppUrl}${studentUrl}academic_list_add';

}