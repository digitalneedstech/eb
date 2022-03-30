// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'certification_info_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CertificationInfoDTOModel _$CertificationInfoDTOModelFromJson(
    Map<String, dynamic> json) {
  return CertificationInfoDTOModel(
    credentialId:json['credentialId'] as String,
    credentialUrl:json['credentialUrl'] as String,
    name:json['name'] as String,
    organization:json['organization'] as String,
    //fileUrl: json['fileUrl'] as String
  );
}

Map<String, dynamic> _$CertificationInfoDTOModelToJson(
        CertificationInfoDTOModel instance) =>
    <String, dynamic>{
      'credentialId': instance.credentialId,
      'credentialUrl': instance.credentialUrl,
      'name': instance.name,
      'organization': instance.organization,
      'fileUrl':instance.fileUrl
    };
