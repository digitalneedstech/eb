// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'schedule_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ScheduleRequest _$ScheduleRequestFromJson(
    Map<String, dynamic> json,String id) {
  double askedRate=0.0;

  if(json['askedRate'] is int)
    askedRate=(json['askedRate'] as int).toDouble();
  else
    askedRate=json['askedRate'];
  return ScheduleRequest(
    id: id,
    groupId: json['groupId']==null ?"":json['groupId'] as String,
    freelancers: json['freelancers']==null || List.from(json['freelancers']).isEmpty ?
    []:List.from(json['freelancers']),
    askedRate: askedRate,
      status: json['status'] as String,
      freelancerId: json['freelancerId']==null ?"":json['freelancerId'] as String,
      userId: json['userId'] as String,
      channel: json['channel']==null ? "":json['channel'] as String,
      description: json['description'] as String,
      userName: json['userName'] as String,
      freelancerName: json['freelancerName'] as String,
      duration: json['duration'] as int,
      callScheduled: (json['callScheduled'] as String),
      //isBidCreated: json['isBidCreated'] as bool,
      createdAt: json['createdAt']==null ?"":(json['createdAt'] as Timestamp).toDate().toIso8601String(),
      //updatedAt: (json['updatedAt'] as Timestamp).toDate().toIso8601String(),
  );
}

Map<String, dynamic> _$ScheduleRequestToJson(
    ScheduleRequest instance) =>
    <String, dynamic>{
      'askedRate':instance.askedRate,
      'freelancerId':instance.freelancerId,
      'userId':instance.userId,
      'status':instance.status,
      'channel':instance.channel,
      'description':instance.description,
      'userName':instance.userName,
      'freelancerName':instance.freelancerName,
      'duration':instance.duration,
      'callScheduled':instance.callScheduled,
      'isBidCreated':instance.isBidCreated,
      'updatedAt':instance.updatedAt==""?DateTime.now():DateTime.parse(instance.updatedAt),
      'createdAt':instance.createdAt==""?DateTime.now():DateTime.parse(instance.createdAt),
    };
