import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat/group_chat_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat/group_chat_state.dart';
import 'package:flutter_eb/platforms/common/groups/model/chat/group_chat_model.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
class GroupChatBloc extends Bloc<GroupChatEvent, GroupChatState> {
  final GroupRepository groupRepository;
  GroupChatBloc(this.groupRepository) : super(GroupChatLoadedState());

  @override
  Stream<GroupChatState> mapEventToState(
      GroupChatEvent event,
      ) async* {
    if(event is FetchChatsFromGroupEvent){
      yield FetchChatsFromGroupInProgressState();
      List<GroupChatModel> chats=[];
      try {
        QuerySnapshot snapshot=await groupRepository.getChatMessages(event.groupId);
        for(DocumentSnapshot documentSnapshot in snapshot.docs){
          chats.add(GroupChatModel.fromMap(documentSnapshot.data() as Map<String,dynamic>));
        }
      }catch(e){
        yield FetchChatsFromGroupState(chats: chats);
      }
      yield FetchChatsFromGroupState(chats: chats);
    }
  }
  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
