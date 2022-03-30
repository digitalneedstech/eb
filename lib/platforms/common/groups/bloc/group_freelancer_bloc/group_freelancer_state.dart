import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

@immutable
abstract class GroupFreelancerState extends Equatable {}

class LoadingGroupRemovalState extends GroupFreelancerState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class GroupFreelancersLoadedState extends GroupFreelancerState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveFreelancerFromGroupState extends GroupFreelancerState{
  final bool isUserDeleted;
  RemoveFreelancerFromGroupState({required this.isUserDeleted});

  @override
  // TODO: implement props
  List<Object> get props => [];
}