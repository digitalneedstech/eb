import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
//import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_event.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_state.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/affiliate_model/affiliate_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/billing_address/billing_address_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/company_model/company_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/personal_details_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/profile_overview_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/rate/rate_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/skills/skill_info_dto_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/token_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/transaction_model.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sprintf/sprintf.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository loginRepository;
  final NotificationRepository notificationRepository;
  LoginBloc(this.loginRepository, this.notificationRepository)
      : super(LoginLoadedState());
  String _userAvailabilityStatus = "available";

  String get userAvailabilityStatus => _userAvailabilityStatus;

  set userAvailabilityStatus(String value) {
    _userAvailabilityStatus = value;
  }

  late UserDTOModel _userDTOModel;
  late String _userProfileType;

  String get userProfileType => _userProfileType;

  set userProfileType(String value) {
    _userProfileType = value;
  }

  late String _userType;
  bool _isUserRole = true;

  bool get isUserRole => _isUserRole;

  set isUserRole(bool value) {
    _isUserRole = value;
  }

  UserDTOModel get userDTOModel => _userDTOModel;

  set userDTOModel(UserDTOModel value) {
    _userDTOModel = value;
  } //TODO- Make Bloc For this repo and for Patient save

  String notificationContentForWelcomingNewAffiliate =
      "Hello %s \n We are happy to welcome you onboard to be an Expert solution "
      "provider through ExpertBunch platform. \n"
      "Your registration has been successfully completed, you may update your profile with the latest skills and service focus so that prospect clients"
      " can reach out to you fast. \n"
      "You may also avail service from this platform for other expert skills. \n"
      "In case of any trouble in connecting, contact support@expertbunch.com"
      "Best Regards, \n"
      "EXPERT BUNCH Managment Team \n"
      "Email: ebteam@expertbunch.com";

  String notificationContentForInvitee =
      "Hello\n %s has successfully completed registration at ExpertBunch. Thank you for referring %s. \n"
      " Your reward towards every transaction will be automatically credited to your wallet. \n"
      "You may continue to refer more experts or users for better benefits. \n"
      "In case of any trouble in connecting, contact support@expertbunch.com"
      "Best Regards, \n"
      "EXPERT BUNCH Managment Team \n"
      "Email: ebteam@expertbunch.com";
  @override
  Stream<LoginState> mapEventToState(
    LoginEvent event,
  ) async* {
    if (event is LoginStartedEvent) {
      yield LoadingState();
      dynamic response =
          await signInUserWithEmailAndPassword(event.email, event.password);
      if (response is UserDTOModel) {
        userDTOModel = response;
        userProfileType=response.personalDetails.type==Constants.CUSTOMER ? Constants.CUSTOMER: Constants.USER;
        if (!kIsWeb) {
          TokenModel tokenModel = await getFcmToken();
          addTokenToUser(userDTOModel.userId, tokenModel);
        }
        yield LoggedInState(userModel: response);
      } else
        yield ExceptionState(message: response);
    }

    if (event is RegistrationStartedEvent) {
      yield LoadingState();
      dynamic response = await saveUserDetails(event.email, event.password,
          event.selectedType, event.senderId, event.typeOfDeepLink);
      if (response is UserDTOModel) {
        userDTOModel = response;
        userProfileType=response.personalDetails.type==Constants.CUSTOMER ? Constants.CUSTOMER: Constants.USER;
        if (!kIsWeb) {
          TokenModel tokenModel = await getFcmToken();
          addTokenToUser(userDTOModel.userId, tokenModel);
        }
        yield RegisteredState(userModel: response);
      } else
        yield ExceptionState(message: response);
    }

    if (event is GmailLoginEvent) {
      yield GmailLoadingState();
      dynamic response = await loginWithGmailAndRegister();
      if (response is UserDTOModel) {
        userDTOModel = response;
        userProfileType=response.personalDetails.type==Constants.CUSTOMER ? Constants.CUSTOMER: Constants.USER;
        TokenModel tokenModel = await getFcmToken();
        addTokenToUser(userDTOModel.userId, tokenModel);
        yield LoggedInState(userModel: response);
      } else
        yield ExceptionState(message: response);
    }

    if (event is ForgotPasswordEvent) {
      yield LoadingState();
      dynamic response = await sendPasswordResetMail(event.email);
      if (response is bool)
        yield PasswordResetMailSentState();
      else
        yield ExceptionState(message: response);
    }

    if (event is SwitchRoleEvent) {
      isUserRole = event.role;
      yield SwitchRoleState(role: isUserRole);
    }

    if (event is UpdateAvailabilityStatus) {
      userAvailabilityStatus = event.status;
      yield UpdateAvailabilityStatusState(status: event.status);
    }

    if (event is UpdateUserEvent) {
      yield LoadingState();
      _userDTOModel = event.userDTOModel;
      updateUser(_userDTOModel);
      yield UpdateUserState(userDTOModel: _userDTOModel);
    }

    if (event is GetAffiliatesEvent) {
      yield LoadingState();
      List<AffiliateModel> affiliates = await getAffiliates(event.senderId);
      yield GetAffiliatesState(affiliateModels: affiliates);
    }

    if (event is GetUserByIdEvent) {
      yield LoadingState();
      dynamic userResponse = await getUserById(event.userId);
      if (userResponse is UserDTOModel) {
        yield GetUserByIdState(userDTOModel: userResponse);
      }
      else if(userResponse is String){
        yield ExceptionState(message: userResponse);
      }
    }

    if (event is FetchAffiliateTransactions) {
      yield FetchAffiliateTransactionsInProgressState();
      Map<String, List<TransactionModel>> transactionsMap = {};
      try {
        QuerySnapshot snapshot =
            await loginRepository.getAffiliateTransactions(event.userId);
        List<TransactionModel> transactions = snapshot.docs
            .map((e) =>
                TransactionModel.fromMap(e.data() as Map<String, dynamic>))
            .toList();
        for (TransactionModel e in transactions) {
          if (transactionsMap.containsKey(e.senderId)) {
            List<TransactionModel> transactionsForUser =
                transactionsMap[e.senderId]!;
            transactionsForUser.add(e);
            transactionsMap[e.senderId] = transactionsForUser;
          } else {
            transactionsMap[e.senderId] = [e];
          }
        }
        yield FetchAffiliateTransactionsState(transactions: transactionsMap);
      } catch (e) {
        yield FetchAffiliateTransactionsState(transactions: {});
      }
    }
    if (event is FetchFeaturedFreelancersList) {
      yield LoadingState();
      List<UserDTOModel> users = [];
      QuerySnapshot snapshot =
          await this.loginRepository.fetchFeaturedFreelancersList();
      if (snapshot.docs.isNotEmpty)
        users = snapshot.docs
            .map((e) =>
                UserDTOModel.fromJson(e.data() as Map<String, dynamic>, e.id))
            .toList();
      yield FetchFeaturedFreelancersListState(userDTOModel: users);
    }
  }

  Future<dynamic> getUserById(String userId) async {
    DocumentSnapshot snapshot = await this.loginRepository.getUserByUid(userId);
    if(snapshot.exists) {
      UserDTOModel userDTOModel = UserDTOModel.fromJson(
          snapshot.data() as Map<String, dynamic>, snapshot.id);
      return userDTOModel;
    }
    return "Not Found";
  }

  Future<dynamic> saveUserDetails(String email, String password,
      String selectedType, String senderId, String typeOfDeeplink) async {
    dynamic response = await loginRepository.registerUser(email, password);
    if (response is User) {
      String email = response.email!;
      String displayName = Constants.UNNAMED;
      String shareLink = "";
      String shareLinkForCompany = "";
      if (response.displayName != null) displayName = response.displayName!;

      if (!kIsWeb) {
        shareLink = await shareDynamicLinks(response.uid, "affiliate");
      }
      if (selectedType == Constants.ORAGNIZATION && !kIsWeb)
        shareLinkForCompany =
            await shareDynamicLinks(response.uid, Constants.ORAGNIZATION);
      UserDTOModel userDTOModel = new UserDTOModel(
          DateTime.now(), true, true, true,
          billingAddress: BillingAddressModel(),
          companyDetails: CompanyModel(),
          profileOverview: ProfileOverviewDTOModel(),
          rateDetails: RateDetailsDTOModel(),
          userType: selectedType,
          userId: response.uid,
          shareLink: shareLink,
          companyId: typeOfDeeplink == Constants.ORAGNIZATION ? senderId : "",
          shareLinkForCompany: shareLinkForCompany,
          referredBy: senderId,
          personalDetails: PersonalDetailsDTOModel(
              email: email,
              type: selectedType == Constants.INDIVIDUAL
                  ? Constants.CLIENT
                  : Constants.CUSTOMER,
              displayName: displayName,
              whatsAppData: new MobileData(),
              mobileData: new MobileData()));
      //whatsApp: response.phoneNumber));
      DocumentSnapshot snapshot =
          await loginRepository.addorUpdateRecord(userDTOModel);
      UserDTOModel userDTOModelToBeReturned = UserDTOModel.fromJson(
          snapshot.data() as Map<String, dynamic>, snapshot.id);
      if (typeOfDeeplink == "affiliate") {
        if (senderId != "") {
          await loginRepository.updateAffiliateRecord(
              senderId, response.email!, response.uid, "affiliate");
          NotificationMessage notificationMessageEmailPayloadForAffiliate =
              new NotificationMessage(
                  type: "mail",
                  payload: NotificationMessageEmailPayload(
                      response.email!,
                      "Welcome onboard from ExpertBunch",
                      notificationContentForWelcomingNewAffiliate));
          this
              .notificationRepository
              .sendNotification(notificationMessageEmailPayloadForAffiliate);

          NotificationMessage notificationMessageEmailPayloadForInvitee =
              new NotificationMessage(
                  type: "mail",
                  payload: NotificationMessageEmailPayload(
                      response.email!,
                      "${response.email} has successfully registered with EB",
                      sprintf(notificationContentForInvitee,
                          [response.email, response.email])));
          this
              .notificationRepository
              .sendNotification(notificationMessageEmailPayloadForInvitee);
        }
      } else if (typeOfDeeplink == Constants.ORAGNIZATION) {
        await loginRepository.updateMyCompanyRecord(
              senderId, response.email!, response.uid);

      }

      return userDTOModelToBeReturned;
    }
    return response;
  }

  Future<dynamic> loginWithGmailAndRegister() async {
    dynamic response = await loginRepository.signInWithGoogle();
    if (response is User) {
      DocumentSnapshot snapshot =
          await loginRepository.getUserByUid(response.uid);

      SharedPreferences preferences = await SharedPreferences.getInstance();
      preferences.setBool("isGoogleAuthenticated", true);
      if (snapshot.data() as Map<String, dynamic> != null) {
        UserDTOModel userDTOModel = UserDTOModel.fromJson(
            snapshot.data() as Map<String, dynamic>, snapshot.id);
        return userDTOModel;
      } else {
        String shareLink = "";
        if (!kIsWeb)
          shareLink = await shareDynamicLinks(response.uid, "affiliate");
        UserDTOModel userDTOModel = new UserDTOModel(
            DateTime.now(), true, true, true,
            billingAddress: BillingAddressModel(),
            companyDetails: CompanyModel(),
            profileOverview: ProfileOverviewDTOModel(),
            rateDetails: RateDetailsDTOModel(),
            userType: Constants.INDIVIDUAL,
            userId: response.uid,
            shareLink: shareLink,
            personalDetails: PersonalDetailsDTOModel(
                email: response.email!,
                type: "client",
                whatsAppData: new MobileData(),
                mobileData: new MobileData()));
        //mobile: response.phoneNumber,
        //whatsApp: response.phoneNumber));
        await loginRepository.addorUpdateRecord(userDTOModel);
      }
      return userDTOModel;
    }
    return response;
  }

  Future<dynamic> signInUserWithEmailAndPassword(
      String emailId, String password) async {
    dynamic user =
        await loginRepository.signInWithEmailAndPassword(emailId, password);
    if (user is User) {
      User userVal = user;
      try {
        DocumentSnapshot snapshot =
            await loginRepository.getUserByUid(userVal.uid);
        if (!snapshot.exists) return "User Does not exist In Database";
        UserDTOModel userDTOModel = UserDTOModel.fromJson(
            snapshot.data() as Map<String, dynamic>, snapshot.id);
        if (!userDTOModel.isVerified) return "User Not Verified to Login";
        return userDTOModel;
      } catch (e) {
        return "there was an error:" + e.toString();
      }
    } else
      return user;
  }

  Future<dynamic> sendPasswordResetMail(String emailId) async {
    dynamic response = await loginRepository.sendPasswordResetMail(emailId);
    return response;
  }

  void addTokenToUser(String userId, TokenModel tokenModel) async {
    loginRepository.addTokenToUser(userId, tokenModel);
    return;
  }

  Future<TokenModel> getFcmToken() async {
    late String? fcmToken;
    if (kIsWeb) {
      fcmToken = await (FirebaseMessaging.instance
          .getToken(vapidKey: Constants.VAPID_KEY));
    } else
      fcmToken = (await FirebaseMessaging.instance.getToken())!;
    if (fcmToken != null) {
      print("fcm:"+fcmToken);
      return TokenModel(token: fcmToken);
    }
      return TokenModel(token: "");

  }

  Future<String> shareDynamicLinks(
      String senderId, String typeOfDeeplink) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://hanatech.page.link',
        link: Uri.parse(typeOfDeeplink == "affiliate"
            ? 'https://hanatech.com/sender?id=$senderId&type=$typeOfDeeplink'
            : 'https://hanatech.com/sender?id=$senderId&type=$typeOfDeeplink'),
        androidParameters: AndroidParameters(
          packageName: 'com.hanatech.flutter_eb',
        ),
        iosParameters: IosParameters(bundleId: ""),
        // NOT ALL ARE REQUIRED ===== HERE AS AN EXAMPLE =====
        googleAnalyticsParameters: GoogleAnalyticsParameters(
            source: 'social_network',
            campaign: "social",
            medium: "social network"),
        socialMetaTagParameters: SocialMetaTagParameters(
          title: 'Enroll As An Affiliate',
          description: 'And Earn cash',
        ),
        dynamicLinkParametersOptions: DynamicLinkParametersOptions(
            shortDynamicLinkPathLength: ShortDynamicLinkPathLength.unguessable),
        navigationInfoParameters:
            NavigationInfoParameters(forcedRedirectEnabled: false));

    final ShortDynamicLink dynamicUrl = await parameters.buildShortLink();

    return dynamicUrl.shortUrl.toString();
  }

  Future<List<AffiliateModel>> getAffiliates(String userId) async {
    QuerySnapshot affiliatesSnapshot =
        await this.loginRepository.getAffiliatesList(userId);
    List<AffiliateModel> affiliates = affiliatesSnapshot.docs.map((e) {
      return new AffiliateModel.fromMap(e.data() as Map<String, dynamic>);
    }).toList();
    Map<String, List<AffiliateModel>> affiliateModel = {};
    return affiliates;
  }

  updateUser(UserDTOModel userDTOModel) {
    this.loginRepository.updateUser(userDTOModel);
  }

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }

  String get userType => _userType;

  set userType(String value) {
    _userType = value;
  }
}
