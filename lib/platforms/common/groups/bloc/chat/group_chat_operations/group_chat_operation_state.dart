import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';

@immutable
abstract class GroupChatOperationState extends Equatable {}

class GroupChatOperationLoadedState extends GroupChatOperationState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddChatToGroupInProgressState extends GroupChatOperationState{
  @override
  // TODO: implement props
  List<Object> get props => [];
}

class AddChatToGroupState extends GroupChatOperationState{
  final bool isAdded;
  AddChatToGroupState({required this.isAdded});
  @override
  // TODO: implement props
  List<Object> get props => [];
}