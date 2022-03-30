import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

@immutable
abstract class ChatState extends Equatable {}

class ChatLoadedState extends ChatState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class CreateChatState extends ChatState{
  final ChatModel chatModel;
  CreateChatState({required this.chatModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class FetchChatsState extends ChatState{
  List<UserDTOModel> chatModel;
  FetchChatsState({required this.chatModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}


class FetchChatState extends ChatState{
  ChatModel chatModel;
  FetchChatState({required this.chatModel});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchMessagesState extends ChatState{
  final List<ChatMessageModel> messages;
  FetchMessagesState({required this.messages});
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class SendMessageState extends ChatState {
  final bool isAdded;
  SendMessageState({required this.isAdded});
  @override
  List<Object> get props => [];
}

class LoadingChatState extends ChatState {
  @override
  List<Object> get props => [];
}
