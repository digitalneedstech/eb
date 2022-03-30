import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/dto/feedback/user_feedback.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class UserFeedbackEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddUserFeedbackEvent extends UserFeedbackEvent{
  final String userId;
  final UserFeedbackModel userFeedbackModel;
  AddUserFeedbackEvent({required this.userId,required this.userFeedbackModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchFeedbacksEvent extends UserFeedbackEvent{
  final String userId;
  FetchFeedbacksEvent({required this.userId});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
