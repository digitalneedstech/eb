import 'package:json_annotation/json_annotation.dart';
part 'featured_info_dto_model.g.dart';

@JsonSerializable()
class FeaturedInfoDTOModel {
  String docUrl,fileUrl, fileType, name;

  FeaturedInfoDTOModel({this.docUrl="",this.fileUrl="", this.fileType="", this.name=""});
  factory FeaturedInfoDTOModel.fromJson(Map<String, dynamic> json) =>
      _$FeaturedInfoDTOModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$FeaturedInfoDTOModelToJson(this);
}
