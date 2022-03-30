// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatMessageModel _$ChatMessageModelFromJson(
    Map<String, dynamic> json) {
  return ChatMessageModel(
    message: json['message'] as String,
    senderPic: json['senderPic']==null? "":json['senderPic'] as String,
      createdAt: json['createdAt']=="" ? DateTime.now().toIso8601String():(json['createdAt'] as Timestamp).toDate().toIso8601String(),
    senderName: json['senderName'] as String,
    senderID: json['senderID'] as String,
    receiverPic: json['receiverPic']==""?"":json['receiverPic'] as String,
    receiverName: json['receiverName'] as String,
    receiverID: json['receiverID'] as String
  );
}

Map<String, dynamic> _$ChatMessageModelToJson(
    ChatMessageModel instance) =>
    <String, dynamic>{
      'message': instance.message,
      'senderID':instance.senderID,
      'senderName':instance.senderName,
      'receiverID':instance.receiverID,
      'receiverName':instance.receiverName,
      'receiverPic':instance.receiverPic,
      'createdAt':DateTime.parse(instance.createdAt),
    };
