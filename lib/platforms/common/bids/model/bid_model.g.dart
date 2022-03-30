// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'bid_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BidModel _$BidModelFromJson(
    Map<String, dynamic> json,String id) {
  return BidModel(
    id: id,
    userId: json['userId'] as String,
    description: json['description']=="" ? "Description Not Found":json['description'],
    freelancerId: json['freelancerId'] as String,
    rejectedBy: json['rejectedBy'] as String,
    companyId: json['companyId']==null ?"":json['companyId'],
    acceptedBy: json['acceptedBy'] as String,
    clientName: json['clientName'] as String,
      profileName: json['profileName'] as String,
    askedRate: json['askedRate'] as int,
      hoursNeeded: json['hoursNeeded'] as int,
      acceptedRate: json['acceptedRate'] as int,
      bid: (json['bid'] as List)
      .map((e) => BidMessageModel.fromJson(Map.from(e)))
      .toList(),
     status: json['status'] as String,
    isLongTerm: json['isLongTerm'] as bool,
 createdAt: (json['createdAt'] as Timestamp).toDate().toIso8601String(),
  validTill: json['validTill']==null ?"":(json['validTill'] as Timestamp).toDate().toIso8601String(),
  );
}
Map<String, dynamic> _$BidModelToJson(
    BidModel instance) =>
    <String, dynamic>{
      'askedRate':instance.askedRate,
      'acceptedRate':instance.acceptedRate,
      'hoursNeeded':instance.hoursNeeded,
      'userId':instance.userId,
      'description':instance.description,
      'freelancerId':instance.freelancerId,
      'rejectedBy':instance.rejectedBy,
      'acceptedBy':instance.acceptedBy,
      'clientName':instance.clientName,
      'profileName':instance.profileName,
      'createdAt':DateTime.now(),
      'updatedAt':DateTime.now(),
      'status':instance.status,
      'bid':instance.bid.map((e) => e.toJson()).toList(),
      'isLongTerm':instance.isLongTerm,
      'isAccepted':instance.isAccepted,
      'isRejected':instance.isRejected,
      'isDeleted':instance.isDeleted,
      'validTill':DateTime.parse(instance.validTill),
      'companyId':instance.companyId
    };
