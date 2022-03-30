import 'package:date_format/date_format.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_event.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_state.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/shared/utils/util_functions.dart';
import 'package:flutter_eb/shared/widgets/eb_circle_avatar/eb_circle_avatar.dart';
import 'package:flutter_eb/shared/widgets/eb_web_app_bar/eb_web_appbar.dart';
import './widgets/single_chat.dart';
class ChatsListPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    BlocProvider.of<ChatBloc>(context).add(FetchChatsEvent(userId:
    BlocProvider.of<LoginBloc>(context).userDTOModel.userId));
    return Scaffold(
      appBar: getScreenWidth(context)>800 ?PreferredSize(
          preferredSize: Size.fromHeight(50.0), // here the desired height
          child: EbWebAppBarWidget()
      ): AppBar(
        title: Text("Chats"),
      ),
      body: BlocBuilder<ChatBloc,ChatState>(
        builder: (context,state){
          if(state is FetchChatsState){
            return state.chatModel.isEmpty ?Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("No Chats Found")
                ],
              ),
            ):
            Container(
              width: MediaQuery.of(context).size.width*0.6,
              child: ListView.builder(itemCount: state.chatModel.length,itemBuilder: (context,int index){
                UserDTOModel model=state.chatModel[index];
                return ListTile(
                  onTap: (){
                    if(kIsWeb){
                      Navigator.pushNamed(context, "chat/"+model.userId+"/"+model.personalDetails.displayName);
                    }else {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) =>
                            SingleChat(
                              otherUserName: model.personalDetails.displayName,
                              chatUserId:
                              model.userId,
                            )),
                      );
                    }
                  },
                  leading: EbCircleAvatarWidget(profileImageUrl:
                  model.personalDetails.profilePic),
                  title: Text(model.personalDetails.displayName)
                );
              }),
            );
          }
          else{
            return Center(child: Text("Loading.."),);
          }
        },
      ),
    );
  }
}