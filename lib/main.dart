import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/cubit/academic/academic_cubit.dart';
import 'package:maths_house/cubit/paynmant_history/paymant_cubit.dart';
import 'package:maths_house/cubit/student/student_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:maths_house/views/auth/login.dart';
import 'package:maths_house/views/home/home_screen.dart';
import 'package:maths_house/cubit/login/login_cubit.dart';
import 'package:maths_house/cubit/teacher/teacher_cubit.dart';
import 'package:maths_house/controller/dio/dio_helper.dart';
import 'package:maths_house/controller/cache/cache_helper.dart';

import 'cubit/wallet_balance/wallet_balance_cubit.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  DioHelper.init();

  await CacheHelper.init();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? token = prefs.getString('token');

  runApp(MyApp(isLoggedIn: token != null));
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<LoginCubit>(
          create: (context) => LoginCubit(),
        ),
        BlocProvider<TeacherCubit>(
          create: (context) => TeacherCubit(),
        ),
        BlocProvider<StudentCubit>(
          create: (context) => StudentCubit(),
        ),
        BlocProvider<PaymantCubit>(
          create: (context) => PaymantCubit(),
        ),
        BlocProvider<WalletBalanceCubit>(
          create: (context) => WalletBalanceCubit(),
        ),
        BlocProvider<AcademicCubit>(
          create: (context) => AcademicCubit(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: isLoggedIn ? const HomeScreen() : const LoginScreen(),
      ),
    );
  }
}
