// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'experience_info_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExperienceInfoDTOModel _$ExperienceInfoDTOModelFromJson(
    Map<String, dynamic> json) {
  return ExperienceInfoDTOModel(
    json['company'] as String,
    json['description'] as String,
    json['designation'] as String,
    json['employmentType'] as String,
    json['location'] as String,
      json['currentlyWorking'] as bool,
    startDate:json['startDate']==null ?"":(json['startDate'] as String),
    endDate:json['endDate']==null?"":json['endDate'] as String
  );
}

Map<String, dynamic> _$ExperienceInfoDTOModelToJson(
        ExperienceInfoDTOModel instance) =>
    <String, dynamic>{
      'company': instance.company,
      'description': instance.description,
      'designation': instance.designation,
      'employmentType': instance.employmentType,
      'location': instance.location,
      'startDate': instance.startDate,
      'endDate': instance.currentlyWorking ? "" : instance.endDate,
      'currentlyWorking': instance.currentlyWorking
    };
