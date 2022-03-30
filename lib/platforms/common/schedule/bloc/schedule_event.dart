
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_update_request_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

class ScheduleCallEvent extends Equatable {
  @override
  List<Object> get props => [];
}


class FetchScheduledCallInfoEvent extends ScheduleCallEvent{
  String userId,scheduledId;
  FetchScheduledCallInfoEvent({required this.userId,required this.scheduledId});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FetchCallInfoEvent extends ScheduleCallEvent{
  String userId,channelId;
  FetchCallInfoEvent({required this.userId,required this.channelId});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FetchScheduledGroupCallInfoEvent extends ScheduleCallEvent{
  String groupId,scheduledId;
  FetchScheduledGroupCallInfoEvent({required this.groupId,required this.scheduledId});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class UpdateDurationInCreatingScheduledCallEvent extends ScheduleCallEvent{
  double duration;
  UpdateDurationInCreatingScheduledCallEvent({required this.duration});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CreateScheduleEvent extends ScheduleCallEvent{
  final ScheduleRequest scheduleRequest;
  CreateScheduleEvent({required this.scheduleRequest});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CreateGroupScheduleEvent extends ScheduleCallEvent{
  final ScheduleNewRequestModel scheduleNewRequestModel;
  final String userName;
  final List<String> freelancers;
  CreateGroupScheduleEvent({required this.scheduleNewRequestModel,required this.freelancers,
    required this.userName});
  @override
  // TODO: implement props
  List<Object> get props => [];
}



class UpdateScheduleEvent extends ScheduleCallEvent{
  final ScheduleRequest scheduleRequest;
  final ScheduleUpdateRequest scheduleUpdateRequest;
  UpdateScheduleEvent({required this.scheduleRequest,required this.scheduleUpdateRequest});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CreateCallEvent extends ScheduleCallEvent{
  final CallModel callModel;
  CreateCallEvent({required this.callModel});

}
