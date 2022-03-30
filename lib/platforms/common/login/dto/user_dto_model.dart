import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_eb/platforms/common/login/dto/billing_address/billing_address_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/certificate/certification_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/featured/featured_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/personal_details_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/profile_overview_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/rate/rate_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/skills/skill_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/skills/skill_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/experience/experience_info_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/platforms/common/login/dto/company_model/company_model.dart';
import 'package:json_annotation/json_annotation.dart';

part 'user_dto_model.g.dart';

@JsonSerializable()
class UserDTOModel {
  //userType= Organization or Individual
  //userAvailabilityStatus== available,away or offline
  String userId,
      userType,
      planType,
      companyId,
      userAvailabilityStatus,
      shareLink,
      shareLinkForCompany;
  DateTime createdAt;
  bool isOnline, isValid, isVerified, isFeatured,isCallActive,isTerminated;
  int walletAmount;
  double avgRatings;
  String referredBy;
  List<dynamic> languages, skillsDefined;
  PersonalDetailsDTOModel personalDetails;
  BillingAddressModel billingAddress;
  ProfileOverviewDTOModel profileOverview;
  CompanyModel companyDetails;
  List<SkillInfoDTOModel> skills;
  RateDetailsDTOModel rateDetails;
  List<ExperienceInfoDTOModel> experienceDetails;
  List<CertificationInfoDTOModel> certificateDetails;
  List<FeaturedInfoDTOModel> featuredDetails;
  UserDTOModel(this.createdAt, this.isOnline, this.isValid, this.isVerified,
      {this.userId="",
      this.shareLink="",
      this.shareLinkForCompany="",
      this.referredBy="",
      this.userAvailabilityStatus="available",
      this.walletAmount=0,
      this.userType="individual",
      this.planType="Free",
      this.companyId="",
      this.languages=const <dynamic>[],
      this.avgRatings=0.0,
      this.isFeatured=false,
      required this.personalDetails,
      required this.billingAddress,
      required this.profileOverview,
      this.skills=const <SkillInfoDTOModel>[],
      this.skillsDefined=const <dynamic>[],
      required this.rateDetails,
        this.isCallActive=false,
        this.isTerminated=false,
      this.experienceDetails=const <ExperienceInfoDTOModel>[],
      this.certificateDetails=const <CertificationInfoDTOModel>[],
      this.featuredDetails=const <FeaturedInfoDTOModel>[],required this.companyDetails});
  factory UserDTOModel.fromJson(Map<String, dynamic> json, String id) =>
      _$UserDTOModelFromJson(json, id);
  factory UserDTOModel.fromJson2(Map<String, dynamic> json) =>
      UserDTOModel.fromJson(json, json['id']);

  /// `toJson` is the convention for a class to declare support for serialization
  /// to JSON. The implementation simply calls the private, generated
  /// helper method `_$UserToJson`.
  Map<String, dynamic> toJson() => _$UserDTOModelToJson(this);
}
