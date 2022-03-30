import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_eb/platforms/common/bids/model/bid_model.dart';
import 'package:flutter_eb/platforms/common/home_nav/notifications/models/notification_model.dart';

@immutable
abstract class NotificationState extends Equatable {}
class NotificationLoadedState extends NotificationState {

  @override
  List<Object> get props => [];
}
class FetchNotificationState extends NotificationState {
  List<NotificationModel> notifications;
  FetchNotificationState({required this.notifications});
  @override
  List<Object> get props => [];
}


class LoadingNotificationsState extends NotificationState {
  @override
  List<Object> get props => [];
}
