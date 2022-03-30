import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
part 'personal_details_dto_model.g.dart';

@JsonSerializable()
class PersonalDetailsDTOModel {
  //type= customer or vendor
  String country,
      displayName,
      profilePic,
      email,
      firstName,
      lastName,
      type;
  bool isMasked,isWhatsAppSame;
  MobileData mobileData,whatsAppData;
  PersonalDetailsDTOModel({
      this.country="",
      this.displayName="Unnamed",
      this.profilePic="",
      this.email="",
      this.firstName="firstName",
      this.lastName="lastName",
      required this.mobileData,required this.whatsAppData,
      this.type="",this.isWhatsAppSame=true,
      this.isMasked=false});
  factory PersonalDetailsDTOModel.fromJson(Map<String, dynamic> json) =>
      _$PersonalDetailsDTOModelFromJson(json);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$PersonalDetailsDTOModelToJson(this);
}

class MobileData{
  String dialCode,format,mobile,name,rawPhone,countryCode;

  MobileData({this.dialCode="", this.format="", this.mobile="",
    this.countryCode="",this.name="", this.rawPhone=""});
  factory MobileData.fromMap(Map<String,dynamic> json){
    return new MobileData(
      countryCode: json['countryCode']as String,
      dialCode: json['dialCode'] as String,
      format: json['format'] as String,
      mobile: json['mobile'] as String,
      name: json['name'] as String,
      rawPhone: json['rawPhone'] as String
    );
  }
  toJson(){
    return{
      "countryCode":countryCode,
      "dialCode":dialCode,
      "format":format,
      "mobile":mobile,
      "name":name,
      "rawPhone":rawPhone
    };
  }
}