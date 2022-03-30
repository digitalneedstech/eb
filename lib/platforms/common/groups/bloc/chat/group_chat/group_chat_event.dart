import 'package:equatable/equatable.dart';

class GroupChatEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class FetchChatsFromGroupEvent extends GroupChatEvent{
  final String groupId;
  FetchChatsFromGroupEvent({required this.groupId});
}