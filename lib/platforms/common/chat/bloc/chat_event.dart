import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class ChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}
class CreateChatEvent extends ChatEvent{
  final ChatModel chatUser,chatReceiver;
  final String creatorId,receiverId;
  CreateChatEvent({required this.chatUser,
    required this.chatReceiver,required this.creatorId,required this.receiverId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchChatsEvent extends ChatEvent{
  final String userId;
  FetchChatsEvent({required this.userId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchChatEvent extends ChatEvent{
  final String userId,chatId;
  FetchChatEvent({required this.userId,required this.chatId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}



class FetchMessagesEvent extends ChatEvent{
  final String chatUserId,userId;
  FetchMessagesEvent({required this.chatUserId,required this.userId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class SendMessageEvent extends ChatEvent{
  final ChatMessageModel userMessageModel,chatUserMessageModel;
  final String chatUserId,userId;
  SendMessageEvent({required this.userMessageModel,
    required this.chatUserMessageModel,required this.chatUserId,required this.userId});
  @override
  // TODO: implement props
  List<Object> get props => [];
}



