import 'package:cloud_firestore/cloud_firestore.dart';

class GroupChatModel{
  String createdAt,userID,senderName,message;
  GroupChatModel({this.createdAt="",this.userID="",this.senderName="",this.message=""});
  factory GroupChatModel.fromMap(Map<String,dynamic> json){
    return new GroupChatModel(
      message: json['message'],
        createdAt: (json['createdAt'] as Timestamp).toDate().toIso8601String(),
      senderName: json['senderName'],
      userID: json['userID']
    );
  }

  toJson(){
    return {
      "userID":userID,
      "senderName":senderName,
      "message":message,
      'createdAt':createdAt=="" ?DateTime.now():DateTime.parse(createdAt)
    };
  }
}