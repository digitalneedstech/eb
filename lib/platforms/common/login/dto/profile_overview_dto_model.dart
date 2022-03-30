import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:json_annotation/json_annotation.dart';
part 'profile_overview_dto_model.g.dart';

@JsonSerializable()
class ProfileOverviewDTOModel {
  String industry, overview, portfolioUrl, profileTitle, totalExperience;
  bool isSap;
  int industryType;

  ProfileOverviewDTOModel(
      {this.industry="",
      this.overview="",
      this.portfolioUrl="",
      this.profileTitle="",
      this.totalExperience="",
      this.isSap=false,
      this.industryType=1});
  factory ProfileOverviewDTOModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileOverviewDTOModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ProfileOverviewDTOModelToJson(this);
}
