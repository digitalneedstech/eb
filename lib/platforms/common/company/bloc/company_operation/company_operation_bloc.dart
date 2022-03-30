import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operaiton_event.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_state.dart';
import 'package:flutter_eb/platforms/common/company/model/resource_model.dart';
import 'package:flutter_eb/platforms/common/company/repo/company_repo.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/login/dto/user_dto_model.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:sprintf/sprintf.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class CompanyOperationBloc
    extends Bloc<CompanyOperationEvent, CompanyOperationState> {
  final CompanyRepository companyRepository;
  final LoginRepository loginRepository;
  final NotificationRepository notificationRepository;
  CompanyOperationBloc(
      this.companyRepository, this.notificationRepository, this.loginRepository)
      : super(CompanyOperationLoadedState());
  String notificationContent =
      "Hello %s \n You have been invited by %s to be a service provider / user in \n "
      "ExpertBunch.com which is a platform for professionals from various industries. This \n"
      "will enable you to provide service through this app/portal and earn on time basis. \n \n"
      "Click the link to join ExpertBunch service providers platform \n "
      "%s \n"
      "In case of any trouble in connecting, contact support@expertbunch.com \n"
      "Best Regards, \n"
      "EXPERT BUNCH Managment Team \n"
      "Email: ebteam@expertbunch.com";

  String notificationContentForExistingUser =
      "Thank you for being part of ExpertBunch. You have been requested to be part of %s resources group as a service "
      "provider in ExpertBunch.com. "
      "Upon accepting the change in your user status, you shall be listed as representative resources of the"
      "%s and all related process accordingly. \n"
      "Click the link to join ExpertBunch service providers platform \n "
      "%s \n"
      "In case of any trouble in connecting, contact support@expertbunch.com \n"
      "Best Regards, \n"
      "EXPERT BUNCH Managment Team \n"
      "Email: ebteam@expertbunch.com";

  @override
  Stream<CompanyOperationState> mapEventToState(
    CompanyOperationEvent event,
  ) async* {
    if (event is AddResourcesEvent) {
      yield LoadingCompanyOperationState();
      addResource(event.companyId, event.userName, event.shareLink,
          event.companyResources);
      yield AddOrUpdateResourceState(isResourceAdded: true);
    }

    if (event is UpdateResourceEvent) {
      yield LoadingCompanyOperationState();
      loginRepository.updateUser(event.companyResource);
      yield AddOrUpdateResourceState(isResourceAdded: true);
    }

    if (event is UpdateResourceConfirmEvent) {
      yield UpdateResourceLoadingConfirmState();
      try {
        companyRepository.updateResourceInCompany(
            event.companyId, event.userId, event.status);
        yield UpdateResourceConfirmState(isUpdated: true);
      } catch (e) {
        yield UpdateResourceConfirmState(isUpdated: false);
      }
    }
  }

  addResource(String userId, String userName, String shareLink,
      List<String> companyResources) async {
    Map<String,AddResourceModelValidator> resourceToBeAddedOrNot = {};
    for (String userId in companyResources) {
      QuerySnapshot userSnapshot =
          await this.loginRepository.getUserByEmail(userId);
      if (userSnapshot.docs.isEmpty)
        resourceToBeAddedOrNot[userId] = new AddResourceModelValidator(
          true,true
        );
      else {
        UserDTOModel userDTOModel = UserDTOModel.fromJson(
            userSnapshot.docs[0].data() as Map<String,dynamic>,
            userSnapshot.docs[0].id);
        if (userDTOModel.companyId != "") {
          resourceToBeAddedOrNot[userId] = new AddResourceModelValidator(
              false,true
          );
        }
      }
    }
    this.companyRepository.addResourceToCompany(userId, resourceToBeAddedOrNot);

    for (String resource in companyResources) {
      QuerySnapshot userSnapshot =
          await this.loginRepository.getUserByEmail(resource);
      NotificationMessage notificationMessageEmailPayload;
      if (userSnapshot.docs.isEmpty) {
        String shareLinkForNewEBUser = await shareDynamicLinksForNewUser(userId, "organization",resource);
        notificationMessageEmailPayload = new NotificationMessage(
            type: "mail",
            payload: NotificationMessageEmailPayload(
                resource,
                "$userName invited you to be service provider in ExpertBunch platform",
                sprintf(notificationContent, [resource, userName, shareLinkForNewEBUser])));
      } else {
        String shareLinkForExistingEBUser = await shareDynamicLinks(userId, resource);
        notificationMessageEmailPayload = new NotificationMessage(
            type: "mail",
            payload: NotificationMessageEmailPayload(
                resource,
                "You are invited to be in the team of $userName in ExpertBunch",
                sprintf(notificationContentForExistingUser,
                    [userName, userName, shareLinkForExistingEBUser])));
      }
      this
          .notificationRepository
          .sendNotification(notificationMessageEmailPayload);
    }
  }

  Future<String> shareDynamicLinksForNewUser(String senderId,
      String typeOfDeeplink,String email) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://hanatech.page.link',
        link: Uri.parse(
            '${Routers.DEEPLINK_URL}/invite?id=$senderId&type=$typeOfDeeplink&email=$email'),
        androidParameters: AndroidParameters(
          packageName: 'com.hanatech.flutter_eb',
        ),
        iosParameters: IosParameters(
            bundleId: ""
        ),
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

  Future<String> shareDynamicLinks(String companyId, String userId) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
        uriPrefix: 'https://hanatech.page.link',
        link: Uri.parse(
            "${Routers.DEEPLINK_URL}/confirmInvitation?type=company&id=$companyId&userId=$userId"),
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

  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}

class AddResourceModelValidator{
  bool isNewUser,toBeAdded;
  AddResourceModelValidator(this.isNewUser,this.toBeAdded);
}
