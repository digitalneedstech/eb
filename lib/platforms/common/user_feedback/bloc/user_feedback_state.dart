import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/dto/affiliate_model/affiliate_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/feedback/user_feedback.dart';
import 'package:flutter_eb/platforms/common/login/dto/transaction_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class UserFeedbackState extends Equatable {}

class UserFeedbackLoadedState extends UserFeedbackState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddFeedbackState extends UserFeedbackState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class FetchFeedbacksState extends UserFeedbackState {
  List<UserFeedbackModel> feedbacks;
  FetchFeedbacksState({required this.feedbacks});
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class FeedbackLoadingState extends UserFeedbackState {
  @override
  List<Object> get props => [];
}

class AddFeedbackExceptionState extends UserFeedbackState {
  String message;

  AddFeedbackExceptionState({required this.message});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}
