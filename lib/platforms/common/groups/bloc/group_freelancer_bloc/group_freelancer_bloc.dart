
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_freelancer_bloc/group_freelancer_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_freelancer_bloc/group_freelancer_state.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
class GroupFreelancerBloc extends Bloc<GroupFreelancerEvent, GroupFreelancerState> {
  final GroupRepository groupRepository;
  final NotificationRepository notificationRepository;
  GroupFreelancerBloc(this.groupRepository,this.notificationRepository) : super(GroupFreelancersLoadedState());

  @override
  Stream<GroupFreelancerState> mapEventToState(
      GroupFreelancerEvent event,
      ) async* {

    if(event is RemoveFreelancerFromGroupEvent){
      yield LoadingGroupRemovalState();
      try{
        await groupRepository.removeUserFromFreelancer(event.groupId,event.freelancerId);
        yield RemoveFreelancerFromGroupState(isUserDeleted: true);
      }catch(e){
        yield RemoveFreelancerFromGroupState(isUserDeleted: false);
      }
    }
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
