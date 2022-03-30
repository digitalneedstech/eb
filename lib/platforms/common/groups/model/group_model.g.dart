// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupModel _$GroupModelFromJson(
    Map<String, dynamic> json,String id) {
  return GroupModel(
    adminPic: json['adminPic'] as String,
    groupName: json['groupName'] as String,
    adminId: json['adminId'] as String,
    adminName: json['adminName'] as String,
      isActive: json['isActive'],
      //createdAt: json['createdAt']==null ? null:(json['createdAt'] as Timestamp).toDate().toIso8601String(),
    groupId: json['groupId'] as String
  );
}

Map<String, dynamic> _$GroupModelToJson(
    GroupModel instance) =>
    <String, dynamic>{
      'adminPic': instance.adminPic,
      'groupName': instance.groupName,
      'adminName': instance.adminName,
      'createdAt':instance.createdAt=="" ?DateTime.now():DateTime.parse(instance.createdAt),
      'groupId':instance.groupId,
      'adminId':instance.adminId,
      'isActive':instance.isActive,
    };
