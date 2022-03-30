import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/shared/services/router/fluro_router_handlers.dart';
class Routers {
  static final String DEEPLINK_URL="https://hanatech.com";
  static final String HOME = "/";
  static final String HOME_WEB = "/home";
  static final String HOW_IT_WORKS = "/how-it-works";
  static final String TERMS = "/terms";
  static final String WEB_DASHBOARD = "/dashboard";
  static final String LOGIN = "/login";
  static final String REGISTRATION = "registration";
  static final String FORGOT_PASSWORD = "forgotPassword";
  static final String FORGOT_PASSWORD_MAIL_SENT = "mailSent";

  //Company Invite
  static final String COMPANY_INVITE_DEEPLINK = "invite/:senderId/:typeOfDeeplink/:email";

  //Confirm Notification
  static final String COMPANY_CONFIRM_NOTIFICATION = "confirmInvitation/:type/:companyId/:userId";
  //Search
  static final String LISTING_SEARCH="search/:searchType/:searchText/:groupId/:isFreelancerAdditionEnabled";
  static final String LISTING_SEARCH2="search";
  //Bid
  static final String BID_DETAIL_USER="bid/:bidId/:freelancerId";
  static final String BID_DETAIL_FREELANCER="bidDetail/:bidId/:userId/:freelancerId";

  //Schedule Call
  static final String SCHEDULE_CALL_DETAIL_USER="scheduleCall/:scheduleId/:freelancerId";
  static final String SCHEDULE_CALL_DETAIL_FREELANCER="scheduleCallDetail/:scheduleId/:userId";

  //Wishlist and Groups
  static final String GROUPS="groups";
  static final String GROUP_INFO_GROUP_ID="group/:groupId/:scheduleId/:scheduleEnabled/:isOlderMeeting";

  //Company
  static final String MY_COMPANY = "company";
  static final String MY_COMPANY_PROFILE = "companyProfile";
  static final String MY_COMPANY_DASHBOARD = "companyDashboard";

  //subdashboard
  static final String LANDING_PAGE = "landingPage";
  static final String LANDING_DASHBOARD = "landingDashboard";
  static final String SUB_DASHBOARD = "subDashboard";
  static final String DASHBOARD = "dashboard";
  static final String COMPANY_DASHBOARD = "companyDashboard";



  //profiles
  static final String PROFILE = "profile";
  static final String PERSONAL = "personal";
  static final String FEATURED = "featured";
  static final String LICENSES = "licenses";
  static final String RATES = "rates";
  static final String SKILLS = "skills";
  static final String EDUCATION = "education";
  static final String LANGUAGES = "languages";

  //Wallet
  static final String WALLET = "wallet";

  //Affiliate
  static final String INVITE = "invite";

  //Job Post
  static final String POST = "post";
  static final String JOB_LISTING = "jobListing";

  //Chats
  static final String CHATS = "chats";
  static final String CHATS_BY_USER_ID = "chat/:userId/:displayName";

  static final String BILLING_ADDRESS = "billingAddress";
  static final String MY_RESOURCES = "myResources";
  static final String MY_COMPANY_LINKS = "myCompanyLinks";


  static final String USER_DASHBOARD = "userDashboard";
  static final String FREELANCE_DASHBOARD = "freelanceDashboard";

  static final String LISTING_PAGE = "listingPage";


  static final String SCHEDULE_CALL = "scheduleCall";
  static final String SCHEDULE_CALL_DETAIL = "scheduleCallDetail";

  static final String BID_LIST="bidList";
  static final String BID_DETAIL="bidDetail";


  static void configureRoutesForWeb(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
          return;
        });
    router.define(HOME, handler: splashFunctionHandler);
    router.define(LOGIN, handler: loginFunctionHandler);
    router.define(HOME_WEB, handler: homeWebFunctionHandler);
    router.define(HOW_IT_WORKS, handler: howItWorksFunctionHandler);
    router.define(TERMS, handler: termsFunctionHandler);
    router.define(WEB_DASHBOARD, handler: webDashboardFunctionHandler);

    router.define(REGISTRATION, handler: registrationFunctionHandler);
    router.define(FORGOT_PASSWORD, handler: forgotPasswordFunctionHandler);
    router.define(FORGOT_PASSWORD_MAIL_SENT, handler: forgotPasswordMailSentFunctionHandler);

    //SEARCH
    router.define(LISTING_SEARCH, handler: searchListingFunctionHandler);
    router.define(LISTING_SEARCH2, handler: searchListingFunctionHandler);

    //Company Invite
    router.define(COMPANY_INVITE_DEEPLINK, handler: registrationForDeepLinkFunctionHandler);
    //CHATS
    router.define(CHATS, handler: chatFunctionHandler);
    router.define(CHATS_BY_USER_ID, handler: chatByUserIdFunctionHandler);

    //DASHBOARD
    router.define(LANDING_PAGE, handler: landingPageFunctionHandler);
    router.define(LANDING_DASHBOARD, handler: landingDashboardFunctionHandler);
    router.define(SUB_DASHBOARD, handler: subDashboardFunctionHandler);
    router.define(COMPANY_DASHBOARD, handler: companyDashboardFunctionHandler);

    //BIDDETAIL
    router.define(BID_DETAIL_USER, handler: bidDetailForUserRouteHandler);
    router.define(BID_DETAIL_FREELANCER, handler: bidDetailForFreelancerRouteHandler);

    //SCHEDULE CALL DETAIL
    router.define(SCHEDULE_CALL_DETAIL_USER, handler: scheduledCallDetailForUserRouteHandler);
    router.define(SCHEDULE_CALL_DETAIL_FREELANCER, handler: scheduleCallDetailForFreelancerRouteHandler);

    //PROFILE
    router.define(DASHBOARD, handler: dashboardFunctionHandler);
    router.define(PROFILE, handler: profileOverviewFunctionHandler);
    router.define(PERSONAL, handler: personalDetailsFunctionHandler);
    router.define(SKILLS, handler: skillsOverviewFunctionHandler);
    router.define(FEATURED, handler: featuredOverviewFunctionHandler);
    router.define(RATES, handler: rateOverviewFunctionHandler);
    router.define(EDUCATION, handler: experienceOverviewFunctionHandler);
    router.define(LICENSES, handler: licensesOverviewFunctionHandler);
    router.define(LANGUAGES, handler: languagesOverviewFunctionHandler);
    router.define(PERSONAL, handler: personalDetailsFunctionHandler);
    router.define(BILLING_ADDRESS, handler: billingAddressOverviewFunctionHandler);

    //Groups
    router.define(GROUPS, handler: groupFunctionHandler);
    router.define(GROUP_INFO_GROUP_ID, handler: groupDetailRouteHandler);

    //Schedule call
    router.define(SCHEDULE_CALL_DETAIL_USER, handler: scheduledCallDetailForUserRouteHandler);

    //POST
    router.define(POST, handler: postsFunctionHandler);
    router.define(JOB_LISTING, handler: jobListingFunctionHandler);

    //INVITE
    router.define(INVITE, handler: inviteFunctionHandler);

    //WALLET
    router.define(WALLET, handler: walletFunctionHandler);

    //MY company
    router.define(MY_COMPANY_LINKS, handler: subCompanyDashboardFunctionHandler);
    router.define(MY_COMPANY_PROFILE, handler: companyProfileFunctionHandler);
    router.define(MY_COMPANY, handler: myCompanyResourcesFunctionHandler);
  }


  static void configureRoutes(FluroRouter router) {
    router.notFoundHandler = Handler(
        handlerFunc: (BuildContext? context, Map<String, List<String>> params) {
          print("ROUTE WAS NOT FOUND !!!");
          return;
        });
    router.define(HOME, handler: splashFunctionHandler);
    router.define(LOGIN, handler: loginFunctionHandler);
    router.define(REGISTRATION, handler: registrationFunctionHandler);
    router.define(FORGOT_PASSWORD, handler: forgotPasswordFunctionHandler);
    router.define(FORGOT_PASSWORD_MAIL_SENT, handler: forgotPasswordMailSentFunctionHandler);

    //SEARCH
    router.define(LISTING_SEARCH, handler: searchListingFunctionHandler);
    router.define(LISTING_SEARCH2, handler: searchListingFunctionHandler);

    //Company Invite
    router.define(COMPANY_INVITE_DEEPLINK, handler: registrationForDeepLinkFunctionHandler);
    //CHATS
    router.define(CHATS, handler: chatFunctionHandler);
    router.define(CHATS_BY_USER_ID, handler: chatByUserIdFunctionHandler);

    //DASHBOARD
    router.define(LANDING_PAGE, handler: landingPageFunctionHandler);
    router.define(LANDING_DASHBOARD, handler: landingDashboardFunctionHandler);
    router.define(SUB_DASHBOARD, handler: subDashboardFunctionHandler);
    router.define(COMPANY_DASHBOARD, handler: companyDashboardFunctionHandler);

    //BIDDETAIL
    router.define(BID_DETAIL_USER, handler: bidDetailForUserRouteHandler);
    router.define(BID_DETAIL_FREELANCER, handler: bidDetailForFreelancerRouteHandler);

    //SCHEDULE CALL DETAIL
    router.define(SCHEDULE_CALL_DETAIL_USER, handler: scheduledCallDetailForUserRouteHandler);
    router.define(SCHEDULE_CALL_DETAIL_FREELANCER, handler: scheduleCallDetailForFreelancerRouteHandler);

    //PROFILE
    router.define(DASHBOARD, handler: dashboardFunctionHandler);
    router.define(PROFILE, handler: profileOverviewFunctionHandler);
    router.define(PERSONAL, handler: personalDetailsFunctionHandler);
    router.define(SKILLS, handler: skillsOverviewFunctionHandler);
    router.define(FEATURED, handler: featuredOverviewFunctionHandler);
    router.define(RATES, handler: rateOverviewFunctionHandler);
    router.define(EDUCATION, handler: experienceOverviewFunctionHandler);
    router.define(LICENSES, handler: licensesOverviewFunctionHandler);
    router.define(LANGUAGES, handler: languagesOverviewFunctionHandler);
    router.define(PERSONAL, handler: personalDetailsFunctionHandler);
    router.define(BILLING_ADDRESS, handler: billingAddressOverviewFunctionHandler);

    //Groups
    router.define(GROUPS, handler: groupFunctionHandler);
    router.define(GROUP_INFO_GROUP_ID, handler: groupDetailRouteHandler);

    //Schedule call
    router.define(SCHEDULE_CALL_DETAIL_USER, handler: scheduledCallDetailForUserRouteHandler);

    //POST
    router.define(POST, handler: postsFunctionHandler);
    router.define(JOB_LISTING, handler: jobListingFunctionHandler);

    //INVITE
    router.define(INVITE, handler: inviteFunctionHandler);

    //WALLET
    router.define(WALLET, handler: walletFunctionHandler);

    //MY company
    router.define(MY_COMPANY_LINKS, handler: subCompanyDashboardFunctionHandler);
    router.define(MY_COMPANY_PROFILE, handler: companyProfileFunctionHandler);
    router.define(MY_COMPANY, handler: myCompanyResourcesFunctionHandler);
  }
}