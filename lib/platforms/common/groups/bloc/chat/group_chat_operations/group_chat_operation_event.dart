import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/groups/model/chat/group_chat_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_model.dart';
import 'package:flutter_eb/platforms/common/groups/model/group_freelancer_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';

class GroupChatOperationEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddChatToGroupEvent extends GroupChatOperationEvent{
  final GroupChatModel groupChatModel;
  final String groupId;
  AddChatToGroupEvent({required this.groupId,required this.groupChatModel});
}