import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_state.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
class GroupScheduleUpdateOperationsBloc extends Bloc<GroupScheduleUpdateOperationsEvent, GroupScheduleUpdateOperationsState> {
  final GroupRepository groupRepository;

  GroupScheduleUpdateOperationsBloc(this.groupRepository) : super(GroupScheduleUpdateOperationsLoadedState());

  @override
  Stream<GroupScheduleUpdateOperationsState> mapEventToState(
      GroupScheduleUpdateOperationsEvent event,
      ) async* {



    if(event is FetchFreelancerScheduledCallStatusEvent){
      yield FetchFreelancerScheduledCallStatusInProgressState();
      Map<UserDTOModel,String> userDTOModelMap={};
      try{
        DocumentSnapshot scheduledCallsResponse=await fetchScheduledCallForAGroup(event.groupModel.groupId,event.scheduleId);
        ScheduleNewRequest scheduleNewRequest=ScheduleNewRequest.fromMapWithId(scheduledCallsResponse.data() as Map<String,dynamic>,scheduledCallsResponse.id);
        for(UserDTOModel user in event.groupModel.groupMembers.keys.toList()){
          List<Freelancers> freelancers=scheduleNewRequest.freelancers.where((element) => element.id==user.userId).toList();
          if(freelancers.isNotEmpty && freelancers.length==1){
            userDTOModelMap[user]=freelancers[0].status;

          }
          else{
            userDTOModelMap[user]="Pending";
          }
        }
        yield FetchFreelancerScheduledCallStatusState(freelanceModelWithStatusMap: userDTOModelMap);
      }catch(e){
        yield FetchFreelancerScheduledCallStatusState(freelanceModelWithStatusMap: userDTOModelMap);
      }

    }
  }


  Future<DocumentSnapshot> fetchScheduledCallForAGroup(String groupId,String scheduleId)async{
    DocumentSnapshot snapshot=await this.groupRepository.getScheduledCallById(groupId,scheduleId);
    return snapshot;
  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
