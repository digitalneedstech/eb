import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

class GroupEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddFreelancerToGroupEvent extends GroupEvent{
  final UserDTOModel freelancerId;
  final String groupId;
  AddFreelancerToGroupEvent({this.groupId="",required this.freelancerId});
}

class RemoveFreelancerFromGroupEvent extends GroupEvent{
  final UserDTOModel freelancerId;
  final String groupId;
  RemoveFreelancerFromGroupEvent({required this.groupId,required this.freelancerId});
}
class CreateGroupWithoutFreelancerEvent extends GroupEvent{
  final GroupModel groupModel;
  CreateGroupWithoutFreelancerEvent({required this.groupModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class CreateGroupEvent extends GroupEvent{
  final GroupModel groupModel;
  final GroupFreelancerModel groupFreelancerModel;
  CreateGroupEvent({required this.groupModel,required this.groupFreelancerModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddUserToGroupEvent extends GroupEvent{
  final GroupFreelancerModel groupFreelancerModel;
  final String userId,groupId;
  AddUserToGroupEvent({required this.groupId, required this.groupFreelancerModel,required this.userId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddMultipleUsersToGroupEvent extends GroupEvent{
  final List<GroupFreelancerModel> groupFreelancerModel;
  final String userId,groupId;
  AddMultipleUsersToGroupEvent({required this.groupId,required this.groupFreelancerModel,required this.userId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchGroupsEvent extends GroupEvent{
  final String userId;
  final String query;
  final bool fetchMyOwnerGroups;
  FetchGroupsEvent({required this.userId,this.query="",required this.fetchMyOwnerGroups});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchGroupByIdEvent extends GroupEvent{
  final String groupId;
  final String userId;
  FetchGroupByIdEvent({this.userId="",this.groupId=""});
}



class CreateGroupScheduleCallEvent extends GroupEvent{
  final String groupId;
  final ScheduleNewRequestModel scheduleNewRequestModel;
  CreateGroupScheduleCallEvent({this.groupId="",required this.scheduleNewRequestModel});
}
