import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_freelancer_view/bid_detail_freelancer.dart';
import 'package:flutter_eb/platforms/common/bids/widgets/bid_detail_user_view/bid_detail.dart';
import 'package:flutter_eb/platforms/common/chat/index.dart';
import 'package:flutter_eb/platforms/common/chat/widgets/single_chat.dart';
import 'package:flutter_eb/platforms/common/company/pages/company_profile.dart';
import 'package:flutter_eb/platforms/common/company/pages/my_resources.dart';
import 'package:flutter_eb/platforms/common/confirm_notification/pages/company_confirm.dart';
import 'package:flutter_eb/platforms/common/dashboard/billing_address/billing_address.dart';
import 'package:flutter_eb/platforms/common/dashboard/experience/experience_list.dart';
import 'package:flutter_eb/platforms/common/dashboard/featured/featured_details.dart';
import 'package:flutter_eb/platforms/common/dashboard/index.dart';
import 'package:flutter_eb/platforms/common/dashboard/languages/languages.dart';
import 'package:flutter_eb/platforms/common/dashboard/licenses/licenses_list.dart';
import 'package:flutter_eb/platforms/common/dashboard/personal/personal_details.dart';
import 'package:flutter_eb/platforms/common/dashboard/profile_overview/profile_overview.dart';
import 'package:flutter_eb/platforms/common/dashboard/rates/rates.dart';
import 'package:flutter_eb/platforms/common/dashboard/skills/skills.dart';
import 'package:flutter_eb/platforms/common/dashboard/sub_company_dashboard/sub_company_dashboard.dart';
import 'package:flutter_eb/platforms/common/dashboard/sub_dashboard/index.dart';
import 'package:flutter_eb/platforms/common/groups/index.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/groups/group_detail_page/group_detail_page.dart';
import 'package:flutter_eb/platforms/common/home_nav/home_nav.dart';
import 'package:flutter_eb/platforms/common/invite/invite_tab.dart';
import 'package:flutter_eb/platforms/common/job_listing/index.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/index.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/listing_page.dart';
import 'package:flutter_eb/platforms/common/login/index.dart';
import 'package:flutter_eb/platforms/common/login/widgets/forgot_password/forgot_password.dart';
import 'package:flutter_eb/platforms/common/login/widgets/forgot_password/mail_sent.dart';
import 'package:flutter_eb/platforms/common/login/widgets/registration.dart';
import 'package:flutter_eb/platforms/common/posts/posts_list.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_detail.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelance_details.dart';
import 'package:flutter_eb/platforms/common/splash/index.dart';
import 'package:flutter_eb/platforms/common/wallet/index.dart';
import 'package:flutter_eb/platforms/web/home_web/home_web.dart';
import 'package:flutter_eb/platforms/web/how_it_works/how_it_works.dart';
import 'package:flutter_eb/platforms/web/t_and_c/t_and_c.dart';
import 'package:flutter_eb/platforms/web/web_dashboard/web_dashboard.dart';

var rootHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  return SplashPage();
});
var splashFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return SplashPage();
    });

var loginFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return LoginPage();
    });
var homeWebFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return HomeWeb();
    });

var howItWorksFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return HowItWorksPage();
    });

var termsFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return TAndCPage();
    });
var webDashboardFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return WebDashboard();
    });
var forgotPasswordFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ForgotPasswordPage();
    });


var forgotPasswordMailSentFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return MailSentPage();
    });

var registrationFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return RegistrationPage();
    });


var registrationForDeepLinkFunctionHandler = Handler(

    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? senderId = params["senderId"]?.first;
      String? typeOfDeeplink = params["typeOfDeeplink"]?.first;
      String? email = params["email"]?.first;
      return RegistrationPage(typeOfDeeplink: typeOfDeeplink!=null ?typeOfDeeplink:"",
        senderId: senderId!=null ?senderId:"",emailId: email!=null ?email:"",);
    });

var companyConfirmNotificationFunctionHandler = Handler(

    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? type = params["type"]?.first;
      String? companyId = params["companyId"]?.first;
      String? userId = params["userId"]?.first;
      if(type=="company") {
        return CompanyConfirmNotification(userId: userId != null ? userId : "",
            companyId: companyId != null ? companyId : "");
      }
    });

var landingPageFunctionHandler = Handler(

    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return HomeNav();

    });
var landingDashboardFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return HomeNav(index: 4,);

    });

var dashboardFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return DashboardPage();
    });


var subDashboardFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return SubDashboardPage();
    });

var subCompanyDashboardFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return SubCompanyDashboardPage();
    });

var myCompanyFunctionHandler = Handler(

    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return CompanyProfilePage();
    });

var myCompanyResourcesFunctionHandler = Handler(

    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ResourcesPage();
    });
//BIDS
var bidDetailForUserRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? bidId = params["bidId"]?.first;
  String? freelancerId = params["freelancerId"]?.first;
  return BidDetailPage(
      bidId: bidId!=null ? bidId:"",
      freelancerId: freelancerId!=null ? freelancerId:"",
    );

});
var bidDetailForFreelancerRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? bidId = params["bidId"]?.first;
  String? userId = params["userId"]?.first;
  String? freelancerId = params["freelancerId"]?.first;
  return BidDetailFreelancerPage(
      bidId: bidId!=null ? bidId:"",
      freelancerId: freelancerId!=null ?freelancerId:"",
      userIdOfBidder: userId!=null ? userId:"",
    );

});

//Schedule Call
var scheduleCallDetailForUserRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? scheduleId = params["scheduleId"]?.first;
      String? freelancerId = params["freelancerId"]?.first;
      return ScheduledFreelanceCallDetailPage(
        userId: freelancerId!=null ? freelancerId:"",
        scheduleId: scheduleId!=null ? scheduleId:"",
      );

    });
var scheduleCallDetailForFreelancerRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? scheduleId = params["scheduleId"]?.first;
      String? userId = params["userId"]?.first;
      return ScheduledCallDetailPage(
        userId: userId!=null ? userId:"",
        scheduleId: scheduleId!=null ? scheduleId:"",
      );

    });

var scheduledCallDetailForUserRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? scheduleId = params["scheduleId"]?.first;
  String? userId = params["userId"]?.first;
  return ScheduledCallDetailPage(
      scheduleId: scheduleId!=null ? scheduleId:"",
      userId: userId!=null ?userId:"",
    );

});

var groupFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return GroupsTab();
    });

var groupDetailRouteHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
  String? groupId = params["groupId"]?.first;
  String? isScheduleEnabled = params["scheduleEnabled"]?.first;
  String? scheduleId = params["scheduleId"]?.first;
  String? isOlderMeeting = params["isOlderMeeting"]?.first;
  return GroupDetailPage(
      groupId: groupId!=null?groupId:"",
      isScheduleEnabled: isScheduleEnabled!=null && isScheduleEnabled=="true"?true:false,
    scheduleId: scheduleId!=null ?scheduleId:"",
    isOlderMeeting: isOlderMeeting!=null && isOlderMeeting=="true"?true:false,
    );
});

var companyProfileFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return CompanyProfilePage();
    });
var companyDashboardFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return HomeNav(index: 4,);
    });

//Profile
var profileOverviewFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ProfileOverview();
    });

var personalDetailsFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return PersonalDetails();
    });

var featuredOverviewFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return FeaturedDetails();
    });

var skillsOverviewFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return SkillsPage();
    });

var experienceOverviewFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ExperienceList();
    });


var languagesOverviewFunctionHandler = Handler(

    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return Languages();
    });


var licensesOverviewFunctionHandler = Handler(

    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return LicensesList();
    });

var rateOverviewFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return Rates();
    });

var billingAddressOverviewFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return BillingAddress();
    });

//POST AND JOB LISTING
var postsFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return PostsPage();
    });
var jobListingFunctionHandler = Handler(
    
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return JobListingPage();
    });

//Search
var searchListingFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? searchType = params["searchType"]?.first;
      String? searchText = params["searchText"]?.first;
      String? isFreelanceAdditionEnabled = params["isFreelanceAdditionEnabled"]?.first;
      String? groupId=params['groupId']?.first;

      return ListingPage(
        groupId: groupId!=null ?groupId:"",
        searchByParameter: searchType!=null ?searchType:"person",
        searchText: searchText!=null ?searchText:"",
        isFreelancerAdditionEnabled: isFreelanceAdditionEnabled!=null
        && isFreelanceAdditionEnabled=="true" ?true:false,
      );
    });

//Chats
var chatFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return ChatsListPage();
    });

var chatByUserIdFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      String? userId = params["userId"]?.first;
      String? displayName = params["displayName"]?.first;

      return SingleChat(
          chatUserId: userId,
      otherUserName: displayName!=null ?displayName:"");
    });

//INVITE
var inviteFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return InviteTab();
    });
//Wallet
var walletFunctionHandler = Handler(
    handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
      return WalletPage();
    });
