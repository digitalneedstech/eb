import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_event.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_state.dart';
import 'package:flutter_eb/platforms/common/dashboard/data/profile_repository.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';

import 'profile_event.dart';
import 'profile_event.dart';
import 'profile_state.dart';
import 'profile_state.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class ProfileBloc extends Bloc<ProfileEvent, ProfileState> {
  final LoginRepository loginRepository;
  final ProfileRepository profileRepository;

  ProfileBloc(this.loginRepository,this.profileRepository) : super(PersonalInfoLoadedState());
  late String _type;

  String get type => _type;

  set type(String value) {
    _type = value;
  }

  Map<int,File>? licenseFileMap;

  late File _file;
  File get file => _file;

  set file(File value) {
    _file = value;
  }

  updateDataInFile(File value, [String type = "Image"]) {
    file = value;
    _type = type;
  }

//TODO- Make Bloc For this repo and for Patient save
  @override
  Stream<ProfileState> mapEventToState(
    ProfileEvent event,
  ) async* {
    if (event is UserProfileSaveStarted) {
      updateDataInFile(new File(""));
      yield LoadingState();
      await saveProfileInfo(event.userModel);
      yield SaveCompleted(userDTOModel: event.userModel);
    }

    if (event is LicensesFileUpdation) {
      yield ProfilePicUpdationInProgress();
      if(licenseFileMap==null){
        licenseFileMap={};
        licenseFileMap![event.index]=event.file;
      }
      else{
        licenseFileMap![event.index]=event.file;
      }
      yield LicenseFileUpdated(file: file, index: event.index);
    }

    if (event is FileUpdation) {
      yield ProfilePicUpdationInProgress();
      updateDataInFile(event.file);
      yield ProfilePicUpdated(file: file, type: event.type);
    }

    if (event is FileUpdationStarted) {
      yield ProfilePicUpdationInProgress();

    }
    if (event is WidgetUpdation) {
      yield LoadingState();
      yield CompletedState();
    }
    if(event is MobileVerify){
      yield OTPSendInProgressState();
      bool isOTPSent=await sendOTP(event.mobile);
      yield OTPSentState(isSent: isOTPSent);
    }

    if(event is MobileOTPVerify){
      yield OTPVerifyInProgressState();
      bool isAuthVerified=await verifyOTP(event.mobile,event.otp);
      yield OTPVerifiedState(isAuthVerified: isAuthVerified);
    }

    if(event is FetchUserProfileEvent){
      yield LoadingState();
      DocumentSnapshot snapshot=await getUserDetails(event.userId);
      yield FetchUserProfileState(userDTOModel: UserDTOModel.fromJson(snapshot.data() as Map<String,dynamic>,snapshot.id));
    }
  }

  Future<void> saveProfileInfo(UserDTOModel userDTOModel) async {
    await loginRepository.addorUpdateRecord(userDTOModel);
  }

  Future<bool> sendOTP(String mobileNumber)async{
    bool response=await profileRepository.sendOTP(mobileNumber);
    return response;
  }

  Future<bool> verifyOTP(String mobileNumber,String otp)async {
    return await profileRepository.verifyOtp(mobileNumber, otp);
  }
  Future<DocumentSnapshot> getUserDetails(String emailId)async{
    DocumentSnapshot response=await profileRepository.getUserByEmail(emailId);
    return response;
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}
