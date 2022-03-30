import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'group_response_model.g.dart';
@JsonSerializable()
class GroupResponseModel {
  String groupId,adminId, groupName, createdAt,userName,profilePic;

  List<dynamic> groupMembers;

  GroupResponseModel({this.groupId="", this.groupName="", this.createdAt="",
    this.groupMembers=const <dynamic> [],this.adminId="",this.userName="",this.profilePic=""});
  factory GroupResponseModel.fromJson(Map<String, dynamic> json,String id) =>
      _$GroupResponseModelFromJson(json,id);
}
