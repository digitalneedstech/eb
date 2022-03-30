// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_info_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillInfoDTOModel _$SkillInfoDTOModelFromJson(Map<String, dynamic> json) {
  int yearsOfExperience=0;
  if(json['yearsOfExperience'] is String)
    yearsOfExperience=int.parse(json['yearsOfExperience']);
  else
    yearsOfExperience=json['yearsOfExperience'];
  return SkillInfoDTOModel(
    achievement:json['achievement'] as String,
    yearsOfExperience:yearsOfExperience,
    skill:json['skill'] as String,
  );
}

Map<String, dynamic> _$SkillInfoDTOModelToJson(SkillInfoDTOModel instance) =>
    <String, dynamic>{
      'achievement': instance.achievement,
      'yearsOfExperience': instance.yearsOfExperience,
      'skill': instance.skill
    };
