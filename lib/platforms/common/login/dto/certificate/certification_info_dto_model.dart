import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
part 'certification_info_dto_model.g.dart';

@JsonSerializable()
class CertificationInfoDTOModel {
  String credentialId, credentialUrl, name, organization,fileUrl;
  File file=new File("");
  CertificationInfoDTOModel({
      this.credentialId="", this.credentialUrl="", this.name="", this.organization="",
    this.fileUrl=""});
  factory CertificationInfoDTOModel.fromJson(Map<String, dynamic> json) =>
      _$CertificationInfoDTOModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$CertificationInfoDTOModelToJson(this);
}
