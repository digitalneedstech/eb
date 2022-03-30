import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chat.g.dart';
@JsonSerializable()
class ChatModel{
  String id,userName,photoURL,lastMessage,createdAt;


  ChatModel(
  {this.id="", this.userName="", this.photoURL="", this.lastMessage="", this.createdAt=""});
  factory ChatModel.fromJson(Map<String, dynamic> json,String id) =>
      _$ChatModelFromJson(json,id);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ChatModelToJson(this);
}