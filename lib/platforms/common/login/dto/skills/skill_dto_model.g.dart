// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'skill_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SkillDTOModel _$SkillDTOModelFromJson(Map<String, dynamic> json) {
  return SkillDTOModel(
    skills: (json['skills'] as List)
        .map((e) => SkillInfoDTOModel.fromJson(e as Map<String, dynamic>))
        .toList(),
  );
}

Map<String, dynamic> _$SkillDTOModelToJson(SkillDTOModel instance) =>
    <String, dynamic>{
      'skills': instance.skills,
    };
