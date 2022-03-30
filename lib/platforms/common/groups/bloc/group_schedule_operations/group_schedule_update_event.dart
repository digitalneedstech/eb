import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';

class GroupScheduleUpdateOperationsEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchFreelancerScheduledCallStatusEvent extends GroupScheduleUpdateOperationsEvent{
  final GroupModel groupModel;
  final String scheduleId;
  FetchFreelancerScheduledCallStatusEvent({required this.scheduleId,required this.groupModel});
}
