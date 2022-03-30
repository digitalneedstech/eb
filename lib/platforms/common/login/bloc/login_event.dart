import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class LoginEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UpdateUserEvent extends LoginEvent{
  final UserDTOModel userDTOModel;
  UpdateUserEvent({required this.userDTOModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RegistrationStartedEvent extends LoginEvent {
  String email, password, confirmPassword;
  String selectedType;
  String senderId,typeOfDeepLink;

  RegistrationStartedEvent({required this.typeOfDeepLink,
    required this.senderId,required this.email, required this.password,required  this.confirmPassword,
    required this.selectedType});
}

class GetAffiliatesEvent extends LoginEvent{
  String senderId;
  GetAffiliatesEvent({required this.senderId});
}

class LoginStartedEvent extends LoginEvent {
  String email, password;

  LoginStartedEvent({required this.email,required  this.password});
}

class ForgotPasswordEvent extends LoginEvent {
  String email;

  ForgotPasswordEvent({required this.email});
}

class SwitchRoleEvent extends LoginEvent{
  final bool role;
  SwitchRoleEvent({required  this.role});
}

class GmailLoginEvent extends LoginEvent {}

class AppStartEvent extends LoginEvent {}

class UpdateAvailabilityStatus extends LoginEvent{
  final String status;
  UpdateAvailabilityStatus({required this.status});
}

class GetUserByIdEvent extends LoginEvent{
  final String userId;
  GetUserByIdEvent({required this.userId});

}

class FetchAffiliateTransactions extends LoginEvent{
  final String userId;
  FetchAffiliateTransactions({required this.userId});

}

class FetchFeaturedFreelancersList extends LoginEvent{

}
