// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'featured_info_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

FeaturedInfoDTOModel _$FeaturedInfoDTOModelFromJson(Map<String, dynamic> json) {
  return FeaturedInfoDTOModel(
    docUrl: json['docUrl'] as String,
    fileType: json['fileType'] as String,
    fileUrl: json['fileUrl'] as String,
    name: json['name'] as String,
  );
}

Map<String, dynamic> _$FeaturedInfoDTOModelToJson(
        FeaturedInfoDTOModel instance) =>
    <String, dynamic>{
      'docUrl': instance.docUrl,
      'fileType': instance.fileType,
      'fileUrl': instance.fileUrl,
      'name': instance.name,
    };
