// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ChatModel _$ChatModelFromJson(
    Map<String, dynamic> json,String id) {
  return ChatModel(
    lastMessage: json['lastMessage'] as String,
    photoURL: json['photoURL'] as String,
    userName: json['userName'] as String,
      createdAt: json['createdAt']=="" ? DateTime.now().toIso8601String():(json['createdAt'] as Timestamp).toDate().toIso8601String(),
    id: id
  );
}

Map<String, dynamic> _$ChatModelToJson(
    ChatModel instance) =>
    <String, dynamic>{
      'lastMessage': instance.lastMessage,
      'photoURL': instance.photoURL,
      'userName': instance.userName,
      'createdAt':DateTime.parse(instance.createdAt),

    };
