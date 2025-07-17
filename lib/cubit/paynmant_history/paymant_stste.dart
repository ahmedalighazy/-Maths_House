// paymant_stste.dart
abstract class PaymantHistoryState {}

class PaymantHistoryInitial extends PaymantHistoryState {}

class PaymantHistoryLoading extends PaymantHistoryState {}

class PaymantHistorySuccess extends PaymantHistoryState {}

class PaymantHistoryError extends PaymantHistoryState {
  final String message;

  PaymantHistoryError(this.message);
}