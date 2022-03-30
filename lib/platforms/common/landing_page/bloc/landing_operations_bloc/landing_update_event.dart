import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class LandingUpdateEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddFreelancerToGroupEvent extends LandingUpdateEvent{
  final UserDTOModel userDTOModel;
  AddFreelancerToGroupEvent({required this.userDTOModel});
}

class RemoveFreelancerToGroupEvent extends LandingUpdateEvent{
  final String userId;
  RemoveFreelancerToGroupEvent({required this.userId});
}

class AddUsersToGroupEvent extends LandingUpdateEvent{
  final String groupId;
  final String ownerId;
  AddUsersToGroupEvent({required this.groupId,required this.ownerId});
}

