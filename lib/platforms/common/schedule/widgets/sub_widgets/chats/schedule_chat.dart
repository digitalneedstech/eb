import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_event.dart';
import 'package:flutter_eb/platforms/common/chat/widgets/sub_widgets/send_message_text.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_event.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_state.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_message.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_request.dart';
import 'package:flutter_eb/shared/widgets/chat/chat_message_widget/chat_message.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class ScheduleChat extends StatelessWidget {
  final String chatUserId;
  final ScheduleRequest scheduleRequest;
  final bool isSchedulingChatByFreelancer;
  ScheduleChat(
      {required this.chatUserId,
      required this.scheduleRequest,
      this.isSchedulingChatByFreelancer = false});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<CallBloc>(context).add(FetchScheduleMessagesEvent(
        userId: scheduleRequest.userId, scheduleId: scheduleRequest.id));
    return BlocListener<CallBloc,CallState>(
      listener: (context,state){
        if (state is SendScheduleMessageState) {
          if(state.isSent)
            BlocProvider.of<CallBloc>(context).add(FetchScheduleMessagesEvent(
                userId: scheduleRequest.userId, scheduleId: scheduleRequest.id));
        }
      },
      child: Container(
        height: MediaQuery.of(context).size.height * 0.4,
        padding: const EdgeInsets.all(10.0),
        margin: const EdgeInsets.all(20.0),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(10.0)),
        child: Column(
          children: [
            Expanded(child: BlocBuilder<CallBloc,CallState>(
                builder: (context,state){
                  if(state is FetchScheduleMessagesState){
                    if(state.chats.isEmpty){
                      return NoDataFound();
                    }
                    else{

                      return ListView.builder(itemBuilder: (context,int index){
                        ScheduleMessage model=state.chats[index];
                        return ChatMessage(
                          mainAxisAlignment: model.userId==BlocProvider.of<LoginBloc>(context).userDTOModel.userId?
                          MainAxisAlignment.end:MainAxisAlignment.start,
                          message: model.message,
                        );
                      },itemCount: state.chats.length,shrinkWrap: true,);
                    }
                  }
                  else if(state is LoadingCallState){
                    return Center(child: Text("Loading"),);
                  }
                  return Container();
                }
            )),
            SendMessageForScheduleChatWidget(
              //TODO-
                chatUserId: chatUserId,

                scheduleId: scheduleRequest.id,
                callbck: (ScheduleMessage message) {
                  if (isSchedulingChatByFreelancer) {
                    message.freelancerId = scheduleRequest.freelancerId;
                  } else {
                    message.userId = scheduleRequest.userId;
                  }
                  BlocProvider.of<CallBloc>(context).add(
                      SendScheduleMessageEvent(
                          userId: scheduleRequest.userId,
                          chatUserId: scheduleRequest.freelancerId,
                          chatMessageModel: message));
                },
                isSchedulingChat: true)
          ],
        ),
      ),
    );
  }
}
