
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat_operations/group_chat_operation_event.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat_operations/group_chat_operation_state.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
class GroupChatOperationBloc extends Bloc<GroupChatOperationEvent, GroupChatOperationState> {
  final GroupRepository groupRepository;
  GroupChatOperationBloc(this.groupRepository) : super(GroupChatOperationLoadedState());

  @override
  Stream<GroupChatOperationState> mapEventToState(
      GroupChatOperationEvent event,
      ) async* {
    if(event is AddChatToGroupEvent){
      yield AddChatToGroupInProgressState();
      try {
        groupRepository.addChatMessageInGroup(
            event.groupId, event.groupChatModel);
      }catch(e){
        yield AddChatToGroupState(isAdded: false);
      }
      yield AddChatToGroupState(isAdded: true);
    }
  }
  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
