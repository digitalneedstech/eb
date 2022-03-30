import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

class GroupOperationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class CreateGroupEvent extends GroupOperationsEvent{
  final GroupModel groupModel;
  CreateGroupEvent({required this.groupModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class FetchGroupScheduledCallsEvent extends GroupOperationsEvent{
  final String groupId;
  FetchGroupScheduledCallsEvent({required this.groupId});
}

class AddUserToGroupEvent extends GroupOperationsEvent{
  final GroupFreelancerModel groupFreelancerModel;
  final String userId,groupId;
  AddUserToGroupEvent({required this.groupId, required this.groupFreelancerModel,required this.userId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class DeleteGroupEvent extends GroupOperationsEvent{
  final String groupId;
  DeleteGroupEvent({required this.groupId});
}

class ScheduleGroupCallEvent extends GroupOperationsEvent{
  final ScheduleNewRequestModel scheduleNewRequestModel;
  ScheduleGroupCallEvent({required this.scheduleNewRequestModel});
}