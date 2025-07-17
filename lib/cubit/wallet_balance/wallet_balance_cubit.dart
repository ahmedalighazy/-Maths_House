import 'dart:developer';
import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:maths_house/controller/dio/dio_helper.dart';
import 'package:maths_house/controller/dio/end_points.dart';
import 'package:maths_house/cubit/wallet_balance/wallet_balance_state.dart';
import 'package:maths_house/controller/cache/cache_helper.dart';
import 'package:dio/dio.dart';
import 'package:maths_house/model/wallet_balance_model.dart';

class WalletBalanceCubit extends Cubit<WalletBalanceState> {
  WalletBalanceCubit() : super(WalletBalanceInitial());

  static WalletBalanceCubit get(context) => BlocProvider.of(context);

  WalletBalanceModel? walletBalanceModel;
  num? currentBalance;
  bool isLoading = false;
  String? lastError;
  DateTime? lastUpdated;
  int? currentUserId; // إضافة متغير لحفظ الـ userId الحالي

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
        return 'Wallet not found.';
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

  /// Get wallet balance with user ID
  Future<void> getWalletBalance({required int userId}) async {
    if (isLoading) return;

    isLoading = true;
    currentUserId = userId;
    emit(WalletBalanceLoadingState());

    try {
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        lastError = 'Authentication token not found. Please login again.';
        emit(WalletBalanceErrorState(lastError!));
        return;
      }

      final String url = '${EndPoints.WalletBalance}/$userId';

      log('🔍 Fetching wallet balance from: $url');

      final response = await DioHelper.getData(
        url: url,
        token: token,
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          lastError = 'No data received from server';
          emit(WalletBalanceErrorState(lastError!));
          return;
        }

        log('✅ Wallet balance response received');
        log('📄 Response data: ${response.data}');

        walletBalanceModel = WalletBalanceModel.fromJson(response.data);
        currentBalance = walletBalanceModel?.balance ?? 0;
        lastUpdated = DateTime.now();
        lastError = null;

        log('💰 Current balance: $currentBalance');
        emit(WalletBalanceSuccessState(walletBalanceModel!));
      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        lastError = errorMessage;
        log('❌ Failed to load wallet balance: ${response.statusMessage}');
        emit(WalletBalanceErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      lastError = errorMessage;
      log('❌ Network error (getWalletBalance): ${error.toString()}');
      emit(WalletBalanceErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }

  /// Charge wallet balance
  Future<void> chargeWallet({
    required int studentId,
    required num amount,
  }) async {
    if (isLoading) return;

    isLoading = true;
    emit(WalletBalanceLoadingState());

    try {
      final token = await _getAuthToken();

      if (token == null || token.isEmpty) {
        lastError = 'Authentication token not found. Please login again.';
        emit(WalletBalanceErrorState(lastError!));
        return;
      }

      log('💳 Charging wallet for student: $studentId with amount: $amount');

      final response = await DioHelper.postData(
        url: EndPoints.WalletBalanceCharge,
        data: {
          'student_id': studentId,
          'wallet': amount,
        },
        token: token,
      );

      if (response.statusCode == 200) {
        if (response.data == null) {
          lastError = 'No data received from server';
          emit(WalletBalanceErrorState(lastError!));
          return;
        }

        log('✅ Wallet charged successfully');
        log('📄 Response data: ${response.data}');

        if (currentBalance != null) {
          currentBalance = currentBalance! + amount;
        }

        if (walletBalanceModel != null) {
          walletBalanceModel!.balance = currentBalance;
        }

        lastUpdated = DateTime.now();
        lastError = null;

        emit(WalletBalanceChargeSuccessState(response.data['success'] ?? 'Wallet charged successfully'));

        await refreshWalletBalance();

      } else {
        final errorMessage = _getErrorMessage(DioException(
          requestOptions: response.requestOptions,
          response: response,
          type: DioExceptionType.badResponse,
        ));
        lastError = errorMessage;
        log('❌ Failed to charge wallet: ${response.statusMessage}');
        emit(WalletBalanceErrorState(errorMessage));
      }
    } catch (error) {
      final errorMessage = _getErrorMessage(error);
      lastError = errorMessage;
      log('❌ Network error (chargeWallet): ${error.toString()}');
      emit(WalletBalanceErrorState(errorMessage));
    } finally {
      isLoading = false;
    }
  }


  /// Refresh wallet balance
  Future<void> refreshWalletBalance() async {
    if (currentUserId != null) {
      await getWalletBalance(userId: currentUserId!);
    }
  }

  /// Check if balance is sufficient for a transaction
  bool isBalanceSufficient(num requiredAmount) {
    if (currentBalance == null) return false;
    return currentBalance! >= requiredAmount;
  }

  /// Get formatted balance string
  String getFormattedBalance({String currency = 'EGP'}) {
    if (currentBalance == null) return '0.00 $currency';
    return '${currentBalance!.toStringAsFixed(2)} $currency';
  }

  /// Get balance as double
  double getBalanceAsDouble() {
    return currentBalance?.toDouble() ?? 0.0;
  }

  /// Get balance as int
  int getBalanceAsInt() {
    return currentBalance?.toInt() ?? 0;
  }

  /// Check if wallet has any balance
  bool hasBalance() {
    return currentBalance != null && currentBalance! > 0;
  }

  /// Check if data is fresh (less than 5 minutes old)
  bool isDataFresh() {
    if (lastUpdated == null) return false;
    return DateTime.now().difference(lastUpdated!).inMinutes < 5;
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

  /// Simulate balance deduction (for UI purposes only)
  /// This should be followed by a refresh call to get actual balance
  void simulateBalanceDeduction(num amount) {
    if (currentBalance != null && currentBalance! >= amount) {
      currentBalance = currentBalance! - amount;

      // Update the model
      if (walletBalanceModel != null) {
        walletBalanceModel!.balance = currentBalance;
      }

      emit(WalletBalanceSuccessState(walletBalanceModel!));

      // Refresh from server after a short delay
      Future.delayed(Duration(seconds: 1), () {
        refreshWalletBalance();
      });
    }
  }

  /// Simulate balance addition (for UI purposes only)
  /// This should be followed by a refresh call to get actual balance
  void simulateBalanceAddition(num amount) {
    if (currentBalance != null) {
      currentBalance = currentBalance! + amount;

      // Update the model
      if (walletBalanceModel != null) {
        walletBalanceModel!.balance = currentBalance;
      }

      emit(WalletBalanceSuccessState(walletBalanceModel!));

      // Refresh from server after a short delay
      Future.delayed(Duration(seconds: 1), () {
        refreshWalletBalance();
      });
    }
  }

  /// Clear error state
  void clearError() {
    lastError = null;
    if (walletBalanceModel != null) {
      emit(WalletBalanceSuccessState(walletBalanceModel!));
    } else {
      emit(WalletBalanceInitial());
    }
  }

  /// Reset state
  void resetState() {
    walletBalanceModel = null;
    currentBalance = null;
    lastError = null;
    lastUpdated = null;
    isLoading = false;
    currentUserId = null;
    emit(WalletBalanceInitial());
  }

  // Getters
  bool get hasWalletData => walletBalanceModel != null;
  bool get hasError => lastError != null;
  String? get errorMessage => lastError;
  DateTime? get lastUpdateTime => lastUpdated;
}