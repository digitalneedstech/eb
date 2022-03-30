
import 'dart:async';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_state.dart';
import 'package:flutter_eb/platforms/common/schedule/data/schedule_repository.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_update_request_model.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class ScheduledBloc extends Bloc<ScheduleCallEvent, ScheduledState> {
  final ScheduleRepository scheduleRepository;
  final NotificationRepository notificationRepository;
  final LoginRepository loginRepository;
  ScheduledBloc(this.scheduleRepository,this.loginRepository,this.notificationRepository) : super(ScheduledLoadedState());

  StreamController<List<ScheduleMessage>> _queryController =
  StreamController.broadcast();
  Stream<List<ScheduleMessage>> get queryStream => _queryController.stream;
  late ScheduleRequest _request;
  late double _duration;

  double get duration => _duration;

  set duration(double value) {
    _duration = value;
  }

  ScheduleRequest get request => _request;

  set request(ScheduleRequest value) {
    _request = value;
  }

  @override
  Stream<ScheduledState> mapEventToState(
      ScheduleCallEvent event,
      ) async* {
    if(event is FetchScheduledCallInfoEvent){
      yield LoadingScheduleState();
      DocumentSnapshot snapshot=await getBid(event.scheduledId,event.userId);
      if(snapshot.exists)
        yield ScheduledInfoState(scheduleModel: ScheduleRequest.fromJson(snapshot.data() as Map<String,dynamic>,snapshot.id));
      else
        yield ScheduledInfoState(scheduleModel:ScheduleRequest(id: ""));
    }
    if(event is FetchCallInfoEvent){
      yield LoadingScheduleState();
      DocumentSnapshot snapshot=await getCall(event.channelId,event.userId);
      if(snapshot.exists)
        yield CallInfoState(callModel: CallModel.fromMap(snapshot.data() as Map<String,dynamic>,snapshot.id));
      else
        yield CallInfoState(callModel: CallModel());
    }

    if(event is FetchScheduledGroupCallInfoEvent){
      yield LoadingScheduleState();
      DocumentSnapshot snapshot=await getScheduledGroupCallStatus(event.groupId,event.scheduledId);
      if(snapshot.exists)
        yield ScheduledInfoState(scheduleModel: ScheduleRequest.fromJson(snapshot.data() as Map<String,dynamic>,snapshot.id));
      else
        yield ScheduledInfoState(scheduleModel:ScheduleRequest(id: ""));
    }

    if(event is CreateScheduleEvent){
      yield LoadingScheduleState();
      bool isUpdatedFlag=await createOrUpdateScheduledCall(event.scheduleRequest);
      yield CreatedScheduledState(isUpdated: isUpdatedFlag);
    }

    if(event is CreateGroupScheduleEvent){
      yield CreatingGroupScheduleState();
      bool isUpdatedFlag=await createOrUpdateScheduleGroupCall(event.scheduleNewRequestModel,event.freelancers,event.userName);
      yield CreatedGroupScheduledState(isCreated: isUpdatedFlag);
    }
    if(event is UpdateScheduleEvent){
      yield LoadingScheduleState();
      bool isUpdatedFlag=await updateScheduleCall(event.scheduleRequest,event.scheduleUpdateRequest);
      yield UpdatedScheduledState(isUpdated: isUpdatedFlag);
    }
    if(event is UpdateDurationInCreatingScheduledCallEvent){
      duration=event.duration;
      yield UpdatedDurationForScheduledCallState(duration: duration);
    }
    if(event is CreateCallEvent){
      yield LoadingScheduleState();
      createCall(event.callModel);
      yield CreateCallState();
    }
  }

  Future<bool> createOrUpdateScheduledCall(ScheduleRequest bidModel)async{
    bool isScheduleCreated=await this.scheduleRepository.createSchedule(bidModel);
    if(!isScheduleCreated){
      return false;
    }
    try {
      DateTime scheduledDateTime = DateTime.parse(bidModel.callScheduled);
      String scheduledDateInMessage = scheduledDateTime.day.toString() + "th " +
          scheduledDateTime.year.toString().substring(2);
      String formattedTime = DateFormat.jm().format(DateTime.now());
      NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
          "notification",
          NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
              "Call Notification",
              "${bidModel
                  .userName} has scheduled a call with you on ${scheduledDateInMessage} at ${formattedTime}"
          ),data: new NotificationMessageDataPayload(
              "",
              bidModel.freelancerId,
              "schedule","freelancer",bidModel.userId
          )),


      );
      this.notificationRepository.sendNotification(notificationMessage);
      DocumentSnapshot snapshot=await this.loginRepository.getUserByUid(bidModel.freelancerId);
      UserDTOModel freelancerDTOModel=UserDTOModel.fromJson(snapshot.data() as Map<String,dynamic>, snapshot.id);
      NotificationMessage notificationMessageEmailPayload = new NotificationMessage(
        type:"mail",
          payload: NotificationMessageEmailPayload(
              freelancerDTOModel.personalDetails.email,
              "Schedule Call Created",
              "${bidModel
                  .userName} has scheduled a call with you on ${scheduledDateInMessage} at ${formattedTime}"
          ));

      this.notificationRepository.sendNotification(notificationMessageEmailPayload);
      return true;
    }catch(e){
      return false;
    }

  }

  Future<bool> createOrUpdateScheduleGroupCall(ScheduleNewRequestModel scheduleNewRequestModel,
      List<String> freelanceIds,String userName)async{
    bool isScheduleCreated=await this.scheduleRepository.createGroupSchedule(scheduleNewRequestModel);
    try {
      DateTime scheduledDateTime = DateTime.parse(scheduleNewRequestModel.schedule.callScheduled);
      String scheduledDateInMessage = scheduledDateTime.day.toString() + "th " +
          scheduledDateTime.year.toString().substring(2);
      String formattedTime = DateFormat.jm().format(DateTime.now());
      for(int i=0;i<freelanceIds.length;i++){
        NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
            "notification",
            NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
                "Call Notification",
                "${userName} has scheduled a call with you on ${scheduledDateInMessage} at ${formattedTime}"
            ),data: new NotificationMessageDataPayload(
                "",
                freelanceIds[i],
                "schedule","freelancer",scheduleNewRequestModel.schedule.userId
            )),


        );
        this.notificationRepository.sendNotification(notificationMessage);

        DocumentSnapshot snapshot=await this.loginRepository.getUserByUid(freelanceIds[i]);
        UserDTOModel freelancerDTOModel=UserDTOModel.fromJson(snapshot.data() as Map<String,dynamic>, snapshot.id);
        NotificationMessage notificationMessageEmailPayload = new NotificationMessage(
            type:"mail",
            payload: NotificationMessageEmailPayload(
                freelancerDTOModel.personalDetails.email,
                "Schedule Call Created",
                "${userName} has scheduled a call with you on ${scheduledDateInMessage} at ${formattedTime}"
            ));

        this.notificationRepository.sendNotification(notificationMessageEmailPayload);
      }


      return true;
    }catch(e){
      return false;
    }

  }

  Future<bool> updateScheduleCall(ScheduleRequest scheduleRequest,
      ScheduleUpdateRequest scheduleUpdateRequest)async{
    bool isScheduleUpdated=await this.scheduleRepository.updateSchedule(scheduleUpdateRequest);
    NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
        "notification",
        NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
            "Call Notification",
            "${scheduleRequest
                .freelancerName} ${scheduleUpdateRequest.status} your schedule"
        ),data: new NotificationMessageDataPayload(
            "",
            scheduleRequest.userId,
            "schedule","user",scheduleRequest.freelancerId
        )),

    );
      DocumentSnapshot snapshot=await this.loginRepository.getUserByUid(scheduleRequest.userId);
      UserDTOModel userDTOModel=UserDTOModel.fromJson(snapshot.data() as Map<String,dynamic>, snapshot.id);
      NotificationMessage notificationMessageEmailPayload = new NotificationMessage(
          type:"mail",
          payload: NotificationMessageEmailPayload(
              userDTOModel.personalDetails.email,
              "Schedule Call Updated",
              "${scheduleRequest
                  .freelancerName} ${scheduleUpdateRequest.status} your schedule"
          ));
      await this.notificationRepository.sendNotification(notificationMessage);
      await this.notificationRepository.sendNotification(notificationMessageEmailPayload);

    return isScheduleUpdated;
  }

  Future<DocumentSnapshot> getScheduledGroupCallStatus(String groupId,String scheduleId){
    return this.scheduleRepository.getGroupScheduledCallStatus(groupId, scheduleId);
  }

  Future<DocumentSnapshot> getBid(String scheduleId,String userId){
    return this.scheduleRepository.getScheduledCallInfo(scheduleId,userId);
  }

  Future<DocumentSnapshot> getCall(String callId,String userId){
    return this.scheduleRepository.getCallInfo(callId,userId);
  }

  void createCall(CallModel callModel){
    //this.scheduleRepository.createCall(callModel);
  }

  Future<void> close() async {
    print("Bloc closed");
    _queryController.close();
    super.close();
  }

}
