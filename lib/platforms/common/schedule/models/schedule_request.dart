
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eb/platforms/common/schedule/models/call_model.dart';
import 'package:flutter_eb/platforms/common/schedule/models/schedule_updated_request.dart';
import 'package:json_annotation/json_annotation.dart';
part 'schedule_request.g.dart';

@JsonSerializable()
class ScheduleRequest{
  String id;
  String? groupId;
  int duration;
  double askedRate;
  bool isBidCreated;
  List<Freelancers>? freelancers;
  String status,channel,
      description,freelancerId,freelancerName,userId,userName,callScheduled,createdAt,updatedAt;

  ScheduleRequest({
    this.groupId,
    this.freelancers,
    this.id="",
      this.askedRate=0,
    this.isBidCreated=false,
      this.duration=0,
      this.channel="",
      this.description="",
      this.freelancerId="",
      this.freelancerName="Unnamed",
      this.status="pending",
      this.userId="",
      this.userName="",
      this.callScheduled="",
      this.createdAt="",
      this.updatedAt=""});
  factory ScheduleRequest.fromJson(Map<String, dynamic> json,String id) =>
      _$ScheduleRequestFromJson(json,id);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ScheduleRequestToJson(this);

}