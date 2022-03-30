import 'package:json_annotation/json_annotation.dart';
part 'rate_dto_model.g.dart';

@JsonSerializable()
class RateDetailsDTOModel {
  int hourlyRate, minBid;
  String currency;
  bool negotiable;
  RateDetailsDTOModel(
      {this.hourlyRate=0, this.minBid=0, this.currency="USD", this.negotiable=false});
  factory RateDetailsDTOModel.fromJson(Map<String, dynamic> json) =>
      _$RateDetailsDTOModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$RateDetailsDTOModelToJson(this);
}
