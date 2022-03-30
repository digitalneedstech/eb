import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_message.dart';
import 'package:json_annotation/json_annotation.dart';
part 'bid_model.g.dart';

@JsonSerializable()
class BidModel {
  String id,
      description,
      clientName,
      profileName,
      createdBy,
      freelancerId,
      userId,
      rejectedBy,
      acceptedBy,companyId,status;
  int amount,acceptedRate,askedRate,hoursNeeded;
  bool isLongTerm,isAccepted,isRejected,isDeleted;
  String createdAt, finalUpdatedAt,validTill;
  List<BidMessageModel> bid;

  BidModel(
      {this.id="",
      this.askedRate=0,
        this.companyId="",
        this.acceptedRate=0,
        this.hoursNeeded=0,
      this.freelancerId="",
      this.userId="",
      this.createdAt="",
      this.status="",
      this.rejectedBy="",
      this.clientName="",
      this.profileName="",
      this.createdBy="",
      this.finalUpdatedAt="",
      this.bid=const <BidMessageModel>[],
      this.description="",
        this.validTill="",
      this.acceptedBy="",
        this.isLongTerm=false,this.isDeleted=false,
        this.isAccepted=false,
        this.isRejected=false,this.amount=0});

  factory BidModel.fromJson(Map<String, dynamic> json, String id) =>
      _$BidModelFromJson(json, id);

  Map<String, dynamic> toJson() => _$BidModelToJson(this);
}
