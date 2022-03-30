
import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_state.dart';
import 'package:flutter_eb/platforms/common/schedule/data/schedule_repository.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class CallBloc extends Bloc<CallEvent, CallState> {
  final ScheduleRepository scheduleRepository;
  final NotificationRepository notificationRepository;
  final GroupRepository groupRepository;
  final LoginRepository loginRepository;
  CallBloc(this.scheduleRepository,this.notificationRepository,this.groupRepository
      ,this.loginRepository) : super(CallLoadedState());

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
  Stream<CallState> mapEventToState(
      CallEvent event,
      ) async* {

    if(event is SendScheduleMessageEvent){
      yield LoadingCallState();
      addChatMessage(event.userId,event.chatUserId,event.chatMessageModel);

      _queryController.add([event.chatMessageModel]);
      yield SendScheduleMessageState(isSent: true);
    }

    if(event is FetchScheduleMessagesEvent){
      yield LoadingCallState();
      List<ScheduleMessage> chats=[];
      QuerySnapshot snapshot=await getChatMessages(event.scheduleId,event.userId);

      for(DocumentSnapshot documentSnapshot in snapshot.docs){
        ScheduleMessage message=ScheduleMessage.fromJson(documentSnapshot.data() as Map<String,dynamic>);
        chats.add(message);
        _queryController.add([message]);
      }
      yield FetchScheduleMessagesState(chats: chats);
    }

    if(event is GetAgoraTokenAndMapAgoraVideoEvent){
      yield LoadingInitiateState();
      CallModel callModel;
      try {
        if(event.groupId=="") {
          callModel = await getAgoraTokenAndStartCallForSingleFreelancer(event.callModel);
        }
        else {
          callModel = await getAgoraTokenAndStartCallForAGroup(
              event.groupId, event.callModel);
        }
        yield GetAgoraAndInitiateAgoraCall(callModel: callModel);
      }catch(e){
        yield GetAgoraAndInitiateAgoraCall(callModel: CallModel(scheduleId: "",id: ""));
      }
    }

    if(event is GetAgoraCallModel){
      yield LoadingInitiateState();
      CallModel callModel;
      if(event.groupId=="")
        callModel=await getCallModelFromScheduleRequest(event.scheduleRequest);
      else
        callModel=await getCallModelFromScheduleRequestForAGroupCall(event.groupId,
            event.scheduleRequest);
      yield GetAgoraCallModelState(callModel: callModel);
    }

    if(event is LogUserVideoCallingTime){
      if(event.typeOfLogging=="start"){
        //logJoiningTime(event.isUser,event.isForGroup, event.dateTime, event.callModel,event.groupId,event.userId,event.uId);
      }

      else {
        logEndingTime(
            event.isUser,
            event.isForGroup,
            event.dateTime,
            event.callModel,
            event.groupId,
            event.userId,
            event.uId);
        if(event.isUser) {
          DocumentSnapshot documentSnapshot=await this.loginRepository.getUserByUid(event.callModel.userId);
          if(documentSnapshot.exists){
            UserDTOModel userDTOModel=UserDTOModel.fromJson(documentSnapshot.data() as Map<String,dynamic>,
                documentSnapshot.id);
            userDTOModel.isTerminated=true;
            loginRepository.updateUser(userDTOModel);
          }
          for(String receiverId in event.callModel.receiverId) {
            DocumentSnapshot documentSnapshotForFreelancer = await this
                .loginRepository
                .getUserByUid(receiverId);
            if (documentSnapshotForFreelancer.exists) {
              UserDTOModel freelancerDTOModel = UserDTOModel.fromJson(
                  documentSnapshotForFreelancer.data() as Map<String, dynamic>,
                  documentSnapshotForFreelancer.id);
              freelancerDTOModel.isTerminated = true;
              loginRepository.updateUser(freelancerDTOModel);
            }
          }
        }
      }
      yield LogUserVideoCallingTimeState();
    }

  }

  Future<QuerySnapshot> getChatMessages(String scheduleId,String userId)async{
    return await this.scheduleRepository.getChatMessages(userId,scheduleId);
  }

  void addChatMessage(String userId,String chatUserId, ScheduleMessage chatMessageModel){
    this.scheduleRepository.sendMessage(userId,chatUserId, chatMessageModel);
  }

  Future<CallModel> getAgoraTokenAndStartCallForSingleFreelancer(CallModel callModel)async{
    CallModel expectedCallModel=await this.scheduleRepository.getTokenAndUpdateCall(callModel);
    for(String receiverId in expectedCallModel.receiverId) {
      NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
          "notification",
          NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
              "Call Notification",
              "${callModel.userName} is making you the call, Accept It."
          ),data: new NotificationMessageDataPayload(
              expectedCallModel.id,
              receiverId,
              "call", "freelancer",expectedCallModel.userId
          )),

      );
      this.notificationRepository.sendNotification(notificationMessage);
    }

    return expectedCallModel;
  }

  Future<CallModel> getAgoraTokenAndStartCallForAGroup(String groupId,CallModel callModel)async{
    CallModel expectedCallModel=await this.scheduleRepository.getTokenAndUpdateCallForGroup(groupId,callModel);
    DocumentSnapshot scheduleRequestSnapshot=await groupRepository.getScheduledCallById(groupId, callModel.scheduleId);
    ScheduleNewRequest scheduleNewRequest=ScheduleNewRequest.fromMap(scheduleRequestSnapshot.data() as Map<String,dynamic>);
    for(String freelancerId in scheduleNewRequest.freelancers.map((e) => e.id).toList()) {
      NotificationMessageNotificationModel notificationMessage=NotificationMessageNotificationModel(
          "notification",
          NotificationMessageNotificationPayloadModel(notification: NotificationMessageNotificationPayload(
              "Call Notification",
              "${callModel.userName} is making you the call, Accept It."
          ),data: new NotificationMessageDataPayload(
              expectedCallModel.id,
              freelancerId,
              "call","freelancer",expectedCallModel.userId
          )),

      );
      this.notificationRepository.sendNotification(
          notificationMessage);
    }
    /*NotificationMessage notificationMessageNotificationPayload = new NotificationMessage(
        type:"notification",
        payload: NotificationMessagePayload(
            callModel.receiverId,
            "${callModel.userName} is making you the call, Accept It."
        ));
    this.notificationRepository.sendNotification(notificationMessageNotificationPayload);*/
    //TODO-Add notification for all users
    return expectedCallModel;
  }

  Future<CallModel> getCallModelFromScheduleRequest(ScheduleRequest scheduleRequest)async{
    CallModel callModel= await this.scheduleRepository.getCallModelFromScheduleRequest(scheduleRequest);
    return callModel;
  }

  Future<CallModel> getCallModelFromScheduleRequestForAGroupCall(String groupId,
      ScheduleNewRequestModel scheduleNewRequestModel){
    return this.scheduleRepository.getCallModelFromSchduleGroupRequest(groupId,scheduleNewRequestModel);
  }
/*

  void logJoiningTime(bool isUser,bool isForGroup,String dateTime,CallModel callModel,
      String groupId,String userId,int uId){
    this.scheduleRepository.addUserJoiningTime(isUser,isForGroup, dateTime, callModel,groupId,
        userId,uId);
  }
*/

  void logEndingTime(bool isUser,bool isForGroup,String dateTime,CallModel callModel,
      String groupId,String userId,int uId){
    this.scheduleRepository.userloggingOffTime(isUser,isForGroup, dateTime, callModel,groupId,
        userId,uId);
  }

  Future<void> close() async {
    print("Bloc closed");
    _queryController.close();
    super.close();
  }

}
