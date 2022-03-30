// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'rate_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RateDetailsDTOModel _$RateDetailsDTOModelFromJson(Map<String, dynamic> json) {
  if(json['hourlyRate'] is String){
    return RateDetailsDTOModel(
      hourlyRate: int.parse(json['hourlyRate'] as String),
      minBid: int.parse(json['minBid'] as String),
      currency: json['currency'] as String,
      negotiable: json['negotiable'] as bool,
    );
  }
  return RateDetailsDTOModel(
    hourlyRate: json['hourlyRate'] as int,
    minBid: json['minBid'] as int,
    currency: json['currency'] as String,
    negotiable: json['negotiable'] as bool,
  );
}

Map<String, dynamic> _$RateDetailsDTOModelToJson(
        RateDetailsDTOModel instance) =>
    <String, dynamic>{
      'hourlyRate': instance.hourlyRate,
      'minBid': instance.minBid,
      'currency': instance.currency,
      'negotiable': instance.negotiable,
    };
