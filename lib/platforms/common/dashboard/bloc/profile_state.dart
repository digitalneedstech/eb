import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/dto/certificate/certification_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/featured/featured_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/personal_details_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/profile_overview_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/rate/rate_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/experience/experience_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ProfileState extends Equatable {}
class PersonalInfoLoadedState extends ProfileState {
  @override
  List<Object> get props => [];
}

class PersonalInfoEvent extends ProfileState {
  PersonalDetailsDTOModel personalDetailsDTOModel;

  PersonalInfoEvent({required this.personalDetailsDTOModel});
  @override
  List<Object> get props => [];
}

class ProfileInfoEvent extends ProfileState {
  ProfileOverviewDTOModel profileOverviewDTOModel;

  ProfileInfoEvent({required this.profileOverviewDTOModel});
  @override
  List<Object> get props => [];
}

class FeaturedInfoEvent extends ProfileState {
  FeaturedInfoDTOModel featuredInfoDTOModel;

  FeaturedInfoEvent({required this.featuredInfoDTOModel});
  @override
  List<Object> get props => [];
}

class CertificationInfoEvent extends ProfileState {
  CertificationInfoDTOModel certificationInfoDTOModel;

  CertificationInfoEvent({required this.certificationInfoDTOModel});
  @override
  List<Object> get props => [];
}

class EducationInfoEvent extends ProfileState {
  ExperienceInfoDTOModel experienceInfoDTOModel;

  EducationInfoEvent({required this.experienceInfoDTOModel});
  @override
  List<Object> get props => [];
}

class RatesInfoEvent extends ProfileState {
  RateDetailsDTOModel rateDetailsDTOModel;

  RatesInfoEvent({required this.rateDetailsDTOModel});
  @override
  List<Object> get props => [];
}

class LoadingState extends ProfileState {
  @override
  List<Object> get props => [];
}

class SaveCompleted extends ProfileState {
  UserDTOModel userDTOModel;
  SaveCompleted({required this.userDTOModel});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class FetchUserProfileState extends ProfileState {
  UserDTOModel userDTOModel;

  FetchUserProfileState({required this.userDTOModel});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ProfilePicUpdated extends ProfileState {
  File file;
  String type;
  ProfilePicUpdated({required this.file, this.type=""});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}


class LicenseFileUpdated extends ProfileState {
  File file;
  int index;
  LicenseFileUpdated({required this.file, this.index=0});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class ProfilePicUpdationInProgress extends ProfileState{
  ProfilePicUpdationInProgress();

  @override
  // TODO: implement props
  List<Object> get props => [];
}

class ExceptionState extends ProfileState {
  String message;

  ExceptionState({this.message=""});

  @override
  // TODO: implement props
  List<Object> get props => [message];
}

class CompletedState extends ProfileState {
  CompletedState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OTPSentState extends ProfileState{
  final bool isSent;
  OTPSentState({this.isSent=false});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OTPSendInProgressState extends ProfileState{
  OTPSendInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OTPVerifyInProgressState extends ProfileState{
  OTPVerifyInProgressState();

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}

class OTPVerifiedState extends ProfileState{
  final isAuthVerified;
  OTPVerifiedState({this.isAuthVerified});

  @override
  // TODO: implement props
  List<Object> get props => throw UnimplementedError();
}
