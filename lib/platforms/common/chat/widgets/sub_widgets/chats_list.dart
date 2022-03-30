import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_event.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_state.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/no_data_found/no_data_found.dart';

class ChatsListWidget extends StatelessWidget{
  final String chatUserId;
  ChatsListWidget({this.chatUserId=""});
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChatBloc>(context).add(FetchMessagesEvent(userId: getUserDTOModelObject(context).userId,chatUserId: chatUserId));
    return BlocBuilder<ChatBloc,ChatState>(
      builder: (context,state){
        if(state is FetchMessagesState){
          if(state.messages.isEmpty){
            return NoDataFound(message: "No Messages Found",);
          }
          return ListView.builder(itemCount:state.messages.length,itemBuilder: (context,int index){
            ChatMessageModel model=state.messages[index];
            DateTime dateTime = DateTime.parse(
                model.createdAt);
            String date = dateTime.day.toString() +
                "-" +
                Constants.months[dateTime.month]! +
                "-" +
                dateTime.year.toString();
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                width: MediaQuery.of(context).size.width*0.5,
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(5.0)
                ),
                child: Center(child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: model.senderID==BlocProvider.of<LoginBloc>(context).userDTOModel.userId ?
                      MainAxisAlignment.end:MainAxisAlignment.start,
                      children: [
                        Text(model.message),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(date)
                      ],
                    )
                  ],
                ),),
              ),
            );
          });
        }
        else{
          return Center(child: Text("Loading"),);
        }
      },
    );
  }
}