import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

@immutable
abstract class GroupUpdateOperationsState extends Equatable {}

class GroupUpdateOperationsLoadedState extends GroupUpdateOperationsState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchGroupScheduledCallByIdState extends GroupUpdateOperationsState{
  final ScheduleNewRequestModel scheduleNewRequestModel;
  FetchGroupScheduledCallByIdState({required this.scheduleNewRequestModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchGroupScheduledCallByIdInProgressState extends GroupUpdateOperationsState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class UpdateGroupScheduleCallState extends GroupUpdateOperationsState{
  final bool isUpdated;
  UpdateGroupScheduleCallState({required this.isUpdated});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class UpdateGroupScheduleCallInProgressState extends GroupUpdateOperationsState{
  UpdateGroupScheduleCallInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class UpdateFreelancerGroupStatusInProgressState extends GroupUpdateOperationsState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

class UpdateFreelancerGroupStatusState extends GroupUpdateOperationsState{
  bool isUpdated;
  UpdateFreelancerGroupStatusState({required this.isUpdated});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}