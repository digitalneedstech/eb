
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_state.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
class GroupOperationsBloc extends Bloc<GroupOperationsEvent, GroupOperationsState> {
  final GroupRepository groupRepository;
  final NotificationRepository notificationRepository;
  GroupOperationsBloc(this.groupRepository,this.notificationRepository) : super(GroupOperationsLoadedState());

  @override
  Stream<GroupOperationsState> mapEventToState(
      GroupOperationsEvent event,
      ) async* {

    if(event is ScheduleGroupCallEvent){
      yield GroupSchedulingInProgressState();
      try{
        bool isScheduled=await scheduleGroupCall(event.scheduleNewRequestModel);
        yield ScheduleGroupCallState(isScheduled: isScheduled);
      }catch(e){
        yield ScheduleGroupCallState(isScheduled: false);
      }
    }
    if(event is DeleteGroupEvent){
      yield LoadingGroupDeleteOperationsState();
      try {
        await deleteGroup(event.groupId);
        yield DeleteGroupState(isGroupDeleted: true);
      }
      catch(e){
        yield DeleteGroupState(isGroupDeleted: false);
      }
    }
    if(event is FetchGroupScheduledCallsEvent){
      yield FetchScheduledCallsInProgressState();
      List<ScheduleNewRequest> scheduledCalls=[];
      try{
        QuerySnapshot scheduledCallsResponse=await fetchScheduledGroupCalls(event.groupId);
        if(scheduledCallsResponse.docs.isEmpty){
          yield FetchScheduledCallsState(scheduledCalls: scheduledCalls);
        }
        else {
          for(DocumentSnapshot e in scheduledCallsResponse.docs){
            scheduledCalls.add(ScheduleNewRequest.fromMapWithId(e.data() as Map<String,dynamic>,e.id));
          }
          yield FetchScheduledCallsState(scheduledCalls: scheduledCalls);
        }
      }catch(e){
        yield FetchScheduledCallsState(scheduledCalls: scheduledCalls);
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

  Future<void> deleteGroup(String groupId)async{
    this.groupRepository.deleteGroup(groupId);
  }

  Future<bool> scheduleGroupCall(ScheduleNewRequestModel scheduleNewRequestModel)async{
    bool isScheduled=await this.groupRepository.createGroupSchedule(scheduleNewRequestModel);

    if(isScheduled) {
      DateTime date= DateTime.parse(scheduleNewRequestModel.schedule.callScheduled);
      String day=date.day.toString()+"th "+Constants.months[date.month]!;
      String time=date.hour.toString()+":"+date.minute.toString();
      if(scheduleNewRequestModel.schedule.freelancers!=null &&
          scheduleNewRequestModel.schedule.freelancers.isNotEmpty) {
        for (Freelancers freelancer in scheduleNewRequestModel.schedule
            .freelancers) {
          NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
              "notification",
              NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
                  "Group Notification",
                  "${scheduleNewRequestModel.schedule
                      .userName} has schedule a group call with you on $day at"
                      "$time"
              ),data: new NotificationMessageDataPayload(
                  "",                      freelancer.id,
                  "schedule","freelancer",scheduleNewRequestModel.schedule.userId
              )),

          );
          notificationRepository.sendNotification(notificationMessage);
        }
      }


    }
    return isScheduled;
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
