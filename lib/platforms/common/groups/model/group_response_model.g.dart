// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupResponseModel _$GroupResponseModelFromJson(
    Map<String, dynamic> json,String id) {
  return GroupResponseModel(
    profilePic: json['profilePic'] as String,
    groupName: json['groupName'] as String,
    adminId: json['adminId'] as String,
    userName: json['userName'] as String,
      createdAt: json['createdAt']=="" ? DateTime.now().toIso8601String():(json['createdAt'] as Timestamp).toDate().toIso8601String(),
    groupId: json['groupId'] as String
  );
}