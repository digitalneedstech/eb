import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

@immutable
abstract class GroupScheduleUpdateOperationsState extends Equatable {}


class GroupScheduleUpdateOperationsLoadedState extends GroupScheduleUpdateOperationsState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchFreelancerScheduledCallStatusState extends GroupScheduleUpdateOperationsState{
  final Map<UserDTOModel,String> freelanceModelWithStatusMap;
  FetchFreelancerScheduledCallStatusState({required this.freelanceModelWithStatusMap});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchFreelancerScheduledCallStatusInProgressState extends GroupScheduleUpdateOperationsState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}