import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/chat/group_chat_model.dart';

@immutable
abstract class GroupChatState extends Equatable {}

class GroupChatLoadedState extends GroupChatState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}
class FetchChatsFromGroupInProgressState extends GroupChatState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class FetchChatsFromGroupState extends GroupChatState{
  final List<GroupChatModel> chats;
  FetchChatsFromGroupState({required this.chats});
  @override
  // TODO: implement props
  List<Object> get props => [];
}