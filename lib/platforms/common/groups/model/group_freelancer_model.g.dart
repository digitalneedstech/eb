// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'group_freelancer_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GroupFreelancerModel _$GroupFreelancerModelFromJson(
    Map<String, dynamic> json,String id) {
  bool isAccepted=false;
  if(json['isAccept']==null)
    isAccepted=json['requestStatus']=="accepted" ?true:false;
  else
    isAccepted=json['isAccept'];
  return GroupFreelancerModel(
     // createdAt: json['createdAt']==null ? null:(json['createdAt'] as Timestamp).toDate().toIso8601String(),
    profilePic: json['profilePic'] as String,
    profileTitle: json['profileTitle'] as String,
    freelancerId: json['freelancerId'] as String,
    freelancerName: json['freelancerName'] as String,
    freelancerEmail: json['freelancerEmail'] as String,
    finalRate: json['finalRate'] as String,
    isAccept: isAccepted
  );
}

Map<String, dynamic> _$GroupFreelancerModelToJson(
    GroupFreelancerModel instance) =>
    <String, dynamic>{
      'profilePic':instance.profilePic,
      'freelancerName':instance.freelancerName,
      'freelancerEmail':instance.freelancerEmail,
      'finalRate':instance.finalRate,
      'profileTitle':instance.profileTitle,
      'freelancerId':instance.freelancerId,
      'createdAt':DateTime.parse(instance.createdAt),
      'isAccept':instance.isAccept
    };
