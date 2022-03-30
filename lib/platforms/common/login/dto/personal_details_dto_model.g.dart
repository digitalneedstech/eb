// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'personal_details_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonalDetailsDTOModel _$PersonalDetailsDTOModelFromJson(
    Map<String, dynamic> json) {
  /*MobileData mobileData;
  MobileData whatsAppData;
  if(json["mobileData"]==null){
    mobileData=new MobileData(dialCode: "",rawPhone: "",name: "",mobile: "",format: "",countryCode: "");
  }
  else{
    mobileData=MobileData.fromMap(Map.from(json['mobileData']));
  }
  if(json["whatsAppData"]==null){
    whatsAppData=new MobileData(dialCode: "",rawPhone: "",name: "",mobile: "",format: "",countryCode: "");
  }
  else{
    whatsAppData=MobileData.fromMap(Map.from(json['whatsAppData']));
  }*/
  return PersonalDetailsDTOModel(
      country:json['country'] as String,

      displayName:json['displayName'] as String,
      email:json['email'] as String,
      firstName:json['firstName'] as String,
      lastName:json['lastName'] as String,
      isWhatsAppSame: json['isWhatsAppSame']as bool,
      mobileData:MobileData.fromMap(Map.from(json["mobileData"])),
      profilePic:json['profilePic'] as String,
      whatsAppData:MobileData.fromMap(Map.from(json["whatsAppData"])),
      type: json['type']=="" ?Constants.CLIENT:json['type'],
      isMasked:json['isMasked'] as bool);
}

Map<String, dynamic> _$PersonalDetailsDTOModelToJson(
        PersonalDetailsDTOModel instance) =>
    <String, dynamic>{
      'country': instance.country,
      'displayName': instance.displayName,
      'isWhatsAppSame':instance.isWhatsAppSame,
      'email': instance.email,
      'firstName': instance.firstName,
      'lastName': instance.lastName,
      'mobileData': instance.mobileData.toJson(),
      'profilePic': instance.profilePic,
      'whatsAppData':instance.whatsAppData.toJson(),
          'type':instance.type,
      'isMasked': instance.isMasked
    };
