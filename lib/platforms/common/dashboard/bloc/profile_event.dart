import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:image_picker/image_picker.dart';

class ProfileEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class UserProfileSaveStarted extends ProfileEvent {
  UserDTOModel userModel;
  UserProfileSaveStarted({required this.userModel});
}


class FetchUserProfileEvent extends ProfileEvent {
  String userId;
  FetchUserProfileEvent({this.userId=""});
}

class FileUpdation extends ProfileEvent {
  File file;
  String type;

  FileUpdation({required this.file, this.type = "Image"});
}
class FileUpdationStarted extends ProfileEvent {

}

class LicensesFileUpdation extends ProfileEvent {
  File file;
  int index;

  LicensesFileUpdation({required this.file, this.index=0});
}

class LicensesFileUpdationStarted extends ProfileEvent {

}

class WidgetUpdation extends ProfileEvent {
  WidgetUpdation();
}

class MobileVerify extends ProfileEvent{
  String mobile;
  MobileVerify({this.mobile=""});
}

class MobileOTPVerify extends ProfileEvent{
  String mobile,otp;
  MobileOTPVerify({this.mobile="",this.otp=""});
}