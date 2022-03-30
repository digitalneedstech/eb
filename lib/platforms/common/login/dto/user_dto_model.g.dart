// GENERATED CODE - DO NOT MODIFY BY HAND
part of 'user_dto_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserDTOModel _$UserDTOModelFromJson(Map<String, dynamic> json, String id) {
  List<dynamic> languages = [];
 /* if (json['languages'] is List) {
    languages = json['languages'];
  } else if (json['languages'] is String) {
    if (json['languages'].toString().contains(",")) {
      languages = json['languages'].toString().split(",").toList();
    }
  }*/
  DateTime createdDateTime = DateTime.now();
  String userAvailabilityStatus = "available";
  if (json['userAvailabilityStatus'] is int) {
    if (json['userAvailabilityStatus'] == 1)
      userAvailabilityStatus = "away";
    else if (json['userAvailabilityStatus'] == 0)
      userAvailabilityStatus = "offline";
  }
  if (json['createdAt'] is String) {
    createdDateTime = DateTime.parse(json['createdAt']);
  } else {
    if (json['createdAt'] != null)
      createdDateTime = (json['createdAt'] as Timestamp).toDate();
  }
  UserDTOModel userDTOModel;
  userDTOModel=new UserDTOModel(
    createdDateTime,
    json['isOnline'] as bool,
    json['isValid'] as bool,
    json['isVerified'] as bool,
    userId: id,
    avgRatings: 0.0,
    isFeatured: json['isFeatured'] as bool,
    referredBy: json['referredBy'] as String,
    shareLink: json['shareLink'] as String,
    shareLinkForCompany: json['shareLinkForCompany'],
    userAvailabilityStatus: userAvailabilityStatus,
    walletAmount: json['walletAmount'],
    languages: json['languages']==null ?[]:json['languages'] as List<dynamic>,
    userType: json['userType'] as String,
    planType: json['planType'] as String,
    companyId:json['companyId']==null ? "":json['companyId'] as String,
    personalDetails: PersonalDetailsDTOModel.fromJson(Map.from(json['personalDetails'])),
    profileOverview: ProfileOverviewDTOModel.fromJson(Map.from(json['profileOverview'])),
    /*skillsDefined:
       json['skillsDefined']==null ?[]:(json['skillsDefined'] as List<dynamic>),*/
    skills: (json['skills'] as List)
            .map((e) =>
                SkillInfoDTOModel.fromJson(Map.from(e)))
            .toList(),
    rateDetails: RateDetailsDTOModel.fromJson(Map.from(json['rateDetails'])),
    experienceDetails: List.from(json['experienceDetails'])
            .map((e) =>
                ExperienceInfoDTOModel.fromJson(Map.from(e)))
            .toList(),
    certificateDetails: List.from(json['certificateDetails'])
            .map((e) => CertificationInfoDTOModel.fromJson(Map.from(e)))
            .toList(),
    billingAddress: BillingAddressModel.fromMap(Map.from(json['billingAddress'])),
    featuredDetails: List.from(json['featuredDetails'])
            .map((e) =>
                FeaturedInfoDTOModel.fromJson(Map.from(e)))
            .toList(),
  companyDetails: CompanyModel(),
  );
  return userDTOModel;
}

Map<String, dynamic> _$UserDTOModelToJson(UserDTOModel instance) =>
    <String, dynamic>{
      'shareLink': instance.shareLink,
      'shareLinkForCompany':instance.shareLinkForCompany,
      'referredBy': instance.referredBy,
      'isOnline': instance.isOnline,
      'avgRatings': instance.avgRatings,
      'isFeatured': instance.isFeatured,
      'isValid': instance.isValid,
      'userAvailabilityStatus': instance.userAvailabilityStatus,
      'isVerified': instance.isVerified,
      'userType': instance.userType,
      'planType': instance.planType,
      'companyId': instance.companyId,
      'walletAmount': instance.walletAmount,
      'languages': instance.languages,
      'personalDetails': instance.personalDetails.toJson(),
      'profileOverview': instance.profileOverview.toJson(),
      'billingAddress': instance.billingAddress.toJson(),
      'skills': instance.skills.map((e) => e.toJson()).toList(),
      'skillsDefined': instance.skills.map((e) => e.skill).toList(),
      'rateDetails': instance.rateDetails.toJson(),
      'experienceDetails': instance.experienceDetails.map((e) => e.toJson()).toList(),
      'certificateDetails': instance.certificateDetails.map((e) => e.toJson()).toList(),
      'featuredDetails': instance.featuredDetails.map((e) => e.toJson()).toList(),
      'companyDetails': instance.companyDetails.toJson(),
      'isCallActive':instance.isCallActive,
      'isTerminated':instance.isTerminated
    };
