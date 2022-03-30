import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_event.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_state.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/chat/widgets/sub_widgets/chats_list.dart';
import 'package:flutter_eb/platforms/common/chat/widgets/sub_widgets/send_message_text.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class SingleChat extends StatelessWidget{
  final String otherUserName;
  final chatUserId;
  SingleChat({this.otherUserName="",required this.chatUserId});
  @override
  Widget build(BuildContext context) {
    //BlocProvider.of<ChatBloc>(context).add(FetchMessagesEvent(chatUserId: chatUserId));
    return BlocListener<ChatBloc,ChatState>(
      listener: (context,state){
        if(state is SendMessageState){
          BlocProvider.of<ChatBloc>(context).add(FetchMessagesEvent(chatUserId: chatUserId,userId: BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(otherUserName),
        ),
        bottomNavigationBar: FutureBuilder<DocumentSnapshot>(
          future: BlocProvider.of<LoginBloc>(context).loginRepository.getUserByUid(chatUserId),
          builder: (context,AsyncSnapshot<DocumentSnapshot> snapshot){
            switch(snapshot.connectionState){
              case ConnectionState.none:
              case ConnectionState.waiting:
                return Center(child: Text("Loading"),);
              case ConnectionState.done:
              case ConnectionState.active:
                if(snapshot.hasData) {
                  UserDTOModel chatModel=UserDTOModel.fromJson(snapshot.data!.data() as Map<String,dynamic>,
                   snapshot.data!.id);
                  return SendMessageWidget(
                    callbck: (UserDTOModel userModel,
                        ChatMessageModel messageModel) {
                      BlocProvider.of<ChatBloc>(context).add(SendMessageEvent(
                          userMessageModel: messageModel,
                          chatUserMessageModel: messageModel,
                          userId: userModel.userId,
                          chatUserId: chatUserId));
                    },
                    chatUserId: chatUserId, chatUserModel: chatModel,);
                }
                else{
                  return Center(child: Text("There was some error"),);
                }
            }
          }
        ),
        body: ChatsListWidget(chatUserId: chatUserId),
      ),
    );
  }
}