import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'chat_message.g.dart';
@JsonSerializable()
class ChatMessageModel{
  String id,senderID,receiverID,senderName,receiverName,senderPic,receiverPic,message;
  String createdAt;
  ChatMessageModel({this.id="",this.senderID="", this.receiverID="", this.senderName="",this.createdAt="",
      this.receiverName="", this.senderPic="", this.receiverPic="",this.message=""});
  factory ChatMessageModel.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ChatMessageModelToJson(this);
}