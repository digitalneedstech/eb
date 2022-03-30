import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_message.dart';

class SendMessageWidget extends StatefulWidget {
  final UserDTOModel chatUserModel;
  final bool isSchedulingChat;
  final String chatUserId,scheduleId;
  final Function callbck;
  SendMessageWidget({this.scheduleId="",
    this.isSchedulingChat=false,this.chatUserId="",required this.chatUserModel,
    required this.callbck});
  SendMessageWidgetState createState()=>SendMessageWidgetState();
}
class SendMessageWidgetState extends State<SendMessageWidget>{
  TextEditingController _chatMessageController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: MediaQuery.of(context).size.height*0.1,
      decoration: BoxDecoration(
          color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child:TextFormField(
            controller: _chatMessageController,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10.0),
                borderSide: BorderSide(color: Colors.grey.shade400),
              ),
              labelText: "Please Enter The Message"
            ),
          )),
          SizedBox(width: 10.0,),
          RaisedButton(onPressed: (){
            UserDTOModel userModel=BlocProvider.of<LoginBloc>(context).userDTOModel;
            if(!widget.isSchedulingChat) {
              ChatMessageModel userMessageModel = new ChatMessageModel(
                  receiverID: widget.chatUserId,
                  receiverName: widget.chatUserModel.personalDetails.displayName,
                  receiverPic: widget.chatUserModel.personalDetails.profilePic,
                  senderID: userModel.userId,
                  senderName: userModel.personalDetails.displayName,
                  senderPic: userModel.personalDetails.profilePic,
                  message: _chatMessageController.text,
                createdAt:DateTime.now().toIso8601String()
              );
              widget.callbck(userModel,userMessageModel);
            }
            else{
              ScheduleMessage message=ScheduleMessage(id:widget.scheduleId,message:_chatMessageController.text);
              widget.callbck(message);
            }

          },color: Colors.blue,textColor: Colors.white,child: Center(child: Icon(Icons.send),),)
        ],
      ),
    );
  }
}

class SendMessageForScheduleChatWidget extends StatefulWidget {
  final bool isSchedulingChat;
  final String chatUserId,scheduleId;
  final Function callbck;
  SendMessageForScheduleChatWidget({this.scheduleId="",
    this.isSchedulingChat=false,this.chatUserId="",
    required this.callbck});
  SendMessageForScheduleChatWidgetState createState()=>SendMessageForScheduleChatWidgetState();
}
class SendMessageForScheduleChatWidgetState extends State<SendMessageForScheduleChatWidget>{
  TextEditingController _chatMessageController= TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10.0),
      height: MediaQuery.of(context).size.height*0.1,
      decoration: BoxDecoration(
          color: Colors.white
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child:TextFormField(
            controller: _chatMessageController,
            decoration: InputDecoration(
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                  borderSide: BorderSide(color: Colors.grey.shade400),
                ),
                labelText: "Please Enter The Message"
            ),
          )),
          SizedBox(width: 10.0,),
          RaisedButton(onPressed: (){
            UserDTOModel userModel=BlocProvider.of<LoginBloc>(context).userDTOModel;
            ScheduleMessage message=ScheduleMessage(id:widget.scheduleId,message:_chatMessageController.text);
              widget.callbck(message);

          },color: Colors.blue,textColor: Colors.white,child: Center(child: Icon(Icons.send),),)
        ],
      ),
    );
  }
}