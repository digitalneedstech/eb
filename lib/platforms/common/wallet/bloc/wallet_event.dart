import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/wallet/model/transaction_response.dart';

class WalletEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class InitiateTransactionEvent extends WalletEvent {
  String userId,currency;
  int amount;

  InitiateTransactionEvent({required this.userId,required this.amount,required this.currency});
}

class UpdateTransactionEvent extends WalletEvent {
  String userId,transactionId;
  dynamic transactionResponse;

  UpdateTransactionEvent({required this.userId,required this.transactionId,this.transactionResponse});
}