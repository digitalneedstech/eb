import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_event.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_state.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';
import 'package:flutter_eb/platforms/common/chat/repo/chat_repository.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  final ChatRepository chatRepository;
  final LoginRepository loginRepository;
  ChatBloc(this.chatRepository,this.loginRepository) : super(ChatLoadedState());

  /*StreamController<ChatMessageModel> _queryController =
  StreamController.broadcast();
  Stream<ChatMessageModel> get queryStream => _queryController.stream;*/
  List<ChatMessageModel> _chatMessagesModel=[];

  List<ChatMessageModel> get chatMessagesModel => _chatMessagesModel;

  set chatMessagesModel(List<ChatMessageModel> value) {
    _chatMessagesModel = value;
  }

  @override
  Stream<ChatState> mapEventToState(
    ChatEvent event,
  ) async* {
    if (event is CreateChatEvent) {
      yield LoadingChatState();
      try {
        createChat(event.chatUser, event.chatReceiver, event.creatorId,
            event.receiverId);
        yield CreateChatState(chatModel: event.chatUser);
      } catch (e) {
        yield CreateChatState(chatModel: ChatModel(id: ""));
      }
    }

    if (event is SendMessageEvent) {
      yield LoadingChatState();
      try {
        chatMessagesModel.add(event.userMessageModel);
        await sendMessage(event.userMessageModel, event.chatUserMessageModel, event.userId,
            event.chatUserId);
        yield SendMessageState(isAdded: true);
      } catch (e) {
        yield SendMessageState(isAdded:false);
      }
    }

    if (event is FetchChatsEvent) {
      yield LoadingChatState();
      QuerySnapshot chatsReceived = await fetchAllChats(event.userId);
      List<UserDTOModel> chats = [];
      if (chatsReceived.docs.isEmpty)
        yield FetchChatsState(chatModel: chats);
      else {
        for (DocumentSnapshot document in chatsReceived.docs) {
          DocumentSnapshot userSnapshot=await loginRepository.getUserByUid(document.id);
          chats.add(UserDTOModel.fromJson(userSnapshot.data() as Map<String,dynamic>, userSnapshot.id));
        }
        yield FetchChatsState(chatModel: chats);
      }
    }

    if (event is FetchChatEvent) {
      yield LoadingChatState();
      DocumentSnapshot chatsReceived = await fetchChatById(event.userId,event.chatId);
      if(chatsReceived.exists) {
        yield FetchChatState(chatModel: ChatModel.fromJson(
            chatsReceived.data() as Map<String, dynamic>, chatsReceived.id));
      }
      else{
        yield FetchChatState(chatModel: ChatModel());
      }
    }

    if (event is FetchMessagesEvent) {
      yield LoadingChatState();
      QuerySnapshot chatsReceived =
          await fetchAllMessages(event.userId, event.chatUserId);
      List<ChatMessageModel> chatMessages = [];
      if (chatsReceived.docs.isEmpty)
        yield FetchMessagesState(messages: []);
      else {
        for (DocumentSnapshot document in chatsReceived.docs) {
          chatMessages.add(
              ChatMessageModel.fromJson(document.data() as Map<String,dynamic>));
        }
        chatMessagesModel=chatMessages;
        yield FetchMessagesState(messages: chatMessages);
      }
    }
  }

  void createChat(ChatModel userModel, ChatModel receiverModel, String userId,
      String receiverId) {
    this
        .chatRepository
        .createNewChat(userModel, receiverModel, userId, receiverId);
  }

  Future<void> sendMessage(ChatMessageModel userModel, ChatMessageModel receiverModel, String userId,
      String chatUserId)async {
    DocumentReference ref=await this
        .chatRepository
        .sendMessage(userId, chatUserId, userModel, receiverModel);
  }

  Future<QuerySnapshot> fetchAllChats(String userId) {
    return this.chatRepository.fetchAllChats(userId);
  }

  Future<DocumentSnapshot> fetchChatById(String userId,String chatId) {
    return this.chatRepository.fetchChatById(userId,chatId);
  }

  Future<QuerySnapshot> fetchAllMessages(String userId, String chatUserId) {
    return this.chatRepository.fetchAllMessages(userId, chatUserId);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
