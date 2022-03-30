import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:json_annotation/json_annotation.dart';
import 'group_freelancer_model.dart';
part 'group_model.g.dart';

@JsonSerializable()
class GroupModel {
  String groupId,adminId, groupName, createdAt,adminName,adminPic;
  bool isActive;
  Map<UserDTOModel,GroupFreelancerModel> groupMembers;

  GroupModel({this.groupId="", this.groupName="", this.createdAt="",
      this.groupMembers=const <UserDTOModel,GroupFreelancerModel> {},
    this.adminId="",this.adminName="",this.adminPic="",this.isActive=true});
  factory GroupModel.fromJson(Map<String, dynamic> json,String id) =>
      _$GroupModelFromJson(json,id);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GroupModelToJson(this);
}
