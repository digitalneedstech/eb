import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bid_message.g.dart';
@JsonSerializable()
class BidMessageModel{
  String message,userId,status;
  int amount,hoursNeeded;
  String createdAt,validTill;

  BidMessageModel({
      this.amount=0, this.message="",
    this.userId="",this.hoursNeeded=0,
    this.status="",this.createdAt="",this.validTill=""});
  factory BidMessageModel.fromJson(Map<String, dynamic> json) =>
      _$BidMessageModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$BidMessageModelToJson(this);

}