import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/dto/affiliate_model/affiliate_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/transaction_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LoginState extends Equatable {}

class LoginLoadedState extends LoginState {
  @override
  List<Object> get props => [];
}
class UserAlreadyRegisteredState extends LoginState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoggedInState extends LoginState {
  UserDTOModel userModel;
  LoggedInState({required this.userModel});
  @override
  List<Object> get props => [];
}

class RegisteredState extends LoginState {
  UserDTOModel userModel;
  RegisteredState({required this.userModel});
  @override
  List<Object> get props => [];
}

class GetAffiliatesState extends LoginState{
  List<AffiliateModel> affiliateModels;
  GetAffiliatesState({required this.affiliateModels});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class PasswordResetMailSentState extends LoginState {
  @override
  List<Object> get props => [];
}

class GmailLoadingState extends LoginState {
  @override
  List<Object> get props => [];
}

class LoginCompleteState extends LoginState {
  UserDTOModel userModel;
  LoginCompleteState({required this.userModel});

  dynamic getUser() {
    return this.userModel;
  }

  @override
  List<Object> get props => [];
}

class ExceptionState extends LoginState {
  String message;

  ExceptionState({this.message=""});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class SwitchRoleState extends LoginState{
  final role;
  SwitchRoleState({this.role});

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class UpdateUserState extends LoginState{
  final UserDTOModel userDTOModel;
  UpdateUserState({required this.userDTOModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class UpdateAvailabilityStatusState extends LoginState{
  final String status;
  UpdateAvailabilityStatusState({required this.status});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetUserByIdState extends LoginState {
  final UserDTOModel userDTOModel;

  GetUserByIdState({required this.userDTOModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchAffiliateTransactionsInProgressState extends LoginState{
  FetchAffiliateTransactionsInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchAffiliateTransactionsState extends LoginState{
  Map<String,List<TransactionModel>> transactions;
  FetchAffiliateTransactionsState({required this.transactions});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchFeaturedFreelancersListState extends LoginState{
  final List<UserDTOModel> userDTOModel;
  FetchFeaturedFreelancersListState({required this.userDTOModel});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}