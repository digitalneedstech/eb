import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_group_update_request.dart';

class GroupUpdateOperationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchGroupScheduledCallByIdEvent extends GroupUpdateOperationsEvent{
  final String groupId;
  final String schedueId;
  FetchGroupScheduledCallByIdEvent({required this.groupId,required this.schedueId});
}


class UpdateGroupScheduleCallEvent extends GroupUpdateOperationsEvent{
  final String groupId;
  final String groupOwnerId;
  final ScheduleUpdateGroupRequest scheduleNewRequestModel;
  UpdateGroupScheduleCallEvent({required this.groupOwnerId,required this.groupId,required this.scheduleNewRequestModel});
}

class UpdateFreelancerGroupStatusEvent extends GroupUpdateOperationsEvent{
  final String groupId,freelancerId,status;
  UpdateFreelancerGroupStatusEvent({required this.groupId,required this.freelancerId,required this.status});
}