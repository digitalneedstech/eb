import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat/group_chat_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat/group_chat_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat/group_chat_state.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat_operations/group_chat_operation_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat_operations/group_chat_operation_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat_operations/group_chat_operation_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/chat/group_chat_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/widgets/chat/chat_message_widget/chat_message.dart';
import 'package:flutter_eb/shared/widgets/chat/send_chat_message/send_chat_message.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class GroupChatList extends StatelessWidget{
  final String groupId;
  final Function callback;
  GroupChatList({required this.callback,required this.groupId});
  @override
  Widget build(BuildContext context) {

    BlocProvider.of<GroupChatBloc>(context).add(FetchChatsFromGroupEvent(groupId: groupId));
    return BlocListener<GroupChatOperationBloc,GroupChatOperationState>(
      listener: (context,state){
        if(state is AddChatToGroupState){
          BlocProvider.of<GroupChatBloc>(context).add(FetchChatsFromGroupEvent(groupId: groupId));
          callback(state.isAdded);
        }
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 10.0),
        padding: const EdgeInsets.all(10.0),
        color: Colors.white,
        height: MediaQuery.of(context).size.height*0.3,
        child: Column(
          children:[Expanded(
            child: BlocBuilder<GroupChatBloc,GroupChatState>(
              builder: (context,state){
                if(state is FetchChatsFromGroupState){
                  List<GroupChatModel> chats=state.chats;
                  if(chats.isEmpty)
                    return NoDataFound();
                  return ListView.builder(itemBuilder: (context,int index){

                    return ChatMessage(
                      mainAxisAlignment: chats[index].userID==BlocProvider.of<LoginBloc>(context).userDTOModel.userId?
                      MainAxisAlignment.end:MainAxisAlignment.start,
                      message: chats[index].message,
                    );
                  },physics: BouncingScrollPhysics(),itemCount: chats.length,shrinkWrap: true,);
                }
                if(state is FetchChatsFromGroupInProgressState){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return Container();
              }
            ),
          ),
            SendChatMessageWidget(type: "group",callbck: (GroupChatModel groupChatModel){
              BlocProvider.of<GroupChatOperationBloc>(context).add(AddChatToGroupEvent(groupId: groupId,
              groupChatModel: groupChatModel));
            },)
          ]
        ),
      ),
    );
  }
}