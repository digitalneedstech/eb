import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

@immutable
abstract class GroupOperationsState extends Equatable {}

class GroupOperationsLoadedState extends GroupOperationsState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CreateGroupState extends GroupOperationsState{
  final bool isGroupCreated;
  CreateGroupState({@required this.isGroupCreated=false});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddUserToGroupState extends GroupOperationsState{
  final bool isUserRequested;
  AddUserToGroupState({this.isUserRequested=false});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingGroupOperationsState extends GroupOperationsState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeleteGroupState extends GroupOperationsState{
  final bool isGroupDeleted;
  DeleteGroupState({required this.isGroupDeleted});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingGroupDeleteOperationsState extends GroupOperationsState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class ScheduleGroupCallState extends GroupOperationsState{
  final bool isScheduled;
  ScheduleGroupCallState({required this.isScheduled});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class GroupSchedulingInProgressState extends GroupOperationsState{
  GroupSchedulingInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}


class UpdateGroupScheduleCallState extends GroupOperationsState{
  final bool isUpdated;
  UpdateGroupScheduleCallState({required this.isUpdated});

  @override
  // TODO: implement props
  List<Object> get props => [];
}


class UpdateGroupScheduleCallInProgressState extends GroupOperationsState{
  UpdateGroupScheduleCallInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchScheduledCallsInProgressState extends GroupOperationsState{
  FetchScheduledCallsInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchScheduledCallsState extends GroupOperationsState{
  final List<ScheduleNewRequest> scheduledCalls;
  FetchScheduledCallsState({required this.scheduledCalls});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}