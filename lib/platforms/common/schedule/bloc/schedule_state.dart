import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';

@immutable
abstract class ScheduledState extends Equatable {}
class ScheduledLoadedState extends ScheduledState {
  @override
  List<Object> get props => [];
}

class ScheduledInfoState extends ScheduledState {
  ScheduleRequest scheduleModel;
  ScheduledInfoState({required this.scheduleModel});
  @override
  List<Object> get props => [];
}

class CallInfoState extends ScheduledState {
  CallModel callModel;
  CallInfoState({required this.callModel});
  @override
  List<Object> get props => [];
}

class ScheduledListState extends ScheduledState {
  List<ScheduleRequest> bidModels;
  ScheduledListState({required this.bidModels});
  @override
  List<Object> get props => [];
}

class CreatedScheduledState extends ScheduledState {
  bool isUpdated;
  CreatedScheduledState({required this.isUpdated});
  @override
  List<Object> get props => [];
}

class CreatedGroupScheduledState extends ScheduledState {
  bool isCreated;
  CreatedGroupScheduledState({required this.isCreated});
  @override
  List<Object> get props => [];
}

class UpdatedScheduledState extends ScheduledState {
  bool isUpdated;
  UpdatedScheduledState({required this.isUpdated});
  @override
  List<Object> get props => [];
}

class LoadingScheduleState extends ScheduledState {
  @override
  List<Object> get props => [];
}

class CreatingGroupScheduleState extends ScheduledState {
  @override
  List<Object> get props => [];
}

class UpdatedDurationForScheduledCallState extends ScheduledState{
  final double duration;
  UpdatedDurationForScheduledCallState({required this.duration});
  @override
  // TODO: implement props
  List<Object> get props => [];

}
class CreateCallState extends ScheduledState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}





