import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';

@immutable
abstract class GroupState extends Equatable {}

class GroupLoadedState extends GroupState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class AddFreelancerToGroupState extends GroupState{
  final String groupId;
  AddFreelancerToGroupState({required this.groupId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class RemoveFreelancerToGroupState extends GroupState{
  final String groupId;
  RemoveFreelancerToGroupState({required this.groupId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddUserToGroupState extends GroupState{
  final bool isUserRequested;
  AddUserToGroupState({this.isUserRequested=false});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class CreateGroupState extends GroupState{
  final bool isGroupCreated;
  CreateGroupState({this.isGroupCreated=false});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingGroupState extends GroupState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchGroupByIdState extends GroupState{
  final GroupModel groupModel;
  FetchGroupByIdState({required this.groupModel});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
class FetchGroupsState extends GroupState{
  final List<GroupModel> listOfGroupModels;
  FetchGroupsState({required this.listOfGroupModels});
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class AddMultipleUsersToGroupState extends GroupState{
  AddMultipleUsersToGroupState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddMultipleUsersToGroupInProgressState extends GroupState{
  AddMultipleUsersToGroupInProgressState();
  @override
  // TODO: implement props
  List<Object> get props => [];
}