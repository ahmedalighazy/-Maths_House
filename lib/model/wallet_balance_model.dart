class WalletBalanceModel {
  WalletBalanceModel({
      this.balance,});

  WalletBalanceModel.fromJson(dynamic json) {
    balance = json['balance'];
  }
  num? balance;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['balance'] = balance;
    return map;
  }

}