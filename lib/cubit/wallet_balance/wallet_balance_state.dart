import 'package:maths_house/model/wallet_balance_model.dart';

abstract class WalletBalanceState {}

class WalletBalanceInitial extends WalletBalanceState {}

class WalletBalanceLoadingState extends WalletBalanceState {}

class WalletBalanceSuccessState extends WalletBalanceState {
  final WalletBalanceModel walletBalanceModel;

  WalletBalanceSuccessState(this.walletBalanceModel);
}

class WalletBalanceErrorState extends WalletBalanceState {
  final String error;

  WalletBalanceErrorState(this.error);
}

class WalletBalanceRefreshingState extends WalletBalanceState {
  final WalletBalanceModel previousData;

  WalletBalanceRefreshingState(this.previousData);
}

class WalletBalanceUpdateState extends WalletBalanceState {
  final WalletBalanceModel walletBalanceModel;
  final String message;

  WalletBalanceUpdateState(this.walletBalanceModel, this.message);
}


class WalletBalanceChargeSuccessState extends WalletBalanceState {
  final String message;
  WalletBalanceChargeSuccessState(this.message);
}

class WalletBalancePaymentSuccessState extends WalletBalanceState {
  final String message;
  WalletBalancePaymentSuccessState(this.message);
}