import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/controller/cache/cache_helper.dart';
import 'package:maths_house/controller/dio/dio_helper.dart';
import 'package:maths_house/controller/dio/end_points.dart';
import 'package:maths_house/cubit/login/login_state.dart';
import 'package:maths_house/model/user_model.dart';


class LoginCubit extends Cubit<LoginStates> {
  LoginCubit() : super(LoginInitialState());

  static LoginCubit get(context) => BlocProvider.of(context);

  bool obscurePassword = true;

  void changePasswordVisibility() {
    obscurePassword = !obscurePassword;
    emit(LoginChangePasswordVisibilityState());
  }

  UserModel? userModel;

  Future<void> userLogin({
    required String email,
    required String password,
  }) async {
    emit(LoginLoadingState());

    try {
      final value = await DioHelper.postData(
        url: EndPoints.Login,
        data: {
          'email': email,
          'password': password,
        },
      );
      log(value.statusCode.toString());
      log(value.statusMessage.toString());
      log(value.data.toString());
      log(value.data.toString());
      userModel = UserModel.fromJson(value.data);
      CacheHelper.saveData(key: 'token', value: userModel?.token);
      log('Token: {${CacheHelper.getData(key: 'token')}}');
      emit(LoginSuccessState());
    } catch (error) {
      log(error.toString());

      String errorMessage = 'An error occurred. Please try again.';

      if (error is DioException) {
        switch (error.response?.statusCode) {
          case 403:
          case 401:
            errorMessage = 'Wrong email or password';
            break;
          case 422:
            errorMessage = 'Invalid input data';
            break;
          case 429:
            errorMessage = 'Too many attempts. Please try again later';
            break;
          case 500:
            errorMessage = 'Server error. Please try again later';
            break;
          default:
            if (error.response?.statusCode != null) {
              errorMessage =
              'Error ${error.response?.statusCode}: ${error.response?.statusMessage ?? 'Unknown error'}';
            } else if (error.type == DioExceptionType.connectionTimeout) {
              errorMessage =
              'Connection timeout. Please check your internet connection';
            } else if (error.type == DioExceptionType.receiveTimeout) {
              errorMessage = 'Server response timeout. Please try again';
            } else if (error.type == DioExceptionType.connectionError) {
              errorMessage = 'No internet connection';
            }
            break;
        }
      }

      emit(LoginErrorState(errorMessage));
    }
  }
}
