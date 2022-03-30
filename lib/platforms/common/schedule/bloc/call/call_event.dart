
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_update_request_model.dart';

class CallEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SendScheduleMessageEvent extends CallEvent {
  final ScheduleMessage chatMessageModel;
  final String userId,chatUserId;

  SendScheduleMessageEvent(
      {required this.chatMessageModel, required this.userId,required this.chatUserId});

}
class FetchScheduleMessagesEvent extends CallEvent{
  final String scheduleId,userId;
  FetchScheduleMessagesEvent({required this.userId,required this.scheduleId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CreateCallEvent extends CallEvent{
  final CallModel callModel;
  CreateCallEvent({required this.callModel});
}


class GetAgoraTokenAndMapAgoraVideoEvent extends CallEvent{
  final CallModel callModel;
  final String groupId;
  GetAgoraTokenAndMapAgoraVideoEvent({required this.groupId,required this.callModel});
}

class GetAgoraCallModel extends CallEvent{
  final dynamic scheduleRequest;
  final dynamic callModel;
  final String groupId;
  final String userId;
  GetAgoraCallModel({required this.groupId,required this.userId,this.scheduleRequest,this.callModel});
}



class LogUserVideoCallingTime extends CallEvent{
  final bool isUser,isForGroup;
  final String dateTime,typeOfLogging,groupId,userId;
  final int uId;
  final CallModel callModel;
  LogUserVideoCallingTime({required this.isUser,
    required this.groupId,required this.userId,required this.uId,required this.isForGroup,required this.callModel,required
    this.dateTime,required this.typeOfLogging});
}
