import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'experience_info_dto_model.g.dart';

@JsonSerializable()
class ExperienceInfoDTOModel {
  String company, description, designation, employmentType, location,startDateReceived,endDateReceived;
  String startDate, endDate;
  bool currentlyWorking;

  ExperienceInfoDTOModel(
      this.company,
      this.description,
      this.designation,
      this.employmentType,
      this.location,

      this.currentlyWorking,{
        this.startDate="",
        this.endDate="",this.startDateReceived="",this.endDateReceived=""
  });

  factory ExperienceInfoDTOModel.fromJson(Map<String, dynamic> json) =>
      _$ExperienceInfoDTOModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$ExperienceInfoDTOModelToJson(this);
}
