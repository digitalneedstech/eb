import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat.dart';
import 'package:flutter_eb/platforms/common/chat/model/chat_message.dart';

class ChatRepository {
  final userCollectionInstance = FirebaseFirestore.instance.collection('users');

  createNewChat(ChatModel senderDTOModel, ChatModel receiverDTOModel,
      String senderId, String receiverId) {
    this
        .userCollectionInstance
        .doc(senderId)
        .collection("requests")
        .doc(receiverId)
        .set(receiverDTOModel.toJson());
    this
        .userCollectionInstance
        .doc(receiverId)
        .collection("requests")
        .doc(senderId)
        .set(senderDTOModel.toJson());
  }

  Future<DocumentReference> sendMessage(String userId, String chatUserId,
      ChatMessageModel userMessageModel, ChatMessageModel chatMessageModel)async {
    this
        .userCollectionInstance
        .doc(userId)
        .collection("requests")
        .doc(chatUserId)
        .collection("chatroom")
        .add(userMessageModel.toJson());
    return this
        .userCollectionInstance
        .doc(chatUserId)
        .collection("requests")
        .doc(userId)
        .collection("chatroom")
        .add(chatMessageModel.toJson());
  }

  Future<QuerySnapshot> fetchAllChats(String userId) async{
    return this
        .userCollectionInstance
        .doc(userId)
        .collection("requests")
        .get();
  }

  Future<DocumentSnapshot> fetchChatById(String userId,String chatId) async{
    return this
        .userCollectionInstance
        .doc(userId)
        .collection("requests")
    .doc(chatId)
        .get();
  }

  Future<QuerySnapshot> fetchAllMessages(String userId, String chatPersonId) {
    return this
        .userCollectionInstance
        .doc(userId)
        .collection("requests")
        .doc(chatPersonId)
        .collection("chatroom")
        .orderBy("createdAt", descending: false)
        .get();
  }
}
