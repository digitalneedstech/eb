import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_message.dart';

@immutable
abstract class CallState extends Equatable {}


class CallLoadedState extends CallState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}
class LoadingCallState extends CallState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();

}
class SendScheduleMessageState extends CallState {
  final bool isSent;

  SendScheduleMessageState(
      {required this.isSent});

  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchScheduleMessagesState extends CallState{
  final List<ScheduleMessage> chats;
  FetchScheduleMessagesState({required this.chats});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class CreateCallState extends CallState{
  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}


class GetAgoraAndInitiateAgoraCall extends CallState{
  final CallModel callModel;
  GetAgoraAndInitiateAgoraCall({required this.callModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class GetAgoraCallModelState extends CallState{
  final CallModel callModel;
  GetAgoraCallModelState({required this.callModel});

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class LoadingInitiateState extends CallState {
  @override
  List<Object> get props => [];
}


class LogUserVideoCallingTimeState extends CallState{
  LogUserVideoCallingTimeState();

  @override
  // TODO: implement props
  List<Object> get props => [];
}