import 'package:equatable/equatable.dart';

class GroupFreelancerEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class RemoveFreelancerFromGroupEvent extends GroupFreelancerEvent{
  final String groupId,freelancerId;
  RemoveFreelancerFromGroupEvent({required this.groupId,required this.freelancerId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
