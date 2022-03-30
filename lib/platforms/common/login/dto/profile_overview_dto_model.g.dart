// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_overview_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileOverviewDTOModel _$ProfileOverviewDTOModelFromJson(
    Map<String, dynamic> json) {
  return ProfileOverviewDTOModel(
      industry: json['industry'] as String,
      overview: json['overview'] as String,
      portfolioUrl: json['portfolioUrl'] as String,
      profileTitle: json['profileTitle']=="" ?Constants.UNTITLED :json['profileTitle'] as String,
      totalExperience: json['totalExperience'] as String,
      isSap: json['isSap'] as bool,
      industryType: json['industryType'] as int);
}

Map<String, dynamic> _$ProfileOverviewDTOModelToJson(
        ProfileOverviewDTOModel instance) =>
    <String, dynamic>{
      'industry': instance.industry,
      'overview': instance.overview,
      'portfolioUrl': instance.portfolioUrl,
      'profileTitle': instance.profileTitle,
      'totalExperience': instance.totalExperience,
      'isSap': instance.isSap,
      'industryType': instance.industryType
    };
