import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/model/chat/group_chat_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

class SendChatMessageWidget extends StatefulWidget {
  final Function callbck;
  final String type;
  SendChatMessageWidget({required this.type,required this.callbck});
  SendChatMessageWidgetState createState()=>SendChatMessageWidgetState();
}
class SendChatMessageWidgetState extends State<SendChatMessageWidget>{
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
            if(_chatMessageController.text!="") {
              UserDTOModel userModel = BlocProvider
                  .of<LoginBloc>(context)
                  .userDTOModel;
              if (widget.type == "group") {
                GroupChatModel chat = new GroupChatModel(
                    userID: userModel.userId,
                    senderName: userModel.personalDetails.displayName,
                    createdAt: DateTime.now().toIso8601String(),
                    message: _chatMessageController.text
                );
                widget.callbck(chat);
              }
            }

          },color: Colors.blue,textColor: Colors.white,child: Center(child: Icon(Icons.send),),)
        ],
      ),
    );
  }
}