import 'package:callkeep/callkeep.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_updation_bloc/bid_updation_bloc.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_bloc.dart';
import 'package:flutter_eb/platforms/common/chat/bloc/chat_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_bloc.dart';
import 'package:flutter_eb/platforms/common/company/bloc/company_operation/company_operation_bloc.dart';
import 'package:flutter_eb/platforms/common/dashboard/bloc/profile_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat/group_chat_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_freelancer_bloc/group_freelancer_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/receiver_freelancer_page.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelance_details.dart';
import 'package:flutter_eb/platforms/common/user_feedback/bloc/user_feedback_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/chat/group_chat_operations/group_chat_operation_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_operations/group_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_update_operations/group_update_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/bloc/wishlist_bloc.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/bloc/notification_bloc.dart';
import 'package:flutter_eb/platforms/common/invite/bloc/affiliate_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/bloc/landing_operations_bloc/landing_update_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/bids_bloc/bids_update_bloc/bids_update_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/calls_bloc/calls_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/contract_bids_bloc/contract_bids.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/landing_dashboard_bloc.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/bloc/scheduled_calls_bloc/scheduled_call_bloc.dart';
import 'package:flutter_eb/platforms/common/login/bloc/login_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_applications_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/bloc/post_operations/post_operations_bloc.dart';
import 'package:flutter_eb/platforms/common/posts/bloc/post_bloc.dart';
import 'package:flutter_eb/platforms/common/ratings/bloc/ratings_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/call/call_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/bloc/schedule_bloc.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_detail.dart';
import 'package:flutter_eb/platforms/common/wallet/bloc/wallet_bloc.dart';
import 'package:flutter_eb/shared/constants/constants.dart';
import 'package:flutter_eb/platforms/common/groups/bloc/group_schedule_operations/group_schedule_update_bloc.dart';
import 'package:flutter_eb/shared/services/router/application_router.dart';
import 'package:flutter_eb/shared/services/router/routers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';


/// For fcm background message handler.
var id=1;
FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();
AndroidNotificationChannel androidNotificationChannel =
    const AndroidNotificationChannel(
        "high_importance_channel", "High Importance Channel");
bool _callKeepInited = false;
final FlutterCallkeep _callKeep = FlutterCallkeep();

Future<dynamic> myBackgroundMessageHandler(RemoteMessage message) async{
await Firebase.initializeApp();
  flutterLocalNotificationsPlugin.show(
      message.hashCode,
      message.notification!.title!,
      message.notification!.body!,
      NotificationDetails(
        android: AndroidNotificationDetails(
            androidNotificationChannel.id,
            androidNotificationChannel.name,
            // TODO add a proper drawable resource to android, for now using
            //      one that already exists in example app.
            icon: 'launch_background',
            playSound: true,
            priority: Priority.high,
            importance: Importance.max
        ),
      ));
  if (message.data["type"] == "call") {

    /*
    _callKeep.on(CallKeepPerformAnswerCallAction(),
        (CallKeepPerformAnswerCallAction event) {
      print(
          'backgroundMessage: CallKeepPerformAnswerCallAction ${event.callUUID}');
      Timer(const Duration(seconds: 1), () {
        print(
            '[setCurrentCallActive] $callUUID, callerId: $callerId, callerName: $callerName');
        _callKeep.setCurrentCallActive(callUUID);
      });
      //_callKeep.endCall(event.callUUID);
    });

    _callKeep.on(CallKeepPerformEndCallAction(),
        (CallKeepPerformEndCallAction event) {
      print(
          'backgroundMessage: CallKeepPerformEndCallAction ${event.callUUID}');
    });
    if (!_callKeepInited) {
      _callKeep.setup(null, <String, dynamic>{
        'ios': {
          'appName': 'CallKeepDemo',
        },
        'android': {
          'alertTitle': 'Permissions required',
          'alertDescription':
              'This application needs to access your phone accounts',
          'cancelButton': 'Cancel',
          'okButton': 'ok',
          'foregroundService': {
            'channelId': 'com.hanatech.eb',
            'channelName': 'Foreground service for my app',
            'notificationTitle': 'My app is running on background',
            'notificationIcon': 'Path to the resource icon of the notification',
          },
        },
      });
      _callKeepInited = true;
    }

    print('backgroundMessage: displayIncomingCall ($callerId)');
    _callKeep.displayIncomingCall(callUUID, callerId,
        localizedCallerName: callerName, hasVideo: hasVideo);
    _callKeep.backToForeground();



  if (message.containsKey('data')) {
    // Handle data message
    final dynamic data = message['data'];
  }

  if (message.containsKey('notification')) {
    // Handle notification message
    final dynamic notification = message['notification'];
    print('notification => ${notification.toString()}');
  }
*/
    // Or do other work.

  }
  return Future.value("1");
}

class Call {
  Call(this.number);
  String number;
  bool held = false;
  bool muted = false;
}

class MyApp extends StatefulWidget {
  final loginRepository;
  final profileRepository;
  final searchListingRepository;
  final bidRepository;
  final landingDashbordRepo;
  final scheduleRepo;
  final groupRepository;
  final chatRepository;
  final wishListRepository;
  final postRepository;
  final companyRepository;
  final walletRepository;
  final notificationRepository;
  final ratingRepository;
  MyApp(
      {this.postRepository,
      this.ratingRepository,
      this.notificationRepository,
      this.walletRepository,
      this.companyRepository,
      this.wishListRepository,
      this.chatRepository,
      this.loginRepository,
      this.scheduleRepo,
      this.landingDashbordRepo,
      this.profileRepository,
      this.searchListingRepository,
      this.bidRepository,
      this.groupRepository});
  MyAppState createState() => MyAppState(
      bidRepository: bidRepository,
      chatRepository: chatRepository,
      companyRepository: companyRepository,
      groupRepository: groupRepository,
      landingDashbordRepo: landingDashbordRepo,
      loginRepository: loginRepository,
      notificationRepository: notificationRepository,
      postRepository: postRepository,
      profileRepository: profileRepository,
      ratingRepository: ratingRepository,
      scheduleRepo: scheduleRepo,
      searchListingRepository: searchListingRepository,
      walletRepository: walletRepository,
      wishListRepository: wishListRepository);
}

class MyAppState extends State<MyApp> {
  final loginRepository;
  final profileRepository;
  final searchListingRepository;
  final bidRepository;
  final landingDashbordRepo;
  final scheduleRepo;
  final groupRepository;
  final chatRepository;
  final wishListRepository;
  final postRepository;
  final companyRepository;
  final walletRepository;
  final notificationRepository;
  final ratingRepository;
  MyAppState(
      {this.postRepository,
      this.ratingRepository,
      this.notificationRepository,
      this.walletRepository,
      this.companyRepository,
      this.wishListRepository,
      this.chatRepository,
      this.loginRepository,
      this.scheduleRepo,
      this.landingDashbordRepo,
      this.profileRepository,
      this.searchListingRepository,
      this.bidRepository,
      this.groupRepository});
  // This widget is the root of your application.

  @override
  void initState() {
    super.initState();
    final router = FluroRouter();
    if(kIsWeb)
      Routers.configureRoutesForWeb(router);
    else
      Routers.configureRoutes(router);
    ApplicationRouter.router = router;
    FirebaseMessaging.instance.getInitialMessage().then((remoteMessage) {
      if(remoteMessage!=null){
        Map msgData = remoteMessage.data;

        if (msgData['type'] == "call") {
          final callUUID = "call_uuid_1";

          // #region answer_call_action
          _callKeep.on(CallKeepPerformAnswerCallAction(), (event) async {
            /*print(
                'backgroundMessage: CallKeepPerformAnswerCallAction ${event.callUUID}');*/
            Timer(const Duration(seconds: 1), () {
              _callKeep.setCurrentCallActive(callUUID);
              _callKeep.setMutedCall(callUUID, true);
            });
            _redirectWhenNotificationIsClicked(remoteMessage, context);
          });
          // #endregion

          // #region end_call_action
          _callKeep.on(CallKeepPerformEndCallAction(),
                  (CallKeepPerformEndCallAction event) {
                print(
                    'backgroundMessage: CallKeepPerformEndCallAction ${event.callUUID}');
                //engine.leaveChannel();
              });
          // #endregion

          if (!_callKeepInited) {
            _callKeep.setup(null, <String, dynamic>{
              'ios': {
                'appName': 'CallKeepDemo',
              },
              'android': {
                'alertTitle': 'Permissions required',
                'alertDescription':
                'This application needs to access your phone accounts',
                'cancelButton': 'Cancel',
                'okButton': 'ok',
                'foregroundService': {
                  'channelId': 'com.hanatech.eb',
                  'channelName': 'Foreground service for my app',
                  'notificationTitle': 'My app is running on background',
                  'notificationIcon': 'Path to the resource icon of the notification',
                },
              },
            },backgroundMode: true);
            _callKeepInited = true;
          }
          print('backgroundMessage: displayIncomingCall (user B)');
          _callKeep.displayIncomingCall(callUUID, 'user_B');
          _callKeep.backToForeground();
        }
        _redirectWhenNotificationIsClicked(remoteMessage, context);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _initializeNotification(context);
    final app = MultiBlocProvider(
      providers: [
        BlocProvider<LandingBloc>(
            create: (context) =>
                LandingBloc(searchListingRepository, groupRepository)),
        BlocProvider<UserFeedbackBloc>(
            create: (context) => UserFeedbackBloc(loginRepository)),
        BlocProvider<BidBloc>(
            create: (context) =>
                BidBloc(bidRepository, notificationRepository)),
        BlocProvider<LoginBloc>(
            create: (context) =>
                LoginBloc(loginRepository, notificationRepository)),
        BlocProvider<ProfileBloc>(
            create: (context) =>
                ProfileBloc(loginRepository, profileRepository)),
        BlocProvider<CallsDashboardBloc>(
            create: (context) =>
                CallsDashboardBloc(landingDashbordRepo, loginRepository)),
        BlocProvider<ContractsBidsBloc>(
            create: (context) =>
                ContractsBidsBloc(landingDashbordRepo, loginRepository)),
        BlocProvider<ScheduledCallsDashboardBloc>(
            create: (context) => ScheduledCallsDashboardBloc(
                landingDashbordRepo, loginRepository)),
        BlocProvider<BidsDashboardBloc>(
            create: (context) =>
                BidsDashboardBloc(landingDashbordRepo, loginRepository)),
        BlocProvider<BidUpdationBloc>(
            create: (context) =>
                BidUpdationBloc(bidRepository, notificationRepository)),
        BlocProvider<BidsDashboardUpdateBloc>(
            create: (context) => BidsDashboardUpdateBloc(landingDashbordRepo)),
        BlocProvider<ScheduledBloc>(
            create: (context) => ScheduledBloc(
                scheduleRepo, loginRepository, notificationRepository)),
        BlocProvider<CallBloc>(
            create: (context) => CallBloc(
                scheduleRepo, notificationRepository, groupRepository,loginRepository)),
        BlocProvider<LandingDashboardBloc>(
            create: (context) => LandingDashboardBloc(landingDashbordRepo)),
        BlocProvider<LandingUpdateBloc>(
            create: (context) =>
                LandingUpdateBloc(groupRepository, bidRepository)),
        BlocProvider<GroupBloc>(
            create: (context) => GroupBloc(
                groupRepository, bidRepository, notificationRepository)),
        BlocProvider<GroupFreelancerBloc>(
            create: (context) =>
                GroupFreelancerBloc(groupRepository, notificationRepository)),
        BlocProvider<GroupOperationsBloc>(
            create: (context) =>
                GroupOperationsBloc(groupRepository, notificationRepository)),
        BlocProvider<GroupUpdateOperationsBloc>(
            create: (context) => GroupUpdateOperationsBloc(
                groupRepository, notificationRepository)),
        BlocProvider<GroupChatBloc>(
            create: (context) => GroupChatBloc(groupRepository)),
        BlocProvider<GroupChatOperationBloc>(
            create: (context) => GroupChatOperationBloc(groupRepository)),
        BlocProvider<ChatBloc>(
            create: (context) => ChatBloc(chatRepository, loginRepository)),
        BlocProvider<WishListBloc>(
            create: (context) =>
                WishListBloc(wishListRepository, loginRepository)),
        BlocProvider<PostBloc>(
            create: (context) => PostBloc(
                postRepository, loginRepository, notificationRepository)),
        BlocProvider<CompanyBloc>(
            create: (context) => CompanyBloc(companyRepository)),
        BlocProvider<CompanyOperationBloc>(
            create: (context) => CompanyOperationBloc(
                companyRepository, notificationRepository, loginRepository)),
        BlocProvider<PostApplicantBloc>(
            create: (context) => PostApplicantBloc(
                postRepository, loginRepository, notificationRepository)),
        BlocProvider<PostOperationsBloc>(
            create: (context) => PostOperationsBloc(postRepository)),
        BlocProvider<WalletBloc>(
            create: (context) =>
                WalletBloc(walletRepository, notificationRepository)),
        BlocProvider<AffiliateBloc>(
            create: (context) =>
                AffiliateBloc(notificationRepository, loginRepository)),
        BlocProvider<NotificationBloc>(
            create: (context) => NotificationBloc(notificationRepository)),
        BlocProvider<RatingBloc>(
            create: (context) => RatingBloc(ratingRepository)),
        BlocProvider<GroupScheduleUpdateOperationsBloc>(
            create: (context) =>
                GroupScheduleUpdateOperationsBloc(groupRepository))
      ],
      child: MaterialApp(
        title: Constants.APP_NAME,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          backgroundColor: Colors.grey.shade200,
          fontFamily: 'Poppins',
          appBarTheme: AppBarTheme(
            color: Color(0xFF23374D),
          ),
          //primarySwatch: color: Color(0xFF23374D),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        onGenerateRoute: ApplicationRouter.router.generator,
      ),
    );
    return app;
  }

  _initializeNotification(BuildContext context) async {
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("Onmessage");
      if (message.notification != null && message.notification!.title != null
          && message.notification!.body != null) {
        Map msgData = message.data;

        if (msgData['type'] == "call") {
          final callUUID = "call_uuid_1";

          // #region answer_call_action
          _callKeep.on(CallKeepPerformAnswerCallAction(), (event) async {
            /*print(
                'backgroundMessage: CallKeepPerformAnswerCallAction ${event.callUUID}');*/
            Timer(const Duration(seconds: 1), () {
              _callKeep.setCurrentCallActive(callUUID);
              _callKeep.setMutedCall(callUUID, true);
            });
            _redirectWhenNotificationIsClicked(message, context);
          });
          // #endregion

          // #region end_call_action
          _callKeep.on(CallKeepPerformEndCallAction(),
                  (CallKeepPerformEndCallAction event) {
                print(
                    'backgroundMessage: CallKeepPerformEndCallAction ${event
                        .callUUID}');
                //engine.leaveChannel();
              });
          // #endregion

          if (!_callKeepInited) {
            _callKeep.setup(null, <String, dynamic>{
              'ios': {
                'appName': 'CallKeepDemo',
              },
              'android': {
                'alertTitle': 'Permissions required',
                'alertDescription':
                'This application needs to access your phone accounts',
                'cancelButton': 'Cancel',
                'okButton': 'ok',
                'foregroundService': {
                  'channelId': 'com.hanatech.eb',
                  'channelName': 'Foreground service for my app',
                  'notificationTitle': 'My app is running on background',
                  'notificationIcon': 'Path to the resource icon of the notification',
                },
              },
            }, backgroundMode: true);
            _callKeepInited = true;
          }
          print('backgroundMessage: displayIncomingCall (user B)');
          _callKeep.displayIncomingCall(callUUID, 'user_B');
          _callKeep.backToForeground();
        }
        if(message.data["sound"]==null || message.data["sound"]=="default") {
          flutterLocalNotificationsPlugin.show(
              id++,
              message.notification!.title!,
              message.notification!.body!,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  androidNotificationChannel.id,
                  androidNotificationChannel.name,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'launch_background',
                  //          sound: RawResourceAndroidNotificationSound(message.data["sound"]),
                  //        playSound: true,
                  //       priority: Priority.high,
                  //       importance: Importance.max
                ),
              ));
        }
        else{
          flutterLocalNotificationsPlugin.show(
              id++,
              message.notification!.title!,
              message.notification!.body!,
              NotificationDetails(
                android: AndroidNotificationDetails(
                  androidNotificationChannel.id,
                  androidNotificationChannel.name,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'launch_background',
                            sound: RawResourceAndroidNotificationSound(message.data["sound"]),
                          playSound: true,

                ),

              ));
        }
      }

    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      _redirectWhenNotificationIsClicked(message, context);
    });
    /*FirebaseMessaging.instance.configure(
      //onBackgroundMessage: myBackgroundMessageHandler,
      onMessage: (Map<String, dynamic> message) async {
        print("Onmessage");

        */ /*flutterLocalNotificationsPlugin.show(
          message.hashCode,
              message["notification"]["title"],
          message["notification"]["body"],
              NotificationDetails(
                android: AndroidNotificationDetails(
                  androidNotificationChannel.id,
                  androidNotificationChannel.name,
                  androidNotificationChannel.description,
                  // TODO add a proper drawable resource to android, for now using
                  //      one that already exists in example app.
                  icon: 'launch_background',
                ),
              ));*/ /*

        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              content: ListTile(
                title: Text(message['notification']['title']),
                subtitle: Text(message['notification']['body']),
              ),
            ));
      },
      onResume: (Map<String, dynamic> message) async {
        if (message["type"] == "schedule"){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ScheduledCallDetailPage(
              scheduleId: message["refId"],userId: message["userId"],
            )),
          );
        }
        if(message["type"=="bid"]){
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => BidDetailFreelancerPage(
                bidId: message["refId"],userIdOfBidder: message["userId"]
            )),
          );
        }
        print("message");
      },
      onLaunch: (Map<String, dynamic> message) async {
        print("onLaunch:${message}");
      },
      //onBackgroundMessage: myBackgroundMessageHandler
    );
*/
  }

  void _redirectWhenNotificationIsClicked(RemoteMessage message, BuildContext context) {
    if (message.data["type"] == "schedule") {
      message.data["for"] == "user" ?
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScheduledCallDetailPage(
              scheduleId: message.data["refId"],
              userId: message.data["userId"],
            )),
      ):
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ScheduledFreelanceCallDetailPage(
                  scheduleId: message.data["refId"],
                  userId: message.data["userId"],
                )),
      );
    }
    if (message.data["type"] == "bid") {
      message.data["for"] == "freelancer"
          ? Navigator.pushNamed(
              context,
              "bidDetail/" +
                  message.data["refId"] +
                  "/" +
                  message.data["additionalId"])
          : Navigator.pushNamed(
              context,
              "bid/" +
                  message.data["refId"] +
                  "/" +
                  message.data["additionalId"]);
    }
    if (message.data["type"] == "call") {
      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => ReceiverFreelancerPage(
              channelId: message.data["refId"],
              groupId: message.data["groupId"],
            )),
      );
    }
  }
}
