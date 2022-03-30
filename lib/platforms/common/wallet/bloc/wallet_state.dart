import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class WalletState extends Equatable {}

class WalletLoadedState extends WalletState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class InitiateTransactionEventState extends WalletState {
  final String  transactionId;
  InitiateTransactionEventState({required this.transactionId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingWalletState extends WalletState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}


class UpdateTransactionState extends WalletState {
  UserDTOModel userDTOModel;
  UpdateTransactionState({required this.userDTOModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
