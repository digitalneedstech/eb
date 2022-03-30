import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'post.g.dart';
@JsonSerializable()
class PostModel{
  String id,title,industry,info,postedBy;
  String tenure,createdAt;
  bool isActive;
  List<dynamic> skills;

  PostModel({this.id="",this.skills=const <dynamic>[],this.title="", this.industry="",
    this.info="",this.postedBy="", this.tenure="",
  this.createdAt="",this.isActive=true});
  factory PostModel.fromJson(Map<String, dynamic> json,String id) =>
      _$PostModelFromJson(json,id);

  Map<String, dynamic> toJson() => _$PostModelToJson(this);
}