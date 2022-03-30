import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'group_freelancer_model.g.dart';
@JsonSerializable()
class GroupFreelancerModel{
  String freelancerId,freelancerEmail,finalRate,freelancerName,profilePic,profileTitle,createdAt,requestStatus;
  bool isAccept;

  GroupFreelancerModel({this.freelancerId="",this.freelancerEmail="",this.finalRate="",
    this.freelancerName="", this.profileTitle="",
    this.profilePic="",
      this.createdAt="", this.isAccept=false,this.requestStatus=""});
  factory GroupFreelancerModel.fromJson(Map<String, dynamic> json,String id) =>
      _$GroupFreelancerModelFromJson(json,id);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$GroupFreelancerModelToJson(this);
}