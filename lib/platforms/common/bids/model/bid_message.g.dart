// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'bid_message.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************


BidMessageModel _$BidMessageModelFromJson(
    Map<String, dynamic> json) {
  String validTillDate="";
  if(json['validTill'] is String)
    validTillDate=json['validTill'];
  else
    validTillDate=(json['validTill'] as Timestamp).toDate().toIso8601String();
  return BidMessageModel(
      amount: json['amount'] as int,
    message: json['message'] as String,
    userId: json['userId'] as String,
    status: json['status'] as String,
    hoursNeeded: json['hoursNeeded'] as int,
    validTill: validTillDate
  );
}

Map<String, dynamic> _$BidMessageModelToJson(
    BidMessageModel instance) =>
    <String, dynamic>{
      'amount':instance.amount,
      'hoursNeeded':instance.hoursNeeded,
      'message':instance.message,
      'status':instance.status,
      'userId':instance.userId,
      'validTill':instance.validTill=="" ? DateTime.now().add(Duration(days: 2)):
      DateTime.parse(instance.validTill),
      'createdAt':instance.createdAt=="" ?DateTime.now():DateTime.parse(instance.createdAt)
    };
