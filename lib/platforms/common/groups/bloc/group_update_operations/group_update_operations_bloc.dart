
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_state.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_group_update_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
class GroupUpdateOperationsBloc extends Bloc<GroupUpdateOperationsEvent, GroupUpdateOperationsState> {
  final GroupRepository groupRepository;
  final NotificationRepository notificationRepository;
  GroupUpdateOperationsBloc(this.groupRepository,this.notificationRepository) : super(GroupUpdateOperationsLoadedState());

  @override
  Stream<GroupUpdateOperationsState> mapEventToState(
      GroupUpdateOperationsEvent event,
      ) async* {

    if(event is FetchGroupScheduledCallByIdEvent){
      yield FetchGroupScheduledCallByIdInProgressState();
      DocumentSnapshot snapshot=await getScheduledCallById(event.groupId, event.schedueId);
      ScheduleNewRequest scheduleNewRequest=new ScheduleNewRequest.fromMapWithId(snapshot.data() as Map<String,dynamic>,snapshot.id);
      ScheduleNewRequestModel scheduleNewRequestModel=new ScheduleNewRequestModel(
          type: "group",schedule: scheduleNewRequest
      );
      yield FetchGroupScheduledCallByIdState(scheduleNewRequestModel: scheduleNewRequestModel);
    }

    if(event is UpdateGroupScheduleCallEvent){
      yield UpdateGroupScheduleCallInProgressState();
      try {
        bool isUpdated=await updateScheduleCall(event.scheduleNewRequestModel,event.groupOwnerId);
        yield UpdateGroupScheduleCallState(isUpdated: isUpdated);
      }catch(e){
        yield UpdateGroupScheduleCallState(isUpdated: false);
      }
    }
    if(event is UpdateFreelancerGroupStatusEvent){
      yield UpdateGroupScheduleCallInProgressState();
      try {
        groupRepository.updateFreelancersStatus(
            event.groupId, event.freelancerId, event.status);
        yield UpdateFreelancerGroupStatusState(isUpdated: true);
      }
      catch(e){
        yield UpdateFreelancerGroupStatusState(isUpdated: false);
      }

    }

  }

  void createGroup(GroupModel groupModel){
    this.groupRepository.createGroup(groupModel);
  }
  Future<DocumentSnapshot> getScheduledCallById(String groupId,String scheduleId)async{
    return this.groupRepository.getScheduledCallById(groupId, scheduleId);
  }

  Future<QuerySnapshot> fetchScheduledGroupCalls(String groupId)async{
    QuerySnapshot snapshot=await this.groupRepository.getScheduledCallsInAGroup(groupId);
    return snapshot;
  }


  void addUserToGroup(String groupId, GroupFreelancerModel groupFreelancerModel,String userId){
    this.groupRepository.addFreelancerToGroup(groupFreelancerModel, groupId);
  }


  void deleteGroup(String groupId){
    this.groupRepository.deleteGroup(groupId);
  }

  Future<bool> scheduleGroupCall(ScheduleNewRequestModel scheduleNewRequestModel){
    return this.groupRepository.createGroupSchedule(scheduleNewRequestModel);
  }

  Future<bool> updateScheduleCall(ScheduleUpdateGroupRequest scheduleNewRequestModel,String groupOwnerId)async{
    bool isScheduleUpdated=await this.groupRepository.updateGroupSchedule(scheduleNewRequestModel);
    if(isScheduleUpdated) {
      String statusText = "accepted";
      if (scheduleNewRequestModel.status == "Rejected") {
        statusText = "rejected";
      }
      NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
          "notification",
          NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
              "Group Notification",
              "${scheduleNewRequestModel.freelancerName}"
                  " has $statusText your schedule"
          ),data: new NotificationMessageDataPayload(
              scheduleNewRequestModel.id,
              groupOwnerId,
              "group","user",scheduleNewRequestModel.freelancerId
          )),

      );
      notificationRepository.sendNotification(notificationMessage);
    }
    return isScheduleUpdated;
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
