import 'package:json_annotation/json_annotation.dart';
part 'skill_info_dto_model.g.dart';

@JsonSerializable()
class SkillInfoDTOModel {
  String achievement, skill;
  int yearsOfExperience;
  SkillInfoDTOModel({this.achievement="",
    this.yearsOfExperience=0,
    this.skill=""});
  factory SkillInfoDTOModel.fromJson(Map<String, dynamic> json) =>
      _$SkillInfoDTOModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SkillInfoDTOModelToJson(this);
}
