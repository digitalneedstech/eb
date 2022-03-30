import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class LandingUpdateState extends Equatable {}
class LandingUpdateLoadedState extends LandingUpdateState {
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class AddOrRemoveFreelancerToGroupState extends LandingUpdateState {
  List<String> userIds;
  AddOrRemoveFreelancerToGroupState({required this.userIds});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddOrRemoveFreelancerToGroupInProgressState extends LandingUpdateState{
  AddOrRemoveFreelancerToGroupInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddUsersToGroupInProgressState extends LandingUpdateState{
  @override
  // TODO: implement props
  List<Object> get props => [];

}



class AddUsersToGroupState extends LandingUpdateState{
  final bool isAdded;
  AddUsersToGroupState({required this.isAdded});
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}

