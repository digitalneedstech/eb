import 'package:json_annotation/json_annotation.dart';

import 'skill_info_dto_model.dart';
part 'skill_dto_model.g.dart';

@JsonSerializable()
class SkillDTOModel {
  List<SkillInfoDTOModel> skills;
  SkillDTOModel({required this.skills});
  factory SkillDTOModel.fromJson(Map<String, dynamic> json) =>
      _$SkillDTOModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$SkillDTOModelToJson(this);
}
