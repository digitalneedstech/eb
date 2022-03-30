import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_event.dart';
import 'package:flutter_eb/platforms/common/bids/bloc/bid_state.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/bids/repo/bid_repository.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/bloc/notification_event.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/bloc/notification_state.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/models/notification_model.dart';
import 'package:flutter_eb/shared/services/notification/model/notification_message.dart';
import 'package:flutter_eb/shared/services/notification/repository/notification_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

/*
TODO- Update user model with required new model values instead of null
 */
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final NotificationRepository notificationRepository;

  NotificationBloc(this.notificationRepository) : super(NotificationLoadedState());

  @override
  Stream<NotificationState> mapEventToState(NotificationEvent event,) async* {
    List<NotificationModel> notifications=[];
    if (event is FetchNotifications) {
      yield LoadingNotificationsState();
      QuerySnapshot snapshot = await notificationRepository.fetchNotifications(event.id);
      if(snapshot.docs.isEmpty ){
        yield FetchNotificationState(notifications: notifications);
      }else {
        notifications = snapshot.docs.map((e) =>
            NotificationModel.fromMap(e.data() as Map<String,dynamic>)).toList();
        yield FetchNotificationState(notifications: notifications);
      }
    }
  }


  Future<void> close() async {
    print("Bloc closed");
    super.close();
  }
}