import 'dart:async';

import 'package:callkeep/callkeep.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:dio/dio.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/repo/bid_repository.dart';
import 'package:flutter_eb/platforms/common/chat/repo/chat_repository.dart';
import 'package:flutter_eb/platforms/common/company/repo/company_repo.dart';
import 'package:flutter_eb/platforms/common/dashboard/data/profile_repository.dart';
import 'package:flutter_eb/platforms/common/groups/repo/group_repository.dart';
import 'package:flutter_eb/platforms/common/groups/widgets/wishlist/repo/wishlist_repository.dart';
import 'package:flutter_eb/platforms/common/landing_page/data/search_listing_repository.dart';
import 'package:flutter_eb/platforms/common/landing_page/widgets/dashboard/repo/landing_repo.dart';
import 'package:flutter_eb/platforms/common/login/data/login_repository.dart';
import 'package:flutter_eb/platforms/common/posts/repo/post_repository.dart';
import 'package:flutter_eb/platforms/common/ratings/repo/rating_repo.dart';
import 'package:flutter_eb/platforms/common/schedule/data/schedule_repository.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/receiver_freelancer_page.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/schedule_detail.dart';
import 'package:flutter_eb/platforms/common/schedule/widgets/scheduled_freelance_details.dart';
import 'package:flutter_eb/platforms/common/wallet/data/wallet_repository.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import './app/my_app.dart';
bool _callKeepInited = false;
final FlutterCallkeep  _callKeep = FlutterCallkeep();

Future<void> myBackgroundMessageHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
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
                      sound: RawResourceAndroidNotificationSound("sound"),
                    playSound: true,
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

Future<void> main()async {
  WidgetsFlutterBinding.ensureInitialized();
  Dio dio = Dio();
  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(myBackgroundMessageHandler);
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  //setUrlStrategy(PathUrlStrategy());
  runApp(MyApp(
    loginRepository: new LoginRepository(),
    profileRepository: new ProfileRepository(dio),
    bidRepository: new BidRepository(),
    searchListingRepository: new SearchListingRepository(dio),
    landingDashbordRepo: new LandingRepo(),
    scheduleRepo: new ScheduleRepository(dio),
    groupRepository: new GroupRepository(dio),
    chatRepository: new ChatRepository(),
    wishListRepository: new WishListRepository(),
    postRepository: new PostRepository(),
    companyRepository: new CompanyRepository(),
    walletRepository: new WalletRepository(dio),
    notificationRepository: new NotificationRepository(dio),
    ratingRepository: new RatingRepository(),
  ));
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
            message.data["userId"])
        : Navigator.pushNamed(
        context,
        "bid/" +
            message.data["refId"] +
            "/" +
            message.data["userId"]);
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